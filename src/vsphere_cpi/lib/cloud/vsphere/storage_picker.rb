require 'cloud/vsphere/logger'

module VSphereCloud
  module StoragePicker
    include Logger

    module_function

    def choose_best_from(storage_objects)
      storage_objects.max_by { |object| Random.rand * object.free_space }
    end

    # @param [DiskPool] disk_pool
    def choose_persistent_pattern(disk_pool)
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
        "^(#{datastore_names.map { |name| Regexp.escape(name) }.join('|')})$"
      end
    end

    # choose storage from set of datastore and sdrs enabled datastore clusters
    # using weight based algorithm on free space to choose the storage
    # if datastore clusters are provided and none of them have sdrs enabled log an error

    # @param [String] target_datastore_name
    # @param [Hash] accessible_datastores
    # @param [VmType] vm_type
    def choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type)
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

    # Ephemeral Pattern is constructed using following list of priority
    # 1. vm_type storage policy
    # 2. vm_type ephemeral DS pattern
    # 3. Global Storage Policy
    # 4. Global ephemeral DS pattern
    #
    # if policy is specified used compatible datastores for that policy otherwise
    # use given datastores and collection of all datastores for sdrs enabled datastore clusters
    # and if no datastores/datastore_clusters are specified, use global ephemeral pattern
    #
    # @param [VmType] vm_type
    # @param [Config] global_config
    #
    # @return [String]DS Pattern, [String, nil] PolicyName (if applicable)
    def choose_ephemeral_pattern(global_config, vm_type)

      # 1. Check for vm_type storage policy first
      # return if exists
      if vm_type.storage_policy_name
        datastore_names = vm_type.storage_policy_datastores(vm_type.storage_policy_name).map{|d| d.name }
        logger.info("Using compatible datastores: #{datastore_names.join(', ')} for Storage policy #{vm_type.storage_policy_name}")
        return "^(#{datastore_names.map { |name| Regexp.escape(name) }.join('|')})$", vm_type.storage_policy_name
      end

      # 2. Check if vm_type datastore or SDRS enabled datastore cluster exists
      # return if exists
      datastore_names = vm_type.datastore_names
      unless vm_type.datastore_clusters.empty?
        sdrs_enabled_datastore_clusters = vm_type.datastore_clusters.select(&:drs_enabled?)
        datastores = sdrs_enabled_datastore_clusters.map { |datastore_cluster| datastore_cluster.datastores }.flatten
        datastore_names.concat(datastores.map(&:name))
      end
      datastore_names = datastore_names.compact
      # @TA: TODO Do we need second condition here?
      if !(datastore_names.empty? && vm_type.datastore_clusters.empty?)
        logger.info("Using datastore list: #{datastore_names.join(', ')}")
        return "^(#{datastore_names.map { |name| Regexp.escape(name) }.join('|')})$", nil
      end

      # 3. Check for global storage policy if present.
      # return compatible ds if exists
      if global_config.vm_storage_policy_name
        datastore_names = vm_type.storage_policy_datastores(global_config.vm_storage_policy_name).map{|d| d.name }
        logger.info("Using compatible datastores for given Storage policy: #{datastore_names.join(', ')}")
        return "^(#{datastore_names.map { |name| Regexp.escape(name) }.join('|')})$", global_config.vm_storage_policy_name
      end

      # 4. If nothing else is specified, return global ephemeral pattern.
      logger.info("Using global ephemeral disk datastore pattern: #{vm_type.datacenter.ephemeral_pattern}")
      return vm_type.datacenter.ephemeral_pattern, nil
    end
  end
end