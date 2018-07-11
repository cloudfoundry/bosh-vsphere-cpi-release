require 'cloud/vsphere/logger'
require 'netaddr'

module VSphereCloud
  class Network
    include Logger
    TAG_SCOPE_NAME = 'bosh_cpi_subnet_id'

    def initialize(switch_provider, router_provider, ip_block_provider)
      @switch_provider = switch_provider
      @router_provider = router_provider
      @ip_block_provider = ip_block_provider
    end

    # Create T1 router and virtual switch attached to it
    def create(network_definition)
      begin
        range_prefix, gateway = identify_subnet_range_prefix_and_gateway(network_definition)
        edge_cluster_id = get_edge_cluster_id(network_definition.t0_router_id)
        fail_if_switch_exists(network_definition.switch_name) unless network_definition.switch_name.nil?

        t1_router_id = create_t1_router(edge_cluster_id, network_definition.t1_name)
        enable_route_advertisement(t1_router_id)

        logger.debug("Attaching T1(#{t1_router_id}) to T0(#{network_definition.t0_router_id})")
        @router_provider.attach_t1_to_t0(network_definition.t0_router_id, t1_router_id)

        if @block_subnet
          tags = [ NSXT::Tag.new(scope: TAG_SCOPE_NAME, tag: @block_subnet.id) ]
        end

        logger.info("Creating logical switch in zone #{network_definition.transport_zone_id}")
        switch = @switch_provider.create_logical_switch(network_definition.transport_zone_id,
                                                        name: network_definition.switch_name,
                                                        tags: tags)
        switch_id = switch.id
        logger.debug("Attaching switch(#{switch_id}) to T1(#{t1_router_id})")
        attach_switch_to_t1(switch_id, t1_router_id, gateway, range_prefix)
      rescue => e
        logger.error('Failed to create network. Trying to clean up')
        @router_provider.delete_t1_router(t1_router_id) unless t1_router_id.nil?
        @switch_provider.delete_logical_switch(switch_id) unless switch_id.nil?
        @ip_block_provider.release_subnet(@block_subnet.id) unless @block_subnet.nil?
        raise "Failed to create network. Has router been created: #{!t1_router_id.nil?}. Has switch been created: #{!switch_id.nil?}. Exception: #{e.message}"
      end

      if @block_subnet
        ManagedNetwork.new(switch, @block_subnet.cidr, gateway)
      else
        ManagedNetwork.new(switch)
      end
    end

    def destroy(switch_id)
      logger.info("Destroying network infrastructure with switch id #{switch_id}")
      raise 'switch id must be provided for deleting a network' if switch_id.nil?
      #check is switch exists first
      switch = @switch_provider.get_switch_by_id(switch_id)
      t1_router_ids = @router_provider.get_attached_router_ids(switch_id)
      raise "Expected switch #{switch_id} to have one router attached. Found #{t1_router_ids.length}" if t1_router_ids.length != 1
      switch_ports = @switch_provider.get_attached_switch_ports(switch_id)
      raise "Expected switch #{switch_id} to have only one port. Got #{switch_ports.length}" if switch_ports.length != 1

      release_subnets(switch.tags)
      logger.debug("Deleting logical switch with id #{switch_id}")
      @switch_provider.delete_logical_switch(switch_id)
      t1_router_id = t1_router_ids.first
      attached_switches = @router_provider.get_attached_switches_ids(t1_router_id)
      raise "Can not delete router #{t1_router_id}. It has extra ports that are not created by BOSH." if attached_switches.length != 0

      logger.debug("Detach T1 router #{t1_router_id} from T0")
      @router_provider.detach_t1_from_t0(t1_router_id)

      logger.debug("Deleteing router with id #{t1_router_id}")
      @router_provider.delete_t1_router(t1_router_id)
    end

    private

    def identify_subnet_range_prefix_and_gateway(network_definition)
      if network_definition.has_range?
        [network_definition.range_prefix, network_definition.gateway]
      else
        logger.debug("Trying to allocate subnet in ip block #{network_definition.ip_block_id}")
        @block_subnet = @ip_block_provider.allocate_cidr_range(network_definition.ip_block_id, block_size(network_definition.netmask_bits))
        logger.info("Allocated subnet #{@block_subnet.cidr} in block #{network_definition.ip_block_id}")
        block_subnet_cidr = NetAddr::CIDR.create(@block_subnet.cidr).to_i
        [network_definition.netmask_bits, NetAddr::CIDR.create(block_subnet_cidr + 1).ip]
      end
    end

    def get_edge_cluster_id(t0_router_id)
      logger.debug("Getting edge cluster id of router #{t0_router_id}")
      @router_provider.get_edge_cluster_id(t0_router_id)
    end

    def create_t1_router(edge_cluster_id, t1_name)
      logger.info("Creating T1 router in cluster #{edge_cluster_id}")
      @router_provider.create_t1_router(edge_cluster_id, t1_name).id
    end

    def enable_route_advertisement(t1_router_id)
      logger.debug("Enable route advertisement for router #{t1_router_id}")
      @router_provider.enable_route_advertisement(t1_router_id)
    end

    def block_size(netmask_bits)
      2 ** (32 - netmask_bits)
    end

    def release_subnets(tags)
      return if tags.nil?
      tags.each do |tag|
        if tag.scope == TAG_SCOPE_NAME
          logger.debug("Releasing subnet with id #{tag.tag}")
          @ip_block_provider.release_subnet(tag.tag)
        end
      end
    end

    def attach_switch_to_t1(switch_id, t1_router_id, ip_address, prefix_length)
      logical_port = @switch_provider.create_logical_port(switch_id)
      @router_provider.attach_switch_to_t1(logical_port.id, t1_router_id, ip_address, prefix_length)
    end

    def fail_if_switch_exists(switch_name)
      switches = @switch_provider.get_switches_by_name(switch_name)
      raise "Switch #{switch_name} already exists. Please use different name." if switches.length > 0
    end
  end
end