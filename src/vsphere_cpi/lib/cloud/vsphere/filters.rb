module VSphereCloud
  module Filter_Maintenance_Mode_DS
    module_function
    def call(storage_placement, criteria_object)
      storage_placement.maintenance_mode == "normal"
    end
  end

  module Filter_Free_Space_DS
    module_function
    DEFAULT_DISK_HEADROOM = 1024
    def call(storage_placement, criteria_object)
      storage_placement.free_space > DEFAULT_DISK_HEADROOM + criteria_object[:size_in_mb]
    end
  end

  module Filter_Target_Pattern_DS
    module_function
    def call(storage_placement, criteria_object)
      storage_placement.name =~ Regexp.new(criteria_object[:target_datastore_pattern])
    end
  end

  module Filter_Inaccessible_DS
    module_function
    def call(storage_placement, criteria_object)
      storage_placement.accessible?
    end
  end
end