require 'cloud/vsphere/logger'

module VSphereCloud
  class NSXTRouterProvider
    include Logger
    extend Hooks

    def initialize(client_builder)
      @client_builder = client_builder
    end

    def create_t1_router(edge_cluster_id, name = nil)
      router_api.create_logical_router(edge_cluster_id: edge_cluster_id,
                                        router_type: 'TIER1',
                                        display_name: name)
    end

    def delete_t1_router(t1_router_id)
      router_api.delete_logical_router(t1_router_id, force: true)
    end

    def get_edge_cluster_id(t0_router_id)
      router = router_api.read_logical_router(t0_router_id)
      raise "Router #{t0_router_id} does not have edge cluster id." if router.edge_cluster_id.nil?
      router.edge_cluster_id
    end

    def enable_route_advertisement(router_id)
      config = router_api.read_advertisement_config(router_id)
      config.advertise_nsx_connected_routes = true
      config.enabled = true
      router_api.update_advertisement_config(router_id, config)
    end

    def get_attached_router_ids(switch_id)
      router_ports = router_api.list_logical_router_ports(logical_switch_id: switch_id)
      router_ports.results.map(&:logical_router_id)
    end

    def get_attached_switches_ids(t1_router_id)
      router_ports = router_api.list_logical_router_ports(logical_router_id: t1_router_id,
                                                          resource_type: 'LogicalRouterDownLinkPort')
      router_ports.results.select do |port|
        port.linked_logical_switch_port_id.is_valid
      end.map do |valid_port|
        valid_port.linked_logical_switch_port_id.target_id
      end
    end

    def attach_t1_to_t0(t0_router_id, t1_router_id)
      begin
        t0_router_port =  NSXT::LogicalRouterLinkPortOnTIER0.new(logical_router_id: t0_router_id,
                                                                 resource_type: 'LogicalRouterLinkPortOnTIER0')
        t0_router_port = router_api.create_logical_router_port(t0_router_port)
      rescue => e
        logger.error("Error creating port on T0 router #{t0_router_id}. Exception: #{e.inspect}")
        raise "Error creating port on #{t0_router_id} T0 router. Exception: #{e.inspect}"
      end

      begin
        t0_reference = NSXT::ResourceReference.new(target_id: t0_router_port.id,
                                                   target_type: 'LogicalRouterLinkPortOnTIER0')
        t1_router_port = NSXT::LogicalRouterLinkPortOnTIER1.new(linked_logical_router_port_id: t0_reference,
                                                                logical_router_id: t1_router_id,
                                                                resource_type: 'LogicalRouterLinkPortOnTIER1')
        router_api.create_logical_router_port(t1_router_port)
      rescue => e
        logger.error("Error creating port on T1 router #{t1_router_id} and attaching it to T0 port #{t0_router_port.id}. Exception: #{e.inspect}")
        raise "Error creating port on T1 (#{t1_router_id}) and attaching it to T0 port #{t0_router_port.id}. Exception: #{e.inspect}"
      end
    end

    def attach_switch_to_t1(switch_port_id, t1_router_id, ip_address, prefix_length)
      begin
        subnet = NSXT::IPSubnet.new(ip_addresses: [ ip_address ],prefix_length: prefix_length)
        switch_port_ref = NSXT::ResourceReference.new(target_id: switch_port_id,
                                                      target_type: 'LogicalPort')
        t1_router_port = NSXT::LogicalRouterDownLinkPort.new(logical_router_id: t1_router_id,
                                                             linked_logical_switch_port_id: switch_port_ref,
                                                             resource_type: 'LogicalRouterDownLinkPort',
                                                             subnets: [subnet])
        router_api.create_logical_router_port(t1_router_port)
      rescue => e
        logger.error("Failed to create logical port for router #{t1_router_id} and switch #{switch_port_id}. Exception: #{e.inspect}")
        raise "Failed to create logical port for router #{t1_router_id} and switch #{switch_port_id}. Exception: #{e.inspect}"
      end
    end

    def detach_t1_from_t0(t1_router_id)
      t1_router_ports = router_api.list_logical_router_ports(logical_router_id: t1_router_id).results
      t1_router_ports.each do |t1_port|
        if t1_port.resource_type == 'LogicalRouterLinkPortOnTIER1'
          t0_router_port = t1_port.linked_logical_router_port_id
          if t0_router_port.target_type == 'LogicalRouterLinkPortOnTIER0'
            logger.debug("Deleting T0 port #{t0_router_port.target_id}")
            router_api.delete_logical_router_port(t0_router_port.target_id, force: true)
          end
        end
      end
    end

    before(*instance_methods) { require 'nsxt_manager_client/nsxt_manager_client' }

    private

    def router_api
      @router_api ||= NSXT::LogicalRoutingAndServicesApi.new(@client_builder.get_client)
    end
  end
end
