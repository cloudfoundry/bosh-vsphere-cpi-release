module VSphereCloud
  class IpPoolProvider
    def initialize(client)
      @client = client
    end


    def read_ip_pool
      ippool = pool_api.read_ip_pool('3adbace9-0ed8-4d48-9952-7d8be27f404c')
      ippool.tags = [NSXT::Tag.new({scope: "subnets", tag: ''})]
      pool_api.update_ip_pool(ippool.id, ippool)
      ippool = pool_api.read_ip_pool('3adbace9-0ed8-4d48-9952-7d8be27f404c')
    end

    def pool_api
      @pool_api ||= NSXT::PoolManagementApi.new(@client)
    end
  end
end