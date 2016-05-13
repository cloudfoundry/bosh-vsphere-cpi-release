module VSphereCloud
  class ClusterPicker
    DEFAULT_MEMORY_HEADROOM = 128

    def initialize(mem_headroom=DEFAULT_MEMORY_HEADROOM, disk_headroom=DatastorePicker::DEFAULT_DISK_HEADROOM)
      @mem_headroom = mem_headroom
      @disk_headroom = disk_headroom
      @available_clusters = {}
    end

    def update(available_clusters={})
      @available_clusters = available_clusters
    end


    def suitable_clusters(
      req_memory:,
      req_ephemeral_size:,
      disk_configurations:,
      ephemeral_datastore_pattern:,
      persistent_datastore_pattern:
    )
      clusters = filter_on_memory(@available_clusters, req_memory)
      filter_on_datastore_space(
        clusters: clusters,
        req_ephemeral_size: req_ephemeral_size,
        disk_configurations: disk_configurations,
        ephemeral_ds_pattern: ephemeral_datastore_pattern,
        persistent_ds_pattern: persistent_datastore_pattern,
      )
    end

    def pick_cluster(
      req_memory:,
      req_ephemeral_size:,
      disk_configurations:,
      ephemeral_datastore_pattern:,
      persistent_datastore_pattern:
    )
      clusters = suitable_clusters(
        req_memory: req_memory,
        req_ephemeral_size: req_ephemeral_size,
        disk_configurations: disk_configurations,
        ephemeral_datastore_pattern: ephemeral_datastore_pattern,
        persistent_datastore_pattern: persistent_datastore_pattern
      )

      clusters = pick_clusters_with_least_migration_burden(clusters, disk_configurations)

      if clusters.size == 1
        return clusters.keys.first
      end

      if clusters.size > 1
        sorted_clusters = clusters.sort_by do |name, properties|
          score_cluster(
            properties: properties,
            req_ephemeral_size: req_ephemeral_size,
            ephemeral_ds_pattern: ephemeral_datastore_pattern,
            persistent_ds_pattern: persistent_datastore_pattern
          )
        end.reverse
        return sorted_clusters.first.first
      end

      raise Bosh::Clouds::CloudError,
        "Could not find any suitable clusters with memory: #{req_memory}, " \
        "ephemeral disk size: #{req_ephemeral_size}, " \
        "and persistent disks: #{disk_configurations.inspect}. " \
        "Configured ephemeral datastore pattern: #{ephemeral_datastore_pattern.inspect}. " \
        "Configured persistent datastore pattern: #{persistent_datastore_pattern.inspect}. " \
        "Available clusters: #{@available_clusters.inspect}"
    end

    private

    def disks_needing_migration(datastores, disk_configurations)
      disk_configurations.reject do |disk_config|
        datastores.include?(disk_config[:datastore_name])
      end
    end

    def migration_burden(properties, disk_configurations)
      disks_needing_migration(properties[:datastores], disk_configurations)
        .map{ |d| d[:size] }
        .inject(0, :+)
    end

    def pick_clusters_with_least_migration_burden(clusters, disk_configurations)
      return clusters if disk_configurations.empty?

      burdens = clusters.map do |name, properties|
        [name, migration_burden(properties, disk_configurations)]
      end
      burdens = Hash[burdens]
      min_burden = burdens.values.min
      cluster_selections = burdens.select do |name, burden|
        burden == min_burden
      end.map { |name, burden| name }

      clusters.select do |name, _|
        cluster_selections.include? name
      end
    end

    def score_cluster(
      properties:,
      req_ephemeral_size:,
      ephemeral_ds_pattern:,
      persistent_ds_pattern:
    )
      datastore_picker = DatastorePicker.new(@disk_headroom)
      datastore_picker.update(properties[:datastores])
      suitable_eph_datastores = datastore_picker.suitable_datastores(req_ephemeral_size, ephemeral_ds_pattern)
      eph_score = suitable_eph_datastores.values.inject(0, :+)

      suitable_persistent_datastores = datastore_picker.suitable_datastores(0, persistent_ds_pattern)
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

    def filter_on_datastore_space(
      clusters:,
      req_ephemeral_size:,
      disk_configurations:,
      ephemeral_ds_pattern:,
      persistent_ds_pattern:
    )
      clusters.select do |_, properties|
        cluster_can_accomodate_disks?(
          properties: properties,
          req_ephemeral_size: req_ephemeral_size,
          disk_configurations: disk_configurations,
          ephemeral_ds_pattern: ephemeral_ds_pattern,
          persistent_ds_pattern: persistent_ds_pattern,
        )
      end
    end

    def cluster_can_accomodate_disks?(
      properties:,
      req_ephemeral_size:,
      disk_configurations:,
      ephemeral_ds_pattern:,
      persistent_ds_pattern:
    )
      datastore_picker = DatastorePicker.new(@disk_headroom)
      datastore_picker.update(properties[:datastores])
      suitable_eph_datastores = datastore_picker.suitable_datastores(req_ephemeral_size, ephemeral_ds_pattern)

      filtered_persistent_datastores = datastore_picker.suitable_datastores(0, persistent_ds_pattern)
      disks_to_migrate = disks_needing_migration(filtered_persistent_datastores, disk_configurations)
      disk_sizes = disks_to_migrate.map { |d| d[:size] }

      suitable_eph_datastores.any? do |name, free_space|
        updated_datastores = properties[:datastores].clone
        updated_datastores[name] = free_space - req_ephemeral_size
        datastore_picker.update(updated_datastores)
        datastore_picker.can_accomodate_disks?(disk_sizes, persistent_ds_pattern)
      end
    end
  end
end
