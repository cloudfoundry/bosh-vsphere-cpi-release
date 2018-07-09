module VSphereCloud
  module VMFilter
    DEFAULT_DISK_HEADROOM = 1024

    FilterFreeMemory = -> (vm_placement, criteria_object) do
      vm_placement.free_memory > criteria_object.required_memory
    end

    FilterMaintenanceModeDS = -> (vm_placement, _) do
      vm_placement.datastores.reject! do |ds_resource|
        ds_resource.maintenance_mode?
      end
      return true unless vm_placement.datastores.empty?
      false
    end

    FilterDSForDiskConfig = -> (vm_placement, criteria_object) do
      cluster_ds_map = { datastores_disk_map: {}, migration_size: 0, balance_score: 0 }

      criteria_object.disk_config.each do |disk|
        existing_ds_name = disk.existing_datastore_name

        # Only persistent disks will have existing_ds_name
        if existing_ds_name =~ Regexp.new(disk.target_datastore_pattern) && vm_placement.datastores.any? {|ds| ds.name == existing_ds_name}
          cluster_ds_map[:datastores_disk_map][disk] = existing_ds_name
          next
        end

        placement_found = false
        weighted_datastores = weighted_random_sort(vm_placement.datastores)
        weighted_datastores.each do |ds|
          # TA: Do something about defualt disk headroom
          additional_required_space = disk.size + DEFAULT_DISK_HEADROOM


          next if additional_required_space > ds.free_space
          next unless ds.name =~ Regexp.new(disk.target_datastore_pattern)

          cluster_ds_map[:datastores_disk_map][disk] = ds.name
          ds.free_space -= additional_required_space
          cluster_ds_map[:migration_size] += additional_required_space if existing_ds_name
          placement_found = true
          break
        end
        unless placement_found
          # TA: Log something
          # Return false and reject this cluster for absence of any suitable storage for given
          # disk configurations
          return false
        end
      end
      cluster_ds_map[:balance_score] = get_balance_score(vm_placement.datastores, cluster_ds_map[:datastores_disk_map])
      vm_placement.cluster_ds_map= cluster_ds_map
      true
    end

    def get_balance_score(datastores, datastore_disk_map)
      free_spaces = datastores.keep_if do |ds|
        datastore_disk_map.values.include?(ds.name)
      end.map do |ds|
        ds.free_space
      end.sort

      min = free_spaces.first
      mean = free_spaces.inject(0, &:+) / free_spaces.length
      median = free_spaces[free_spaces.length / 2]

      min + mean + median
    end

    def weighted_random_sort(datastores)
      random_hash = {}
      datastores.each do |ds|
        random_hash[ds.name] = Random.rand * ds.free_space
      end
      datastores.sort do |x,y|
        random_hash[y.name] <=> random_hash[x.name]
      end
    end

    module_function :weighted_random_sort, :get_balance_score
  end

  module VMScorer
    ScoreMemory = -> (vm_placement, _) do
      vm_placement.free_memory
    end

    ScoreFreeSpace = -> (vm_placement, _) do
      vm_placement.balance_score
    end

    ScoreMigrationSize = -> (vm_placement, _) do
      vm_placement.migration_size
    end
  end

  ####################################################################################################
  #
  # What we need to gather is
  #   1. Cluster
  #   2. Possible Hosts in a cluster (if needed or let DRS do the work)
  #   3. Datastore combination that fits the cluster
  #
  # What we need to filter is
  #   1. Cluster with insufficient memory
  #   2. Cluster with insufficient CPU
  #   3. If hosts present hosts with insufficient GPU , mem, CPU
  #   4. DS with insufficient space
  #   5. DS inaccessible
  #   6. Filter which selects combination for required disks
  #
  # What we need to score
  #   1. Balance Score
  #   2. Memory
  #   3. Migration Size
  #
  ####################################################################################################

  #
  # @TA : TODO : Override each method to change scoring. Make placemnt resource a comparable and implmement sorting in each
  # @TA :TODO : Can scorer be made in a way to prioritize migration size --> balance score--> memory. Fixed-weight weighted sort maybe?
  #
  class VmPlacementSelectionPipeline < SelectionPipeline
    def initialize(*)
      super
      with_filter VMFilter::FilterFreeMemory, VMFilter::FilterMaintenanceModeDS, VMFilter::FilterDSForDiskConfig
      with_scorer VMScorer::ScoreMemory, VMScorer::ScoreFreeSpace, VMScorer::ScoreMigrationSize
    end

    def each(&block)
      return enum_for(:each) unless block_given?

      @gather.call.select do |placement|
        accept?(placement)
      end.sort.each(&block)
    end
  end

  # @TA : TODO :  Can this be made more generic or improved?
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
end