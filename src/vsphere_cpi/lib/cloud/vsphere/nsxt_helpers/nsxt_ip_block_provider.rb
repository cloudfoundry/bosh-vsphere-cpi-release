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
    #
    # def has_range(subnet, netmask_bits)
    #   subnet_netmask = NetAddr::CIDR.create(subnet.cidr).netmask[1..-1].to_i
    #   subnet_netmask == netmask_bits
    # end
    #
    # def allocated(subnet_cidr, ip_pool)
    #   ip_pool.tags.any? do |tag|
    #     tag.scope == 'allocated' && tag.tag == subnet_cidr
    #   end
    # end
    #
    # def set_pool_allocation_tag(ip_pool, subnet_cidr)
    #   ip_pool.tags.push NSXT::Tag.new({scope: 'allocated', tag: subnet_cidr})
    #   pool_api.update_ip_pool(ip_pool.id, ip_pool)
    # end

    def pool_api
      @pool_api ||= NSXT::PoolManagementApi.new(@client)
    end
  end
end