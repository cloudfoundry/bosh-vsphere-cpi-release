module VSphereCloud
  FilterMaintenanceModeDS = -> (storage_placement, _) do
    storage_placement.maintenance_mode == "normal"
  end

  FilterFreeSpaceDS = -> (storage_placement, criteria_object) do
    default_disk_headroom = 1024
    storage_placement.free_space > default_disk_headroom + criteria_object.size_in_mb
  end

  FilterTargetPatternDS = -> (storage_placement, criteria_object) do
      storage_placement.name =~ Regexp.new(criteria_object.target_datastore_pattern)
  end

  FilterInaccessibleDS = -> (storage_placement, _) do
      storage_placement.accessible?
  end

  ScoreWeightedRandomFreeSpaceDS = -> (storage_placement, _) do
    Random.rand * storage_placement.free_space
  end

  class DiskPlacementSelectionPipeline < SelectionPipeline
    def initialize(*)
      super
      with_filter FilterMaintenanceModeDS, FilterFreeSpaceDS, FilterTargetPatternDS, FilterInaccessibleDS
      with_scorer ScoreWeightedRandomFreeSpaceDS
    end
  end

  class StoragePlacementCriteria
    attr_reader :size_in_mb, :target_datastore_pattern

    def initialize(size_in_mb, target_ds_pattern)
      @size_in_mb = size_in_mb
      @target_datastore_pattern = target_ds_pattern
    end
  end
end