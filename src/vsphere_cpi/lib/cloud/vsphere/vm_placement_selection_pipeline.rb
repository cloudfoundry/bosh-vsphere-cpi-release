module VSphereCloud
  class VmPlacement
    attr_reader :cluster, :hosts, :datastores, :disk_placement,
      :balance_score_set

    attr_accessor :migration_size

    def initialize(cluster:, hosts:, datastores:)
      @cluster = cluster
      @hosts = hosts
      @datastores = datastores
      @balance_score_set = Set.new
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

      free_spaces = balance_score_set.map(&:free_space).sort

      min = free_spaces.first
      mean = free_spaces.sum / free_spaces.length
      median = free_spaces[free_spaces.length / 2]

      @balance_score = min + mean + median
    end

    def free_memory
      cluster.free_memory
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
    end
    private_constant :VmPlacementCriteria

    with_filter do |vm_placement, criteria_object|
      vm_placement.free_memory > criteria_object.required_memory
    end

    with_filter do |vm_placement|
      vm_placement.datastores.reject! do |ds_resource|
        ds_resource.maintenance_mode?
      end
      !vm_placement.datastores.empty?
    end

    with_filter(-> (vm_placement, criteria_object) do
      criteria_object.disk_config.each do |disk|
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

        pipeline = DiskPlacementSelectionPipeline.new(disk.size, disk.target_datastore_pattern) do
          vm_placement.datastores
        end.with_filter do |storage_placement|
          # TODO: both accessible? and accessible_from? will be queried for
          # each datastore
          storage_placement.resource.accessible_from?(vm_placement.cluster)
        end

        result = pipeline.each.first

        # TODO: Log something. Return false and reject this cluster for
        # absence of any suitable storage for given disk configurations
        return false if result.nil?

        vm_placement.disk_placement = result unless disk.existing_datastore_name

        result.free_space -= disk.size

        vm_placement.balance_score_set << result
        vm_placement.migration_size += disk.size if disk.existing_datastore_name
      end
      true
    end)

    with_scorer do |p1, p2|
      p1.migration_size <=> p2.migration_size
    end

    with_scorer do |p1, p2|
      p1.balance_score <=> p2.balance_score
    end

    with_scorer do |p1, p2|
      p1.free_memory <=> p2.free_memory
    end

    def initialize(*args)
      super(VmPlacementCriteria.new(*args))
    end
  end
end