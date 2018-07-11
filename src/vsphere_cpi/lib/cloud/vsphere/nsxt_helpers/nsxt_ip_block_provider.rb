require 'netaddr'

module VSphereCloud
  class NSXTIpBlockProvider
    def initialize(client)
      @client = client
    end

    # @return [IpBlockSubnet]
    def allocate_cidr_range(block_id, block_size)
      sn = NSXT::IpBlockSubnet.new(block_id: block_id, size: block_size)
      pool_api.create_ip_block_subnet(sn)
    end

    def release_subnet(subnet_id)
      pool_api.delete_ip_block_subnet(subnet_id)
    end

    def pool_api
      @pool_api ||= NSXT::PoolManagementApi.new(@client)
    end
  end
end