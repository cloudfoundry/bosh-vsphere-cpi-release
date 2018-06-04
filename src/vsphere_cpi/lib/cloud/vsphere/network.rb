require 'netaddr'

module VSphereCloud
  class Network
    def self.build(nsxt_provider, switch_provider, router_provider, network_definition, logger)
      new(nsxt_provider, switch_provider, router_provider, network_definition, logger).tap(&:validate)
    end

    def initialize(nsxt_provider, switch_provider, router_provider, network_definition, logger)
      @nsxt_provider = nsxt_provider
      @switch_provider = switch_provider
      @router_provider = router_provider
      @network_definition = network_definition
      @logger = logger
    end

    #creates T1 router and virtual switch attached to it
    def create
      begin
        cloud_properties = @network_definition['cloud_properties']
        ip_subnet = NSXT::IPSubnet.new({ip_addresses: [@gateway.ip],
                                        prefix_length: @range.netmask[1..-1].to_i})
        edge_cluster_id = @router_provider.get_edge_cluster_id(cloud_properties['t0_router_id'])
        fail_if_switch_exists(cloud_properties['switch_name'])

        t1_router = @router_provider.create_t1_router(edge_cluster_id, cloud_properties['t1_name'])
        t1_router_id = t1_router.id
        @router_provider.enable_route_advertisement(t1_router_id)
        @router_provider.attach_t1_to_t0(cloud_properties['t0_router_id'], t1_router_id)

        switch = @switch_provider.create_logical_switch(cloud_properties['transport_zone_id'], cloud_properties['switch_name'])
        switch_id = switch.id
        attach_switch_to_t1(switch_id, t1_router_id, ip_subnet)
      rescue => e
        @logger.error('Failed to create network. Trying to clean up')
        @router_provider.delete_t1_router(t1_router_id) unless t1_router_id.nil?
        @switch_provider.delete_logical_switch(switch_id) unless switch_id.nil?
        raise "Failed to create network. Has router been created: #{!t1_router_id.nil?}. Has switch been created: #{!switch_id.nil?}. Exception: #{e.inspect}"
      end
      ManagedNetwork.new(switch)
    end

    def self.destroy(nsxt_provider, switch_provider, router_provider, switch_id)
      raise 'switch id must be provided for deleting a network' if switch_id.nil?
      t1_router_ids = router_provider.get_attached_router_ids(switch_id)
      raise "Expected switch #{switch_id} to have one router attached. Found #{t1_router_ids.length}" if t1_router_ids.length != 1
      switch_ports = switch_provider.get_attached_switch_ports(switch_id)
      raise "Expected switch #{switch_id} to have only one port. Got #{switch_ports.length}" if switch_ports.length != 1
      switch_provider.delete_logical_switch(switch_id)
      t1_router_id = t1_router_ids.first
      attached_switches = router_provider.get_attached_switches_ids(t1_router_id)
      raise "Can not delete router #{t1_router_id}. It has extra ports that are not created by BOSH." if attached_switches.length != 0
      router_provider.delete_t1_router(t1_router_id)
    end

    def validate
      cloud_properties = @network_definition['cloud_properties']
      raise 'cloud_properties must be provided' if nil_or_empty(cloud_properties)
      raise 't0_router_id cloud property can not be empty' if nil_or_empty(cloud_properties['t0_router_id'])
      raise 'transport_zone_id cloud property can not be empty' if nil_or_empty(cloud_properties['transport_zone_id'])

      raise 'Incorrect network definition. Proper CIDR block range must be given' if nil_or_empty(@network_definition['range'])
      raise 'Incorrect network definition. Proper gateway must be given' if nil_or_empty(@network_definition['gateway'])
      @range = NetAddr::CIDR.create(@network_definition['range'])
      @gateway = NetAddr::CIDR.create(@network_definition['gateway'])
      raise 'Incorrect network definition. Proper gateway must be given' if @gateway.size > 1
    end

    class ManagedNetwork
      def initialize(switch)
        @switch = switch
      end

      def as_hash
        {
            network_cid: @switch.id,
            cloud_properties: {
                name: @switch.display_name
            }
        }
      end

      def to_json(opts)
        as_hash.to_json
      end
    end

    private

    def attach_switch_to_t1(switch_id, t1_router_id, subnet)
      logical_port = @switch_provider.create_logical_port(switch_id)
      @router_provider.attach_switch_to_t1(logical_port.id, t1_router_id, subnet)
    end

    def fail_if_switch_exists(switch_name)
      return if nil_or_empty(switch_name)
      switches = @switch_provider.get_switches_by_name(switch_name)
      raise "Switch #{switch_name} already exists. Please use different name." if switches.length > 0
    end

    def nil_or_empty(val)
      val.nil? || val.empty?
    end
  end
end