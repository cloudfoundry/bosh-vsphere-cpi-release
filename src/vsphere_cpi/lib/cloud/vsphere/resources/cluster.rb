require 'cloud/vsphere/logger'
require 'cloud/vsphere/resources/resource_pool'

module VSphereCloud
  module Resources
    class Cluster
      include VimSdk
      include ObjectStringifier
      include Logger
      stringify_with :name

      CLUSTER_VM_GROUP_SUFFIX = '_vm_group'.freeze
      CLUSTER_VM_HOST_RULE_SUFFIX = '_rule'.freeze
      CLUSTER_VM_HOST_RULE_SHOULD = 'SHOULD'.freeze
      CLUSTER_VM_HOST_RULE_MUST = 'MUST'.freeze
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
      def initialize(cluster_config, properties, client)
        @client = client
        @properties = properties

        @config = cluster_config
        @mob = properties[:obj]
        @resource_pool = ResourcePool.new(@client, cluster_config, properties['resourcePool'])
      end

      # @return [Integer] amount of free memory in the cluster
      def free_memory
        return @synced_free_memory if @synced_free_memory
        # Have to use separate mechanisms for fetching utilization depending on
        # whether we're using resource pools or raw clusters.
        if @config.resource_pool.nil?
          # Get cluster utilization only if host group is nil
          @synced_free_memory = if host_group.nil?
            fetch_cluster_utilization
          else
            fetch_host_group_utilization
          end
        else
          @synced_free_memory = fetch_resource_pool_utilization
        end
      end

      # Returns a default name made from host group and vm group.
      #
      # @return [String] Name of the host VM affinity rule name.
      def vm_host_affinity_rule_name
        # This first return might never get invoked as we always check host group
        # to be present before calling this function.
        # Just in case somebody uses this function in future without checking
        # host group, this function will be safe.
        return nil if host_group.nil?
        vm_group + CLUSTER_VM_HOST_RULE_SUFFIX
      end

      # Returns a host group name if specified in cluster config. Otherwise,
      # it returns a nil.
      #
      # @return [String] Name of the host Group specified under a cluster config.
      def host_group
        config.host_group_name
      end

      # Returns a host group rule if specified in cluster config. Otherwise,
      # it returns a nil.
      #
      # @return [String] Name of the host Group rule type specified under a cluster config.
      def host_group_drs_rule
        config.host_group_drs_rule
      end

      # it returns a default name created by adding suffix to host group name
      #
      # @return [String] Name of the VM Group
      def vm_group
        return nil if host_group.nil?
        # TODO TA SG : Derive a shorter unique name (unique across process calls from the host group name only. Using rand will create multiple vm groups with 1 vm each.
        # if host_group.length > 100
        #   return "#{self.rule_type_suffix}-vm_group-#{(0...6).map { (97 + rand(26)).chr }.join}"
        # end
        host_group + self.rule_type_suffix + CLUSTER_VM_GROUP_SUFFIX
      end

      def rule_type_suffix
        rule_type = host_group_drs_rule
        # rule_type can never be nil as Cluster Config
        # makes sure to return default 'SHOULD'
        rule_type.strip.casecmp?(CLUSTER_VM_HOST_RULE_MUST) == false ?
            CLUSTER_VM_HOST_RULE_SHOULD :
            CLUSTER_VM_HOST_RULE_MUST
      end
      alias host_group_rule_type rule_type_suffix

      def host_group_mob
        return nil if host_group.nil?
        result_host_group = mob.configuration_ex.group.find do |group|
          group.name == host_group && group.is_a?(VimSdk::Vim::Cluster::HostGroup)
        end
        raise "Failed to find the HostGroup: #{host_group} in Cluster: #{name}" if result_host_group.nil?
        result_host_group
      end

      # Caches and returns the list of hosts under a cluster resource. It might
      # be different from total hosts in a cluster if a host group is specified.
      #
      # If a host group is present,  only the hosts under the host group are
      # considered.
      #
      # @return [List] List of hosts in the cluster resource.
      def host
        return @host if @host
        @host = host_group_mob.nil? ? mob.host : host_group_mob.host
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

      attr_reader :config, :client, :properties

      def select_datastores(pattern)
        accessible_datastores.select { |name, datastore| name =~ pattern }
      end

      # Fetches memory utilization of host group. calculates raw available memory.
      #
      # Raises an error if and only if all hosts fail to report stats.
      #
      # @return RAW available memory in the host group
      def fetch_host_group_utilization
        # Reject all non-normal state hosts.
        # Maintenance hosts report all stats so we need to filter them
        logger.debug("Fetching Memory utilization for Host Group #{host_group}")
        healthy_hosts = host_group_mob.host.select do |host|
          host.runtime.connection_state == 'connected' && !host.runtime.in_maintenance_mode
        end
        if healthy_hosts.empty?
          logger.debug("No fit host found in #{host_group}") if healthy_hosts.empty?
          return 0
        end

        total_memory = healthy_hosts.map do |host|
          host.hardware&.memory_size
        end.compact.sum

        # Return immediately if hosts in host group fail to report memory stats.
        if total_memory == 0
          logger.debug("Host Group #{host_group} reported total memory statistics as 0")
          return 0
        end

        used_memory = healthy_hosts.map do |host|
          # Overall memory usage is in MB. Convert it to Bytes.
          host.summary.quick_stats.overall_memory_usage * BYTES_IN_MB
        end.compact.sum
        logger.warning("Host Group #{host_group} reported 0 bytes used memory") if used_memory == 0
        (total_memory - used_memory) / BYTES_IN_MB
      end

      # Fetches the raw cluster utilization from vSphere.
      #
      # @return
      def fetch_cluster_utilization()
        logger.debug("Fetching Memory utilization for Cluster #{self.mob.name}")
        properties = @client.cloud_searcher.get_properties(mob, Vim::ClusterComputeResource, 'summary')
        raise "Failed to get utilization for cluster'#{self.mob.name}'" if properties.nil?

        compute_resource_summary = properties["summary"]
        return compute_resource_summary.effective_memory
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
        logger.debug("Fetching Memory utilization for Resource Pool #{resource_pool.name}")
        properties = @client.cloud_searcher.get_properties(resource_pool.mob, Vim::ResourcePool, 'summary')
        raise "Failed to get utilization for resource pool '#{resource_pool}'" if properties.nil?

        runtime_info = properties["summary"].runtime
        memory = runtime_info.memory
        return (memory.max_usage - memory.overall_usage) / BYTES_IN_MB
      end
    end
  end
end
