module VSphereCloud
  class VmPlacement
    attr_reader :cluster, :hosts, :datastores,
      :balance_score_set

    attr_accessor :migration_size, :disk_placement, :fallback_disk_placements

    def initialize(cluster:, hosts:, datastores:)
      @cluster = cluster
      @hosts = hosts
      @datastores = datastores
      @balance_score_set = Set.new
      @migration_size = 0
    end

    def ==(other)
      instance_of?(other.class) && other.cluster.name == cluster.name
    end
    alias eql? ==

    def hash
      cluster.name.hash
    end

    def balance_score
      return @balance_score if defined? @balance_score

      # Only happens if there are no disks to be configured.
      # TODO Check if this is even possible in real scenarios?
      return 0 if balance_score_set.empty?

      free_spaces = balance_score_set.map(&:free_space).sort

      min = free_spaces.first
      mean = free_spaces.sum / free_spaces.length
      median = free_spaces[free_spaces.length / 2]

      @balance_score = min + mean + median
    end

    def cluster_free_memory_mb
      cluster.free_memory.cluster_free_memory_mb
    end

    def host_group_free_memory_mb
      cluster.free_memory.host_group_free_memory_mb
    end

    def inspect_before
      "VM Placement Cluster: #{cluster.name} hosts: #{hosts} datastores: #{datastores}"
    end

    def inspect
      "VM Placement Cluster: #{cluster.name} for ephemeral disk: #{disk_placement},
      balance score #{balance_score}, balance score set: #{balance_score_set.inspect}"
    end

    def cluster_inspect
      "VM Placement Cluster: #{cluster.name} Cluster free memory (MiB): #{cluster_free_memory_mb}, host group free memory (MiB): #{host_group_free_memory_mb}"
    end

    def datastore_inspect
      "VM Placement #{datastores}"
    end
  end

  class VmPlacementSelectionPipeline < SelectionPipeline
    class VmPlacementCriteria
      DEFAULT_MEMORY_HEADROOM_MB = 128

      attr_reader :disk_config, :req_memory_mb, :mem_headroom_mb

      def required_memory_mb
        req_memory_mb + mem_headroom_mb
      end

      def initialize(criteria = {})
        @disk_config = criteria[:disk_config]
        @req_memory_mb = criteria[:req_memory_mb]
        @mem_headroom_mb = criteria[:mem_headroom_mb] || DEFAULT_MEMORY_HEADROOM_MB
      end

      def inspect
        "VM Placement Criteria: Disk Config: #{disk_config}  Req Memory (MiB): #{req_memory_mb}  Mem Headroom (MiB): #{mem_headroom_mb}"
      end
    end
    private_constant :VmPlacementCriteria

    with_filter do |vm_placement, criteria_object|
      logger.debug("Filter #{vm_placement.cluster_inspect} for free memory required (MiB): #{criteria_object.required_memory_mb}")
      vm_placement.cluster_free_memory_mb > criteria_object.required_memory_mb
    end

    with_filter ->(vm_placement, criteria_object) do
      logger.debug("Filter #{vm_placement.inspect_before} for combination of DS satisfying disk configurations")
      criteria_object.disk_config.each do |disk|
        logger.debug("Trying to find placement for #{disk.inspect}")
        existing_ds_name = disk.existing_datastore_name

        # Only persistent disks will have existing_ds_name
        if existing_ds_name =~ Regexp.new(disk.target_datastore_pattern)
          datastore = vm_placement.datastores.find do |ds|
            ds.name == existing_ds_name
          end
          unless datastore.nil?
            vm_placement.balance_score_set << datastore
            next
          end
        end

        # There are two possibilities at this point. Either:
        #   1. The disk is an ephemeral disk
        #   2. The disk is a persistent disk that must be migrated
        pipeline = DiskPlacementSelectionPipeline.new(disk.size, disk.target_datastore_pattern, nil, disk.ephemeral?, criteria_object.required_memory_mb) do
          vm_placement.datastores
        end.with_filter do |storage_placement|
          # TODO: both accessible? and accessible_from? will be queried for
          # each datastore
          storage_placement.resource.accessible_from?(vm_placement.cluster)
        end

        result = pipeline.each.first

        logger.debug("Failed to find placement for #{disk.inspect}") if result.nil?
        return false if result.nil?

        logger.debug("Found #{result.inspect} for #{disk.inspect}")
        vm_placement.disk_placement = result unless disk.existing_datastore_name
        vm_placement.fallback_disk_placements =  pipeline.each.to_a - [result] if disk.ephemeral?

        logger.debug("Found alternative disk placements: #{vm_placement.fallback_disk_placements}") if disk.ephemeral?
        result.free_space -= disk.size
        vm_placement.balance_score_set << result
        vm_placement.migration_size += disk.size if disk.existing_datastore_name
      end
      true
    end

    with_scorer do |p1, p2|
      p1.migration_size <=> p2.migration_size
    end

    with_scorer do |p1, p2|
      -(p1.balance_score <=> p2.balance_score)
    end

    with_scorer do |p1, p2|
      -(p1.host_group_free_memory_mb <=> p2.host_group_free_memory_mb)
    end

    def initialize(*args)
      super(VmPlacementCriteria.new(*args))
    end

    def inspect
      "VM Allocator with #{object.inspect}"
    end
  end
end
