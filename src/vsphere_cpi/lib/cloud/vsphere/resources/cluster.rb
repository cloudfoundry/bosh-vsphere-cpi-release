require 'cloud/vsphere/resources/resource_pool'

module VSphereCloud
  module Resources
    class Cluster
      include VimSdk
      include ObjectStringifier
      stringify_with :name

      PROPERTIES = %w(name datastore resourcePool host)
      HOST_PROPERTIES = %w(name hardware.memorySize runtime.connectionState runtime.inMaintenanceMode runtime.powerState)
      HOST_COUNTERS = %w(mem.usage.average)

      MEMORY_HEADROOM = 128

      # @!attribute mob
      #   @return [Vim::ClusterComputeResource] cluster vSphere MOB.
      attr_reader :mob

      # @!attribute resource_pool
      #   @return [ResourcePool] resource pool.
      attr_reader :resource_pool

      # Creates a new Cluster resource from the specified datacenter, cluster
      # configuration, and prefetched properties.
      #
      # @param [CloudConfig] VSphereCloud::Config
      # @param [ClusterConfig] config cluster configuration as specified by the
      #   operator.
      # @param [Hash] properties prefetched vSphere properties for the cluster.
      def initialize(cluster_config, properties, logger, client)
        @logger = logger
        @client = client
        @properties = properties

        @config = cluster_config
        @mob = properties[:obj]
        @resource_pool = ResourcePool.new(@client, @logger, cluster_config, properties['resourcePool'])
      end

      # @return [Integer] amount of free memory in the cluster
      def free_memory
        return @synced_free_memory if @synced_free_memory
        # Have to use separate mechanisms for fetching utilization depending on
        # whether we're using resource pools or raw clusters.
        if @config.resource_pool.nil?
          @synced_free_memory = fetch_cluster_utilization(properties['host'])
        else
          @synced_free_memory = fetch_resource_pool_utilization
        end
      end

      # @return [String] cluster name.
      def name
        config.name
      end

      # @return [String] debug cluster information.
      def inspect
        "<Cluster: #{mob} / #{config.name}>"
      end

      def accessible_datastores
        @accessible_datastores ||= Datastore.build_from_client(
          @client,
          properties['datastore']
        ).select { |datastore| datastore.accessible }
        .inject({}) do |acc, datastore|
          acc[datastore.name] = datastore
          acc
        end
      end

      private

      attr_reader :config, :client, :properties, :logger

      def select_datastores(pattern)
        accessible_datastores.select { |name, datastore| name =~ pattern }
      end

      # Fetches the raw cluster utilization from vSphere.
      #
      # First filter out any hosts that are in maintenance mode. Then aggregate
      # individual host capacity and its utilization using the performance
      # manager.
      #
      # @param [Array<Vim::HostSystem>] cluster_host_systems cluster hosts.
      # @return [void]
      def fetch_cluster_utilization(cluster_host_systems)
        hosts_properties = @client.cloud_searcher.get_properties(
          cluster_host_systems, Vim::HostSystem, HOST_PROPERTIES, ensure_all: true)
        active_host_mobs = select_active_host_mobs(hosts_properties)

        synced_free_memory = 0
        return synced_free_memory if active_host_mobs.empty?

        cluster_free_memory = 0

        counters = @client.get_perf_counters(active_host_mobs, HOST_COUNTERS, max_sample: 5)
        counters.each do |host_mob, counter|
          host_properties = hosts_properties[host_mob]
          total_memory = host_properties['hardware.memorySize'].to_i
          free_memory = 0
          if !counter['mem.usage.average'].nil?
            percent_used = Util.average_csv(counter['mem.usage.average']) / 10000
            free_memory = ((1.0 - percent_used) * total_memory).to_i
          else
            logger.warn("host '#{host_properties['name']}' is missing 'mem.usage.average' (possibly recently booted), ignoring")
          end

          cluster_free_memory += free_memory
        end

        cluster_free_memory / BYTES_IN_MB
      end

      # Filters out the hosts that are in maintenance mode.
      #
      # @param [Hash] host_properties host properties that already fetched
      #   inMaintenanceMode from vSphere.
      # @return [Array<Vim::HostSystem>] list of hosts that are active
      def select_active_host_mobs(host_properties)
        host_properties.values.
          select { |p|
            p['runtime.inMaintenanceMode'] != 'true' &&
              p['runtime.connectionState'] == 'connected' &&
              p['runtime.powerState'] == 'poweredOn'
          }.
          collect { |p| p[:obj] }
      end

      # Fetches the resource pool utilization from vSphere.
      #
      # We can only rely on the vSphere data if the resource pool is healthy.
      # Otherwise we mark the resources as unavailable.
      #
      # Unfortunately this method does not work for the root resource pool,
      # so we can't use it for the raw clusters.
      #
      # @return [void]
      def fetch_resource_pool_utilization
        properties = @client.cloud_searcher.get_properties(resource_pool.mob, Vim::ResourcePool, 'summary')
        raise "Failed to get utilization for resource pool '#{resource_pool}'" if properties.nil?

        runtime_info = properties["summary"].runtime

        if runtime_info.overall_status == "green"
          memory = runtime_info.memory
          return (memory.max_usage - memory.overall_usage) / BYTES_IN_MB
        else
          logger.warn("Ignoring cluster: #{config.name} resource_pool: " +
                         "#{resource_pool.mob} as its state is " +
                         "unreliable: #{runtime_info.overall_status}")
          return 0
        end
      end
    end
  end
end
