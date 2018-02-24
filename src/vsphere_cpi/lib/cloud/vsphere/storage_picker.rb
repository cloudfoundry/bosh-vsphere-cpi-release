module VSphereCloud
  module StoragePicker
    module_function

    def choose_best_from(storage_objects)
      storage_objects.max_by { |object| Random.rand * object.free_space }
    end

    # @param [DiskPool] disk_pool
    def choose_persistent_pattern(disk_pool, logger)
      datastore_names = disk_pool.datastore_names
      unless disk_pool.datastore_clusters.empty?
        sdrs_enabled_datastore_clusters = disk_pool.datastore_clusters.select(&:drs_enabled?)
        # pick best sdrs enabled datastore cluster and include its datastores in the set to be used for persistent disk
        if sdrs_enabled_datastore_clusters.any?
          datastore_cluster = choose_best_from(sdrs_enabled_datastore_clusters)
          datastore_names.concat(datastore_cluster.datastores.map(&:name))
        end
      end

      if datastore_names.empty?
        logger.info("Using global persistent disk datastore pattern: #{disk_pool.datacenter.persistent_pattern}")
        disk_pool.datacenter.persistent_pattern
      else
        logger.info("Using datastore list: #{datastore_names.join(', ')}")
        "^(#{datastore_names.map do |name|
          Regexp.escape(name)
        end.join('|')})$"
      end
    end

    def choose_persistent_storage(size_in_mb, target_datastore_pattern, available_datastores)
      disk_config = DiskConfig.new(size: size_in_mb, target_datastore_pattern: target_datastore_pattern)

      datastore_picker = DatastorePicker.new
      datastore_picker.update(available_datastores)
      datastore_name = datastore_picker.pick_datastore_for_single_disk(disk_config)
      datastore_name
    end
  end
end