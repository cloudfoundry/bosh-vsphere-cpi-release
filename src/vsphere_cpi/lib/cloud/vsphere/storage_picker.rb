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

      #if datastores is set use that else use global pattern
      if datastore_names.empty? && disk_pool.datastore_clusters.empty?
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

    # choose storage from set of datastore and sdrs enabled datastore clusters
    # using weight based algorithm on free space to choose the storage
    # if datastore clusters are provided and none of them have sdrs enabled log an error

    # @param [String] target_datastore_name
    # @param [Hash] accessible_datastores
    # @param [VmType] vm_type
    def choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type, logger)
      #pick datastore set by cluster_picker based on ephemeral_pattern
      storage_options = [accessible_datastores[target_datastore_name]].compact
      logger.debug("Initial Storage Options for creating ephemeral disk from pattern: #{storage_options.map(&:name)}")

      if vm_type.datastore_clusters.any?
        sdrs_enabled_datastore_clusters = vm_type.datastore_clusters.select(&:drs_enabled?)
        logger.info("None of the datastore clusters have Storage DRS enabled") unless sdrs_enabled_datastore_clusters.any?
        storage_options.concat(sdrs_enabled_datastore_clusters)
      end
      logger.debug("Storage Options for creating ephemeral disk are: #{storage_options.map(&:name)}")
      choose_best_from(storage_options)
    end

    # Ephemeral Pattern is constructed from given datastores and collection of all datastores for sdrs enabled datastore clusters
    # if no datastores/datastore_clusters are specified, use global ephemeral pattern

    # @param [VmType] vm_type
    def choose_ephemeral_pattern(vm_type, logger)
      datastore_names = vm_type.datastore_names
      unless vm_type.datastore_clusters.empty?
        sdrs_enabled_datastore_clusters = vm_type.datastore_clusters.select(&:drs_enabled?)
        datastores = sdrs_enabled_datastore_clusters.map { |datastore_cluster| datastore_cluster.datastores }.flatten
        datastore_names.concat(datastores.map(&:name))
      end
      datastore_names = datastore_names.compact
      if datastore_names.empty? && vm_type.datastore_clusters.empty?
        logger.info("Using global ephemeral disk datastore pattern: #{vm_type.datacenter.ephemeral_pattern}")
        vm_type.datacenter.ephemeral_pattern
      else
        logger.info("Using datastore list: #{datastore_names.join(', ')}")
        "^(#{datastore_names.map do |name|
          Regexp.escape(name)
        end.join('|')})$"
      end
    end
  end
end