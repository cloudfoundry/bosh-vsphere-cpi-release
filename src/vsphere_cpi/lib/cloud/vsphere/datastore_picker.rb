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

    # TODO: summarize the algorithm used here (e.g. first-fit)
    def best_disk_placement(disks)
      datastores = {}
      placement = { datastores: datastores, migration_size: 0, balance_score: 0 }

      @available_datastores.each do |name, props|
        datastores[name] = {
          free_space: props[:free_space],
          disks: [],
        }
      end

      disks.each do |disk|
        existing_ds_name = disk[:existing_datastore_name]

        if existing_ds_name =~ Regexp.new(disk[:target_datastore_pattern]) && datastores.keys.include?(existing_ds_name)
          datastores[existing_ds_name][:disks].push(disk)
          next
        end

        found_placement = false

        weighted_datastores = weighted_random_sort(datastores)
        weighted_datastores.each do |ds|
          additional_required_space = disk[:size] + @headroom

          ds_name = ds[0]
          ds_props = ds[1]
          next if additional_required_space > ds_props[:free_space]
          next unless ds_name =~ Regexp.new(disk[:target_datastore_pattern])

          datastores[ds_name][:disks].push(disk)
          datastores[ds_name][:free_space] -= additional_required_space
          placement[:migration_size] += additional_required_space if existing_ds_name

          found_placement = true
          break
        end

        raise Bosh::Clouds::CloudError, "No valid placement found for disk: #{disk.inspect}" unless found_placement
      end

      add_balance_score(placement)
    end

    def pick_datastore_for_single_disk(disk)
      placement = best_disk_placement([disk])

      placement[:datastores].each do |ds_name, props|
        return ds_name if props[:disks].include?(disk)
      end

      raise Bosh::Clouds::CloudError, "Could not find disk '#{disk}' in placement '#{placement}'"
    end

    private

    def add_balance_score(placement)
      free_spaces = placement[:datastores].map { |_, ds_data| ds_data[:free_space]}.sort

      min = free_spaces.first
      mean = free_spaces.inject(0, &:+) / free_spaces.length
      median = free_spaces[free_spaces.length / 2]

      placement[:balance_score] = min + mean + median
      placement
    end

    def weighted_random_sort(datastores)
      datastores.sort do |x,y|
        y[1][:free_space] * Random.rand <=> x[1][:free_space] * Random.rand
      end
    end
  end
end
