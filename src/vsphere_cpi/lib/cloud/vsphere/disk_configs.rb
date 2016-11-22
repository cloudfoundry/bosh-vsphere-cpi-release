module VSphereCloud
  class DiskConfigs

    def initialize(opts)
      @datacenter = opts[:datacenter]
      @vm_type = opts[:vm_type]
      @disk_pool = opts[:disk_pool]
    end

    def disk_config_from_persistent_disk(disk_cid)
      clean_cid, metadata = DiskMetadata.decode(disk_cid)

      disk = @datacenter.find_disk(clean_cid)
      return {
        cid: disk.cid,
        size: disk.size_in_mb,
        existing_datastore_name: disk.datastore.name,
        target_datastore_pattern: target_pattern_from_metadata(metadata),
      }
    end

    def director_disk_cid(disk_config)
      # Only encode if disk_pool.datastores is specified
      # This allows the Operator to change the global persistent pattern and the disk will be moved to match
      if has_persistent_datastores?
        data_to_encode = { target_datastore_pattern: disk_config[:target_datastore_pattern] }
        DiskMetadata.encode(disk_config[:cid], data_to_encode)
      else
        disk_config[:cid]
      end
    end

    def new_ephemeral_disk_config
      return {
        size: @vm_type['disk'],
        ephemeral: true,
        target_datastore_pattern: target_ephemeral_pattern,
      }
    end

    def new_persistent_disk_config(size)
      return {
        size: size,
        target_datastore_pattern: target_persistent_pattern,
      }
    end

    private

    def target_pattern_from_metadata(metadata)
      metadata[:target_datastore_pattern] || @datacenter.persistent_pattern
    end

    def target_ephemeral_pattern
      if @vm_type['datastores'] && !@vm_type['datastores'].empty?
        escaped_names = @vm_type['datastores'].map { |pattern| Regexp.escape(pattern) }
        "^(#{escaped_names.join('|')})$"
      else
        @datacenter.ephemeral_pattern
      end
    end

    def target_persistent_pattern
      if has_persistent_datastores?
        escaped_names = @disk_pool['datastores'].map { |pattern| Regexp.escape(pattern) }
        "^(#{escaped_names.join('|')})$"
      else
        @datacenter.persistent_pattern
      end
    end

    def has_persistent_datastores?
      @disk_pool['datastores'] && !@disk_pool['datastores'].empty?
    end
  end
end
