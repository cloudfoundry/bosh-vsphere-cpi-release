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
      filter_on_datastore_space(clusters, req_ephemeral_size, existing_disks)
    end

    def pick_cluster(req_memory, req_ephemeral_size, existing_disks)
      clusters = suitable_clusters(req_memory, req_ephemeral_size, existing_disks)

      clusters = pick_clusters_with_least_migration_burden(clusters, existing_disks)

      if clusters.size == 1
        return clusters.keys.first
      end

      if clusters.size > 1
        sorted_clusters = clusters.sort_by do |name, properties|
          score_cluster(properties, req_ephemeral_size)
        end.reverse
        return sorted_clusters.first.first
      end

      raise Bosh::Clouds::CloudError, "Could not find any suitable clusters with memory: #{req_memory}, ephemeral disk size: #{req_ephemeral_size}, and persistent disks: #{existing_disks.inspect}. Available clusters: #{@available_clusters.inspect}"
    end

    private

    def migration_burden(properties, existing_disks)
      existing_disks_to_migrate = existing_disks.reject do |ds_name, _|
        properties[:datastores].include?(ds_name)
      end
      existing_disks_to_migrate.values.map(&:values).flatten.inject(0, :+)
    end

    def pick_clusters_with_least_migration_burden(clusters, existing_disks)
      return clusters if existing_disks.empty?

      burdens = clusters.map do |name, properties|
        [name, migration_burden(properties, existing_disks)]
      end.reverse
      burdens = Hash[burdens]
      min_burden = burdens.values.min
      cluster_selections = burdens.select do |name, burden|
        burden == min_burden
      end.map { |name, burden| name }
      selected_clusters = clusters.select do |name, _|
        cluster_selections.include? name
      end
    end

    def score_cluster(properties, req_ephemeral_size)
      datastore_picker = DatastorePicker.new(@disk_headroom)
      datastore_picker.update(properties[:datastores])
      suitable_eph_datastores = datastore_picker.suitable_datastores(req_ephemeral_size, @ephemeral_ds_pattern)
      eph_score = suitable_eph_datastores.values.inject(0, :+)

      suitable_persistent_datastores = datastore_picker.suitable_datastores(0, @persistent_ds_pattern)
      if suitable_persistent_datastores.empty?
        persistent_score = 0
      else
        persistent_score = suitable_persistent_datastores.values.sort.reverse.first
      end

      eph_score + persistent_score + properties[:memory]
    end

    def filter_on_memory(clusters, req_memory)
      clusters.select do |name, properties|
        properties[:memory] >= (req_memory + @mem_headroom)
      end
    end

    def filter_on_datastore_space(clusters, req_ephemeral_size, existing_disks)
      clusters.select { |_, properties| cluster_can_accomodate_disks?(properties, req_ephemeral_size, existing_disks) }
    end

    def cluster_can_accomodate_disks?(properties, req_ephemeral_size, existing_disks)
      datastore_picker = DatastorePicker.new(@disk_headroom)
      datastore_picker.update(properties[:datastores])
      suitable_eph_datastores = datastore_picker.suitable_datastores(req_ephemeral_size, @ephemeral_ds_pattern)

      persistent_disk_sizes = calc_persistent_disk_sizes(existing_disks, properties[:datastores])

      suitable_eph_datastores.any? do |name, free_space|
        updated_datastores = properties[:datastores].clone
        updated_datastores[name] = free_space - req_ephemeral_size
        datastore_picker.update(updated_datastores)
        datastore_picker.can_accomodate_disks?(persistent_disk_sizes, @persistent_ds_pattern)
      end
    end

    def calc_persistent_disk_sizes(existing_disks, datastores)
      already_included_disks = lambda { |ds_name, _| datastores.include? ds_name }

      existing_disks.reject(&already_included_disks).values.map(&:values).flatten
    end

  end
end
