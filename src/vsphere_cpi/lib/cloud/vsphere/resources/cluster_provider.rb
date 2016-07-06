module VSphereCloud
  module Resources
    class ClusterProvider
      def initialize(options)
        @datacenter_name = options.fetch(:datacenter_name)
        @client = options.fetch(:client)
        @logger = options.fetch(:logger)
      end

      def find(name, config)
        cluster_mob = cluster_mobs[name]
        raise "Can't find cluster '#{name}'" if cluster_mob.nil?

        cluster_properties = @client.cloud_searcher.get_properties(
          cluster_mob, VimSdk::Vim::ClusterComputeResource,
          Cluster::PROPERTIES, :ensure_all => true
        )
        raise "Can't find properties for cluster '#{name}'" if cluster_properties.nil?

        Cluster.new(
          config,
          cluster_properties,
          @logger,
          @client
        )
      end

      private

      def datacenter_mob
        mob = @client.find_by_inventory_path(@datacenter_name)
        raise "Datacenter '#{@datacenter_name}' not found" if mob.nil?
        mob
      end

      def cluster_mobs
        @cluster_mobs ||= begin
          cluster_tuples = @client.cloud_searcher.get_managed_objects(
            VimSdk::Vim::ClusterComputeResource,
            root: datacenter_mob,
            include_name: true
          )
          Hash[*(cluster_tuples.flatten)]
        end
      end
    end
  end
end
