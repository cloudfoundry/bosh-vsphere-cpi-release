module VSphereCloud
  class Subnet
    def self.build(subnet_definition)
      new(subnet_definition).tap(&:validate)
    end

    def initialize(subnet_definition)
      @subnet_definition = subnet_definition
    end

    def validate
      cloud_properties = @subnet_definition['cloud_properties']
      raise 'cloud_properties must be provided' if nil_or_empty(cloud_properties)
      raise 't0_router_id cloud property can not be empty' if nil_or_empty(cloud_properties['t0_router_id'])
      raise 'edge_cluster_id cloud property can not be empty' if nil_or_empty(cloud_properties['edge_cluster_id'])
      raise 'transport_zone_id cloud property can not be empty' if nil_or_empty(cloud_properties['transport_zone_id'])

      raise 'Incorrect subnet definition. Proper CIDR block range must be given' if nil_or_empty(@subnet_definition['range'])
      raise 'Incorrect subnet definition. Proper gateway must be given' if nil_or_empty(@subnet_definition['gateway'])
      if ! /^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$/.match(@subnet_definition['range'])
        raise 'Incorrect subnet definition. Proper CIDR block range must be given'
      end
      if ! /^([0-9]{1,3}\.){3}[0-9]{1,3}?$/.match(@subnet_definition['gateway'])
        raise 'Incorrect subnet definition. Proper gateway must be given'
      end
      # if (!range.nil? && range.include?('/'))
      #   _, mask = range.split("/")
      #   return NSXT::IPSubnet.new({:ip_addresses => [gateway],
      #                              :prefix_length => mask.to_i})
      # end
      # raise 'Incorrect subnet definition. Proper CIDR block must be given'
    end

    private

    def nil_or_empty(val)
      val.nil? || val.empty?
    end
  end
end