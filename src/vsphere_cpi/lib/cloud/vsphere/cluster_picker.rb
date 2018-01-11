module VSphereCloud
  class ClusterPicker
    DEFAULT_MEMORY_HEADROOM = 128

    def initialize(mem_headroom=DEFAULT_MEMORY_HEADROOM, disk_headroom=DatastorePicker::DEFAULT_DISK_HEADROOM)
      @mem_headroom = mem_headroom
      @disk_headroom = disk_headroom
      @available_clusters = []
    end

    def update(available_clusters=[])
      @available_clusters = available_clusters
    end

    def best_cluster_placement(req_memory:, disk_configurations:)
      clusters = filter_on_memory(req_memory)
      if clusters.size == 0
        raise Bosh::Clouds::CloudError,
        "No valid placement found for requested memory: #{req_memory}\n\n#{pretty_print_cluster_memory}"
      end

      placement_options = clusters.map do |cluster|
        datastore_picker = DatastorePicker.new(@disk_headroom)
        datastore_picker.update(cluster.accessible_datastores)

        begin
          placement = datastore_picker.best_disk_placement(disk_configurations)
          placement[:memory] = cluster.free_memory
          [cluster.name, placement]
        rescue Bosh::Clouds::CloudError
          nil # continue if no placements exist for this cluster
        end
      end.compact.to_h

      if placement_options.nil? || placement_options.size == 0
        disk_string = DatastorePicker.pretty_print_disks(disk_configurations)
        raise Bosh::Clouds::CloudError,
              "No valid placement found for disks:\n#{disk_string}\n\n#{pretty_print_cluster_disk}"
      end

      # Filter out placements where the
      # datastore has no active hosts i.e. (hosts are under maintenance) or
      # if there are any active host, they belong to a different cluster
      placement_options = placements_with_active_hosts(placement_options, clusters)
      if placement_options.size == 0
        raise Bosh::Clouds::CloudError,
              "No valid placement found due to no active host (non-maintenance) present on desired cluster"
      end

      if placement_options.size == 1
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_minimum_disk_migrations(placement_options)
      if placement_options.size == 1
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_max_free_space(placement_options)
      if placement_options.size == 1
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_max_free_memory(placement_options)
      format_final_placement(placement_options)
    end

    private

    def filter_on_memory(req_memory)
      @available_clusters.reject { |cluster| cluster.free_memory < req_memory + @mem_headroom }
    end

    def placements_with_active_hosts(placements, clusters)
      clusters.each do |cluster|
        cluster.accessible_datastores.each do |dsname, ds|
          unless ds.accessible_from?(cluster)
            datastore_placements = placements[cluster.name][:datastores]
            datastore_placements.delete(dsname)
            if datastore_placements.length == 0
              placements.delete(cluster.name)
              break
            end
          end
        end
      end
      placements
    end

    def placements_with_minimum_disk_migrations(placements)
      sorted = placements.sort_by { |_, placement| placement[:migration_size] }
      minimum = sorted.first[1][:migration_size]

      sorted.select { |_, placement| placement[:migration_size] == minimum }.to_h
    end

    def placements_with_max_free_space(placements)
      sorted = placements.sort_by { |_, placement| placement[:balance_score] }
      maximum = sorted.last[1][:balance_score]

      sorted.select { |_, placement| placement[:balance_score] == maximum }.to_h
    end

    def placements_with_max_free_memory(placements)
      sorted = placements.sort_by { |_, placement| placement[:memory] }
      maximum = sorted.last[1][:memory]

      sorted.select { |_, placement| placement[:memory] == maximum }.to_h
    end

    def format_final_placement(cluster_placement)
      cluster_name = cluster_placement.keys.first
      datastore_placements = cluster_placement[cluster_name][:datastores]

      final_placement = {}
      final_placement[cluster_name] = {}
      datastore_placements.each do |ds_name, props|
        disks = props[:disks]
        disks.each do |disk|
          final_placement[cluster_name][disk] = ds_name
        end
      end
      final_placement
    end

    def pretty_print_cluster_memory
      cluster_string = ""
      @available_clusters.each do |cluster|
        cluster_string += "- Cluster name: #{cluster.name}, memory: #{cluster.free_memory}\n"
      end
      "Possible placement options:\n#{cluster_string}"
    end

    def pretty_print_cluster_disk
      cluster_string = ""
      @available_clusters.each do |cluster|
        ds_string = DatastorePicker.pretty_print_datastores(cluster.accessible_datastores)
        cluster_string += "- Cluster name: #{cluster.name}\n  Datastores:\n#{ds_string}\n"
      end
      "Possible placement options:\n#{cluster_string}"
    end
  end
end
