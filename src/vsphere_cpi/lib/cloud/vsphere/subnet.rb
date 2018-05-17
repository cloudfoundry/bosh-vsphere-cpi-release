require 'netaddr'

module VSphereCloud
  class Subnet
    def self.build(nsxt_provider, subnet_definition, logger)
      new(nsxt_provider, subnet_definition, logger).tap(&:validate)
    end

    def initialize(nsxt_provider, subnet_definition, logger)
      @nsxt_provider = nsxt_provider
      @subnet_definition = subnet_definition
      @logger = logger
    end

    def create
      begin
        cloud_properties = @subnet_definition['cloud_properties']
        ip_subnet = NSXT::IPSubnet.new({ip_addresses: [@gateway.ip],
                                        prefix_length: @range.netmask[1..-1].to_i})
        t1_router = @nsxt_provider.create_t1_router(cloud_properties['edge_cluster_id'], cloud_properties['t1_name'])
        t1_router_id = t1_router.id
        @nsxt_provider.enable_route_advertisement(t1_router_id)
        @nsxt_provider.attach_t1_to_t0(cloud_properties['t0_router_id'], t1_router_id)
        switch = @nsxt_provider.create_logical_switch(cloud_properties['transport_zone_id'], cloud_properties['switch_name'])
        switch_id = switch.id
        @nsxt_provider.attach_switch_to_t1(switch_id, t1_router_id, ip_subnet)
      rescue => e
        @logger.error('Failed to create subnet. Trying to clean up')
        @nsxt_provider.delete_t1_router(t1_router_id) unless t1_router_id.nil?
        @nsxt_provider.delete_logical_switch(switch_id) unless switch_id.nil?
        raise "Failed to create subnet. Has router been created: #{!t1_router_id.nil?}. Has switch been created: #{!switch_id.nil?}. Exception: #{e.inspect}"
      end
      switch
    end

    def self.destroy(nsxt_provider, switch_id)
      raise 'switch id must be provided for deleting a subnet' if switch_id.nil?
      t1_router_ids = nsxt_provider.get_attached_router_ids(switch_id)
      raise "Expected switch #{switch_id} to have one router attached. Found #{t1_router_ids.length}" if t1_router_ids.length != 1
      switch_ports = nsxt_provider.get_attached_switch_ports(switch_id)
      raise "Expected switch #{switch_id} to have only one port. Got #{switch_ports.length}" if switch_ports.length != 1
      nsxt_provider.delete_logical_switch(switch_id)
      t1_router_id = t1_router_ids.first
      attached_switches = nsxt_provider.get_attached_switches_ids(t1_router_id)
      raise "Can not delete router #{t1_router_id}. It has extra ports that are not created by BOSH." if attached_switches.length != 0
      nsxt_provider.delete_t1_router(t1_router_id)
    end

    def validate
      cloud_properties = @subnet_definition['cloud_properties']
      raise 'cloud_properties must be provided' if nil_or_empty(cloud_properties)
      raise 't0_router_id cloud property can not be empty' if nil_or_empty(cloud_properties['t0_router_id'])
      raise 'edge_cluster_id cloud property can not be empty' if nil_or_empty(cloud_properties['edge_cluster_id'])
      raise 'transport_zone_id cloud property can not be empty' if nil_or_empty(cloud_properties['transport_zone_id'])

      raise 'Incorrect subnet definition. Proper CIDR block range must be given' if nil_or_empty(@subnet_definition['range'])
      raise 'Incorrect subnet definition. Proper gateway must be given' if nil_or_empty(@subnet_definition['gateway'])
      @range = NetAddr::CIDR.create(@subnet_definition['range'])
      @gateway = NetAddr::CIDR.create(@subnet_definition['gateway'])
      raise 'Incorrect subnet definition. Proper gateway must be given' if @gateway.size > 1
    end

    private

    def nil_or_empty(val)
      val.nil? || val.empty?
    end
  end
end