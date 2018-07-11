module VSphereCloud
  class DatastorePicker
    DEFAULT_DISK_HEADROOM = 1024

    def initialize(headroom = DEFAULT_DISK_HEADROOM)
      @headroom = headroom
      @available_datastores = {}
    end

    def update(available_datastores={})
      @available_datastores = available_datastores
    end

    # Placement Algorithm:
    #
    # Performs a weighted random sort on the available_datastores to improve disk load balancing.
    # The sort multiplies each datastore's free_space by a random float 0..1 then sorts in descending order.
    # This means the largest datastores have the highest chance of being first, but adds a bit of randomization.
    # After the sort, disks are placed into the first datastore that has enough space for that disk.
    #
    def best_disk_placement(disks, max_swapfile_size=0)
      datastores = {}
      # Create a possible placement hash
      placement = { datastores: datastores, migration_size: 0, balance_score: 0 }
      # Gather all available datastores in the possible placement hash
      @available_datastores.each do |name, props|
        datastores[name] = {
          free_space: props.free_space,
          mob: props.mob,
          disks: [],
        }
      end

      # Reject all the datastores that are in maintenance mode.
      # Possible states are
      #   enteringMaintenance	Started entering maintenance mode, but not finished.
      #       This could happen when waiting for user input or for long-running vmotions to complete.
      #   inMaintenance	Successfully entered maintenance mode.
      #   normal	Default state.
      datastores.keep_if do |_, props|
        props[:mob].summary.maintenance_mode == "normal"
      end
      raise Bosh::Clouds::CloudError, "Datastores matching criteria are in maintenance mode or not accessible. No valid placement found" if placement[:datastores].empty?

      # At this step we only have datastores that are not in maintenance mode
      # and are accessible from at least 1 active host.
      disks.each do |disk|
        existing_ds_name = disk.existing_datastore_name

        # Only persistent disks will have existing_ds_name
        if existing_ds_name =~ Regexp.new(disk.target_datastore_pattern) && datastores.keys.include?(existing_ds_name)
          datastores[existing_ds_name][:disks].push(disk)
          next
        end

        placement_found = false
        weighted_datastores = weighted_random_sort(datastores)
        weighted_datastores.each do |ds|
          additional_required_space = if disk.ephemeral?
                                        disk.size + @headroom + max_swapfile_size
                                      else
                                        disk.size + @headroom
                                      end

          ds_name = ds[0]
          ds_props = ds[1]

          next if additional_required_space > ds_props[:free_space]
          next unless ds_name =~ Regexp.new(disk.target_datastore_pattern)

          datastores[ds_name][:disks].push(disk)
          datastores[ds_name][:free_space] -= additional_required_space
          placement[:migration_size] += additional_required_space if existing_ds_name

          placement_found = true
          break
        end
        raise Bosh::Clouds::CloudError, pretty_print_placement_error([disk]) unless placement_found
      end

      placement = filter_all_placement_without_disks(placement)

      raise Bosh::Clouds::CloudError, "Datastores matching criteria are in maintenance mode. No valid placement found" if placement[:datastores].empty?

      add_balance_score(placement)

    end

    def filter_all_placement_without_disks(placement)
      datastore_placements = placement[:datastores]
      datastore_placements.each do |ds_name, props|
        disks = props[:disks]
        datastore_placements.delete(ds_name) if disks.empty?
      end
      placement
    end

    def pick_datastore_for_single_disk(disk)
      placement = best_disk_placement([disk])
      # we should always find a matching datastore for the disk because best_disk_placement raises an error if no placement was found.
      placement[:datastores].keys.first
    end

    def self.pretty_print_disks(disk_configs)
      disk_configs.map do |disk_config|
        "- Size: #{disk_config.size}, Target DS Pattern: #{disk_config.target_datastore_pattern}, Current Location: #{disk_config.existing_datastore_name || 'N/A'}"
      end.join("\n")
    end

    def self.pretty_print_datastores(datastores)
      datastores.map do |ds_name, ds_props|
        "  - Name: #{ds_name}, free space: #{ds_props.free_space}"
      end.join("\n") + "\n"
    end

    private

    def pretty_print_placement_error(disk_configs)
      "No valid placement found for disks:\n#{DatastorePicker.pretty_print_disks(disk_configs)}\n\n" +
        "Possible placement options:\nDatastores:\n#{DatastorePicker.pretty_print_datastores(@available_datastores)}"
    end

    def add_balance_score(placement)
      targeted_datastores = placement[:datastores].reject do | _, item |
        item[:disks].empty?
      end
      free_spaces = targeted_datastores.map { |_, ds_data| ds_data[:free_space]}.sort

      min = free_spaces.first
      mean = free_spaces.inject(0, &:+) / free_spaces.length
      median = free_spaces[free_spaces.length / 2]

      placement[:balance_score] = min + mean + median
      placement
    end

    def weighted_random_sort(datastores)
      random_hash = {}
      datastores.each do |ds_name, ds_props|
        random_hash[ds_name] = Random.rand * ds_props[:free_space]
      end
      datastores.sort do |x,y|
        random_hash[y[0]] <=> random_hash[x[0]]
      end
    end
  end
end
