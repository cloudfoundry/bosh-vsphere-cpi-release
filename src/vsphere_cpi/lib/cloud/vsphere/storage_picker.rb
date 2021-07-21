require 'cloud/vsphere/logger'

module VSphereCloud
  module StoragePicker
    include Logger

    module_function

    def choose_best_from(storage_objects)
      storage_objects.max_by { |object| Random.rand * object.free_space }
    end

    # param [DirectorDiskCID] cid
    # param [Resources::Datacenter] datacenter
    def choose_existing_disk_pattern(cid, datacenter)
      cid.target_datastore_pattern || choose_global_persistent_pattern(datacenter)
    end

    # param [Resources::Datacenter] datacenter
    def choose_global_persistent_pattern(datacenter)
      choose_global_datastore_pattern(datacenter, true)
    end

    # param [Resources::Datacenter] datacenter
    def choose_global_ephemeral_pattern(datacenter)
      choose_global_datastore_pattern(datacenter, false)
    end

    # param [Resources::Datacenter] datacenter
    # param [Boolean] is_persistent
    def choose_global_datastore_pattern(datacenter, is_persistent)
      if is_persistent
        pattern=datacenter.persistent_pattern
        cluster_pattern=datacenter.persistent_datastore_cluster_pattern
      else
        pattern=datacenter.ephemeral_pattern
        cluster_pattern=datacenter.ephemeral_datastore_cluster_pattern
      end
      logger.info("Using global datastore pattern #{pattern} and global datastore cluster pattern #{cluster_pattern} persistent: #{is_persistent}")
      return pattern unless cluster_pattern && !cluster_pattern.empty?

      datastore_cluster_list = Resources::StoragePod.search_storage_pods(Regexp.new(cluster_pattern), datacenter.mob)

      logger.info("clusters: #{datastore_cluster_list}")

      # pick all SDRS-enabled datastore clusters and include their datastores in the set to be used
      datastores = datastore_cluster_list.select(&:drs_enabled?).map { |datastore_cluster| datastore_cluster.datastores }.flatten
      cluster_datastore_names = datastores.map(&:name)

      if cluster_datastore_names.empty?
        pattern
      else
        ret = "^(#{cluster_datastore_names.map { |name| Regexp.escape(name) }.join('|')})$"
        if pattern && !pattern.empty?
          ret += "|"+pattern
        end
        ret
      end
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
        choose_global_persistent_pattern(disk_pool.datacenter)
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
    def choose_ephemeral_storage(target_datastore_name, accessible_datastores)
      accessible_datastores[target_datastore_name]
    end

    # Ephemeral Pattern is constructed using following list of priority
    # 1. vm_type storage policy
    # 2. vm_type ephemeral DS pattern
    # 3. Global Storage Policy
    # 4. Global ephemeral DS pattern
    #
    # if policy is specified use compatible datastores for that policy otherwise
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
      return choose_global_ephemeral_pattern(vm_type.datacenter), nil
    end
  end
end