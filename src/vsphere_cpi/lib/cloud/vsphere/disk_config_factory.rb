module VSphereCloud
  class DiskConfigFactory

    def initialize(datacenter:, vm_type:{}, disk_pool:{}, client: nil)
      @datacenter = datacenter
      @vm_type = vm_type
      @disk_pool = disk_pool
      @client = client
    end

    def disk_config_from_persistent_disk(director_disk_cid)
      disk = @datacenter.find_disk(director_disk_cid)
      VSphereCloud::DiskConfig.new(
        cid: disk.cid,
        size: disk.size_in_mb,
        existing_datastore_name: disk.datastore.name,
        target_datastore_pattern: director_disk_cid.target_datastore_pattern || @datacenter.persistent_pattern
      )
    end

    def director_disk_cid(disk_config)
      # Only encode if disk_pool.datastores is specified
      # This allows the Operator to change the global persistent pattern and the disk will be moved to match
      if has_persistent_datastores?
        data_to_encode = {
          target_datastore_pattern: disk_config.target_datastore_pattern
        }
        DirectorDiskCID.encode(disk_config.cid, data_to_encode)
      else
        disk_config.cid
      end
    end

    def new_ephemeral_disk_config
      VSphereCloud::DiskConfig.new(
          size: @vm_type['disk'],
          ephemeral: true,
          target_datastore_pattern: target_ephemeral_pattern
      )
    end

    def new_persistent_disk_config(size)
      VSphereCloud::DiskConfig.new(
          size: size,
          target_datastore_pattern: target_persistent_pattern
      )
    end

    private

    def has_persistent_datastores?
      @disk_pool['datastores'] && !@disk_pool['datastores'].empty?
    end

    def sdrs_enabled_datastore_clusters(datastores_spec)
      @sdrs_enabled_datastore_clusters ||= datastore_clusters(datastores_spec).map do |datastore_cluster_spec|
        VSphereCloud::Resources::StoragePod.find(datastore_cluster_spec.keys.first, @datacenter.name, @client)
      end.select(&:drs_enabled?)
    end

    def datastore_clusters(datastores_spec)
      datastore_clusters_spec = []
      return datastore_clusters_spec unless datastores_spec && datastores_spec.any?
      datastores_spec.each do |entry|
        hash = Hash.try_convert(entry)
        next if hash.nil?
        if hash.key?('clusters')
          datastore_clusters_spec = hash['clusters']
          break
        end
      end
      datastore_clusters_spec
    end

    #datastores is a list of datastores and datastore_clusters. Eg.
    #[datastore1, clusters: [{datastore_cluster1: {}, datatore_cluster2: {}}]]
    def target_ephemeral_pattern
      escaped_names = []
      if @vm_type['datastores'] && !@vm_type['datastores'].empty?
        #skip datastore clusters which are defined as hash
        escaped_names = @vm_type['datastores'].map { |pattern| Regexp.escape(pattern) if pattern.is_a?(String)}
        sdrs_enabled_datastore_clusters = sdrs_enabled_datastore_clusters(@vm_type['datastores'])
        #use all datastores which belong to sdrs enabled datastore cluster.
        if sdrs_enabled_datastore_clusters.any?
          datastores = sdrs_enabled_datastore_clusters.collect { |datastore_cluster| datastore_cluster.mob.child_entity }.flatten
          escaped_names << datastores.map { |datastore| Regexp.escape(datastore.name) }
        end
        escaped_names = escaped_names.compact
      end
      escaped_names.empty? ?  @datacenter.ephemeral_pattern : "^(#{escaped_names.join('|')})$"
    end

    #datastores is a list of datastores and datastore_clusters. Eg.
    #[datastore1, clusters: [{datastore_cluster1: {}, datatore_cluster2: {}}]]
    def target_persistent_pattern
      escaped_names = []
      if has_persistent_datastores?
        #skip datastore clusters which are defined as hash
        escaped_names = @disk_pool['datastores'].map { |pattern| Regexp.escape(pattern) if pattern.is_a?(String)}
        sdrs_enabled_datastore_clusters = sdrs_enabled_datastore_clusters(@disk_pool['datastores'])
        #pick best sdrs enabled datastore cluster and include its datastores in the set to be used for persistent disk
        if sdrs_enabled_datastore_clusters.any?
          datastore_cluster = weighted_random_sort(sdrs_enabled_datastore_clusters).first
          datastores = datastore_cluster.mob.child_entity
          escaped_names << datastores.map { |datastore| Regexp.escape(datastore.name) }
        end
        escaped_names = escaped_names.flatten.compact
      end
      escaped_names.empty? ?  @datacenter.persistent_pattern : "^(#{escaped_names.join('|')})$"
    end

    def weighted_random_sort(storage_options)
      random_hash = {}
      storage_options.each do |storage_option|
        random_hash[storage_option.mob.__mo_id__] = Random.rand * storage_option.free_space
      end
      storage_options.sort do |x,y|
        random_hash[y.mob.__mo_id__] <=> random_hash[x.mob.__mo_id__]
      end
    end
  end
end
