require 'cloud/vsphere/logger'

module VSphereCloud
  module Resources
    class ResourcePool
      include VimSdk
      include Logger

      # Creates a new ResourcePool resource.
      #
      # @param [Cluster] cluster parent cluster.
      # @param [Vim::ResourcePool] root_resource_pool cluster's root resource
      #   pool.
      def initialize(client, cluster_config, root_resource_pool)
        @cluster_config = cluster_config
        @root_resource_pool = root_resource_pool
        @client = client
      end

      def name
        mob.name
      end

      def mob
        return @mob if @mob

        if @cluster_config.resource_pool.nil?
          @mob = @root_resource_pool
        else
          client = @client
          @mob = client.cloud_searcher.get_managed_object(
            Vim::ResourcePool,
            :root => @root_resource_pool,
            :name => @cluster_config.resource_pool)
          logger.debug("Found requested resource pool: #{@mob}")
        end
        @mob
      end

      # @return [String] debug resource pool information.
      def inspect
        "<Resource Pool: #{mob}>"
      end
    end
  end
end
