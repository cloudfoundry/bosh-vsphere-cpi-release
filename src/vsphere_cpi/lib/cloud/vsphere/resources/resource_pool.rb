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
      def initialize(client, cluster_config, root_resource_pool, datacenter_name)
        @cluster_config = cluster_config
        @root_resource_pool = root_resource_pool
        @client = client
        @datacenter_name = datacenter_name
      end

      def name
        mob.name
      end

      def mob
        return @mob if @mob

        if @cluster_config.resource_pool.nil?
          @mob = @root_resource_pool
        else
          resource_pool_path_suffix = URI.escape(@cluster_config.resource_pool)
          datacenter_cluster_path_prefix = "#{URI.escape(@datacenter_name)}/host/#{URI.escape(@cluster_config.name)}/Resources/"
          full_inventory_path = datacenter_cluster_path_prefix + resource_pool_path_suffix
          # Replace all multiple consecutive / with single /
          full_inventory_path.gsub!(/\/+/, '/').chomp!('/')
          @mob = @client.service_content.search_index.find_by_inventory_path(full_inventory_path)
          return @mob unless @mob.nil?

          logger.warn("Could not find resource pool #{resource_pool_path_suffix} for inventory path #{full_inventory_path}")

          logger.info("Trying to find #{@cluster_config.resource_pool} through property collector")
          @mob = @client.cloud_searcher.get_managed_object(
              Vim::ResourcePool,
              :root => @root_resource_pool,
              :name => @cluster_config.resource_pool)
          raise "Could not find resource pool #{@cluster_config.resource_pool}" if @mob.nil?
          logger.debug("Found requested resource pool: #{@mob.name}")
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
