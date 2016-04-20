module VSphereCloud
  class ClusterPicker
    DEFAULT_MEMORY_HEADROOM = 128

    def initialize(ephemeral_ds_pattern, persistent_ds_pattern, mem_headroom=DEFAULT_MEMORY_HEADROOM, disk_headroom=DatastorePicker::DEFAULT_DISK_HEADROOM)
      @mem_headroom = mem_headroom
      @disk_headroom = disk_headroom
      @ephemeral_ds_pattern = ephemeral_ds_pattern
      @persistent_ds_pattern = persistent_ds_pattern
      @available_clusters = {}
    end

    def update(available_clusters={})
      @available_clusters = available_clusters
    end

    def suitable_clusters(req_memory, req_ephemeral_size, existing_disks)
      clusters = filter_on_memory(@available_clusters, req_memory)
      clusters = filter_on_ephemeral_disk_space(clusters, req_ephemeral_size)
      filter_on_persistent_disk_space(clusters, existing_disks)
    end

    private

    def filter_on_memory(clusters, req_memory)
      clusters.select do |name, properties|
        properties[:memory] >= (req_memory + @mem_headroom)
      end
    end

    def filter_on_ephemeral_disk_space(clusters, req_ephemeral_size)
      clusters.select do |name, properties|
        datastore_picker = DatastorePicker.new(@disk_headroom)
        datastore_picker.update(properties[:datastores])
        suitable_eph_datastores = datastore_picker.suitable_datastores(req_ephemeral_size, @ephemeral_ds_pattern)
        suitable_eph_datastores.size > 0
      end
    end

    def filter_on_persistent_disk_space(clusters, existing_disks)
      clusters.select do |name, properties|
        existing_disks_to_accomodate = existing_disks.reject do |ds_name, _|
          properties[:datastores].include?(ds_name)
        end

        if existing_disks_to_accomodate.empty?
          true
        else

          disk_sizes = existing_disks_to_accomodate.values.map(&:values).flatten
          datastore_picker = DatastorePicker.new(@disk_headroom)
          datastore_picker.update(properties[:datastores])
          datastore_picker.can_accomodate_disks?(disk_sizes, @persistent_ds_pattern)
        end
      end
    end
  end
end
