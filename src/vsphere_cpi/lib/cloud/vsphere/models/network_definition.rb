module VSphereCloud
  class NetworkDefinition
    using ObjectHelpers
    DEFAULT_NETMASK_BITS = 24

    attr_reader :netmask_bits, :gateway, :t0_router_id, :transport_zone_id,
                :switch_name, :t1_name, :ip_block_id

    def initialize(network_definition)
      cloud_properties = network_definition['cloud_properties']
      raise 'cloud_properties must be provided' if cloud_properties.blank?
      @t0_router_id = cloud_properties['t0_router_id']
      raise 't0_router_id cloud property can not be empty' if @t0_router_id.blank?
      @transport_zone_id = cloud_properties['transport_zone_id']
      raise 'transport_zone_id cloud property can not be empty' if @transport_zone_id.blank?

      if network_definition['range'].blank?
        @ip_block_id = network_definition['cloud_properties']['ip_block_id']
        raise 'ip_block_id does not exist in cloud_properties' if @ip_block_id.blank?
        raise 'Incorrect network definition. Gateway must not be provided when using netmask bits' unless network_definition['gateway'].blank?
        if network_definition['netmask_bits'].blank?
          @netmask_bits = DEFAULT_NETMASK_BITS
        else
          @netmask_bits = Integer(network_definition['netmask_bits']) rescue false
        end
        raise 'Incorrect network definition. Proper CIDR block range or netmask bits must be given' if !@netmask_bits
        raise 'Incorrect network definition. Proper CIDR block range or netmask bits must be given' if @netmask_bits < 1 || @netmask_bits > 32
      else
        raise 'Incorrect network definition. Proper gateway must be given' if network_definition['gateway'].blank?
        @range = NetAddr::CIDR.create(network_definition['range'])
        @gateway = NetAddr::CIDR.create(network_definition['gateway'])
        raise 'Incorrect network definition. Proper gateway must be given' if @gateway.size > 1
        @gateway = @gateway.ip
      end
      @switch_name = if_present(cloud_properties['switch_name'])
      @t1_name = if_present(cloud_properties['t1_name'])
    end

    def range_prefix
      @range.netmask[1..-1].to_i
    end

    def has_range?
      !@range.nil?
    end

    def if_present(value)
      return nil if value.nil?
      return nil if value.empty?
      value
    end
  end
end