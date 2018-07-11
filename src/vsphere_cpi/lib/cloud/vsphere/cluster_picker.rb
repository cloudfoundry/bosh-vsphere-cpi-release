module VSphereCloud
  class ClusterPicker
    include Logger
    DEFAULT_MEMORY_HEADROOM = 128

    def initialize(mem_headroom=DEFAULT_MEMORY_HEADROOM, disk_headroom=DatastorePicker::DEFAULT_DISK_HEADROOM)
      @mem_headroom = mem_headroom
      @disk_headroom = disk_headroom
      @available_clusters = []
    end

    def update(available_clusters=[])
      @available_clusters = available_clusters
    end

    def best_cluster_placement(req_memory:, disk_configurations:, gpu_config: nil)
      clusters = filter_on_memory(req_memory)
      if clusters.size == 0
        raise Bosh::Clouds::CloudError,
        "No valid placement found for requested memory: #{req_memory}\n\n#{pretty_print_cluster_memory}"
      end

      placement_options = clusters.map do |cluster|
        datastore_picker = DatastorePicker.new(@disk_headroom)

        # cluster.accessible_datastores gives list of all datastores.
        # Select only those datastores that can be accessed by active hosts in the cluster
        accessible_datastores = cluster.accessible_datastores.select do |_, ds_resource|
          ds_resource.accessible_from?(cluster)
        end
        datastore_picker.update(accessible_datastores)

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

      # Filter in placements where
      # there is atleast one host which has requisite number of available gpus
      placement_options = placements_with_gpu_attached_hosts(placement_options, clusters, gpu_config, req_memory) unless
        gpu_config.nil? ||
        gpu_config['number_of_gpus'].nil? ||
        gpu_config['number_of_gpus'] == 0

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

    def placements_with_gpu_attached_hosts(placements, clusters, gpu_config, req_memory)
      logger.info("GPU Filter : Looking for placement options with #{gpu_config['number_of_gpus']} available GPUs")
      # Select hosts which satisy GPU requirements
      clusters.each do |cluster|
        # Move to next cluster if it is not present in the placements.
        # This happened when there is no datastore possibility for a cluster and it gets removed.
        next unless placements.has_key?(cluster.name)
        logger.info("GPU Filter : Looking for placement options in cluster #{cluster.name}")
        placements[cluster.name][:host_array] = []
        cluster_host_array = placements[cluster.name][:host_array]
        cluster.active_hosts.each do |_, host_resource|
          host_available_gpu = host_resource.available_gpus
          logger.info("GPU Filter : Host #{host_resource.name} in Cluster #{cluster.name} has #{host_available_gpu.size} available GPUs, as below\n\t#{host_available_gpu}")
          cluster_host_array << host_resource if host_available_gpu.size >= gpu_config['number_of_gpus']
        end

        logger.info("GPU Filter: Removing hosts with insufficient memory")
        # reject those hosts which don't have enough memory
        cluster_host_array.reject! do |host|
          logger.info("GPU Filter: Host #{host.name} has #{host.raw_available_memory} , required is #{req_memory}")
          host.raw_available_memory < req_memory
        end

        # Remove the placement if it has no such hosts and move to next
        placements.delete(cluster.name) and
          logger.info("GPU Filter: Removing placement with #{cluster.name} cluster for not having any host for GPU required") and
          next if cluster_host_array.empty?

        logger.info("GPU Filter : Final Host resources for #{cluster.name} are #{pretty_print_host_resource(cluster_host_array)}")
      end
      raise Bosh::Clouds::CloudError,
        "No valid placement found due to no active host found with #{gpu_config['number_of_gpus']} free gpus or enough free memory" if placements.size == 0
      placements
    end

    def pretty_print_host_resource(cluster_host_array)
      host_info = ""
      cluster_host_array.each do |host|
        host_info += "\n-->\tHost #{host.name}\n\n"
      end
      host_info
    end

    def filter_on_memory(req_memory)
      @available_clusters.reject { |cluster| cluster.free_memory < req_memory + @mem_headroom }
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
      # Add host gpu map if it is there
      final_placement[cluster_name][:host_array] = cluster_placement[cluster_name][:host_array] if cluster_placement[cluster_name][:host_array]
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
