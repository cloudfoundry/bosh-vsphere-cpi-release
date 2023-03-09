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

    def cluster_free_memory
      cluster.free_memory.cluster_free_memory
    end

    def host_group_free_memory
      cluster.free_memory.host_group_free_memory
    end

    def inspect_before
      "VM Placement Cluster: #{cluster.name} hosts: #{hosts} datastores: #{datastores}"
    end

    def inspect
      "VM Placement Cluster: #{cluster.name} for ephemeral disk: #{disk_placement},
      balance score #{balance_score}, balance score set: #{balance_score_set.inspect}"
    end

    def cluster_inspect
      "VM Placement Cluster: #{cluster.name} Cluster free memory: #{cluster_free_memory}, host group free memory: #{host_group_free_memory}"
    end

    def datastore_inspect
      "VM Placement #{datastores}"
    end
  end

  class VmPlacementSelectionPipeline < SelectionPipeline
    class VmPlacementCriteria
      DEFAULT_MEMORY_HEADROOM = 128

      attr_reader :disk_config, :req_memory, :mem_headroom

      def required_memory
        req_memory + mem_headroom
      end

      def initialize(criteria = {})
        @disk_config = criteria[:disk_config]
        @req_memory = criteria[:req_memory]
        @mem_headroom = criteria[:mem_headroom] || DEFAULT_MEMORY_HEADROOM
      end

      def inspect
        "VM Placement Criteria: Disk Config: #{disk_config}  Req Memory: #{req_memory}  Mem Headroom: #{mem_headroom}"
      end
    end
    private_constant :VmPlacementCriteria

    with_filter do |vm_placement, criteria_object|
      logger.debug("Filter #{vm_placement.cluster_inspect} for free memory required: #{criteria_object.required_memory}")
      vm_placement.cluster_free_memory > criteria_object.required_memory
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
        pipeline = DiskPlacementSelectionPipeline.new(disk.size, disk.target_datastore_pattern, nil, disk.ephemeral?, criteria_object.required_memory) do
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
        vm_placement.fallback_disk_placements =  pipeline.each.to_a.drop(1) if disk.ephemeral?
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
      -(p1.host_group_free_memory <=> p2.host_group_free_memory)
    end

    def initialize(*args)
      super(VmPlacementCriteria.new(*args))
    end

    def inspect
      "VM Allocator with #{object.inspect}"
    end
  end
end
