require 'netaddr'

module VSphereCloud
  class Network
    include Logger

    def self.build(switch_provider, router_provider, ip_block_provider)
      new(switch_provider, router_provider, ip_block_provider)
    end

    def initialize(switch_provider, router_provider, ip_block_provider)
      @switch_provider = switch_provider
      @router_provider = router_provider
      @ip_block_provider = ip_block_provider
    end

    #creates T1 router and virtual switch attached to it
    def create(network_definition)
      validate(network_definition)
      begin
        cloud_properties = network_definition['cloud_properties']
        ip_subnet = identify_subnet_range
        edge_cluster_id = @router_provider.get_edge_cluster_id(cloud_properties['t0_router_id'])
        fail_if_switch_exists(cloud_properties['switch_name'])

        logger.info("Creating T1 router in cluster #{edge_cluster_id}")
        t1_router = @router_provider.create_t1_router(edge_cluster_id, cloud_properties['t1_name'])
        t1_router_id = t1_router.id
        @router_provider.enable_route_advertisement(t1_router_id)
        @router_provider.attach_t1_to_t0(cloud_properties['t0_router_id'], t1_router_id)

        switch_ops = {name: cloud_properties['switch_name']}
        if @block_subnet_id
          switch_ops[:tags] = [ NSXT::Tag.new({scope: 'subnet_id', tag: @block_subnet_id}) ]
        end
        logger.info("Creating logical switch in zone #{cloud_properties['transport_zone_id']}")
        switch = @switch_provider.create_logical_switch(cloud_properties['transport_zone_id'], switch_ops)
        switch_id = switch.id
        attach_switch_to_t1(switch_id, t1_router_id, ip_subnet)
      rescue => e
        logger.error('Failed to create network. Trying to clean up')
        @router_provider.delete_t1_router(t1_router_id) unless t1_router_id.nil?
        @switch_provider.delete_logical_switch(switch_id) unless switch_id.nil?
        @ip_block_provider.release_subnet(@block_subnet_id) unless @block_subnet_id.nil?
        raise "Failed to create network. Has router been created: #{!t1_router_id.nil?}. Has switch been created: #{!switch_id.nil?}. Exception: #{e.message}"
      end
      ManagedNetwork.new(switch)
    end

    def destroy(switch_id)
      logger.info("Deleting network(switch) with id #{switch_id}")
      raise 'switch id must be provided for deleting a network' if switch_id.nil?
      t1_router_ids = @router_provider.get_attached_router_ids(switch_id)
      raise "Expected switch #{switch_id} to have one router attached. Found #{t1_router_ids.length}" if t1_router_ids.length != 1
      switch_ports = @switch_provider.get_attached_switch_ports(switch_id)
      raise "Expected switch #{switch_id} to have only one port. Got #{switch_ports.length}" if switch_ports.length != 1

      switch = @switch_provider.get_switch_by_id(switch_id)
      release_subnets(switch.tags)
      @switch_provider.delete_logical_switch(switch_id)
      t1_router_id = t1_router_ids.first
      attached_switches = @router_provider.get_attached_switches_ids(t1_router_id)
      raise "Can not delete router #{t1_router_id}. It has extra ports that are not created by BOSH." if attached_switches.length != 0
      @router_provider.delete_t1_router(t1_router_id)
    end

    private

    def validate(network_definition)
      cloud_properties = network_definition['cloud_properties']
      raise 'cloud_properties must be provided' if nil_or_empty(cloud_properties)
      raise 't0_router_id cloud property can not be empty' if nil_or_empty(cloud_properties['t0_router_id'])
      raise 'transport_zone_id cloud property can not be empty' if nil_or_empty(cloud_properties['transport_zone_id'])

      if nil_or_empty(network_definition['range']) && nil_or_empty(network_definition['netmask_bits'])
        raise 'Incorrect network definition. Proper CIDR block range or netmask bits must be given'
      end

      if nil_or_empty(network_definition['range'])
        @ip_block_id = network_definition['cloud_properties']['ip_block_id']
        raise 'ip_block_id does not exist in cloud_properties' if nil_or_empty(@ip_block_id)
        raise 'Incorrect network definition. Gateway must not be provided when using netmask bits' unless nil_or_empty(network_definition['gateway'])
        @network_bits = Integer(network_definition['netmask_bits']) rescue false
        raise 'Incorrect network definition. Proper CIDR block range or netmask bits must be given' if !@network_bits
        raise 'Incorrect network definition. Proper CIDR block range or netmask bits must be given' if @network_bits < 1 || @network_bits > 32
      else
        raise 'Incorrect network definition. Proper gateway must be given' if nil_or_empty(network_definition['gateway'])
        @range = NetAddr::CIDR.create(network_definition['range'])
        @gateway = NetAddr::CIDR.create(network_definition['gateway'])
        raise 'Incorrect network definition. Proper gateway must be given' if @gateway.size > 1
      end
    end

    def identify_subnet_range
      if @range && @gateway
        NSXT::IPSubnet.new({ip_addresses: [@gateway.ip],
                            prefix_length: @range.netmask[1..-1].to_i})
      else
        logger.debug("Trying to allocate subnet in ip block #{@ip_block_id}")
        block_subnet = @ip_block_provider.allocate_cidr_range(@ip_block_id, block_size)
        @block_subnet_id = block_subnet.id
        logger.info("Allocated subnet #{block_subnet.cidr} in block #{@ip_block_id}")
        block_subnet_cidr = NetAddr::CIDR.create(block_subnet.cidr).to_i
        gateway_ip = NetAddr::CIDR.create(block_subnet_cidr + 1)
        NSXT::IPSubnet.new({ip_addresses: [gateway_ip.ip],
                            prefix_length: @network_bits})
      end
    end

    def block_size
      2 ** (32 - @network_bits)
    end

    def release_subnets(tags)
      return if tags.nil?
      tags.each do |tag|
        if tag.scope == 'subnet_id'
          @ip_block_provider.release_subnet(tag.tag)
        end
      end
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