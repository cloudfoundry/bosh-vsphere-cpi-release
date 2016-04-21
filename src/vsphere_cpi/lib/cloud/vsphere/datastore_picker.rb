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

    def suitable_datastores(requested_size, filter=nil)
      @available_datastores.select do |name, free_space|
        enough_space = (free_space - requested_size >= @headroom)
        matches_filter = filter.nil? ? true : name =~ filter
        enough_space && matches_filter
      end
    end

    def can_accomodate_disks?(requested_sizes, filter=nil)
      filter ||= /.*/
      biggest_first = lambda { |x,y| y<=>x }

      biggest_ds_first = @available_datastores.select {|name,_| name =~ filter}.values.sort &biggest_first

      requested_sizes.all? do |request_disk_size|
        can_accomodate = false
        biggest_ds_first.each_with_index do |ds_disk_size, index|
          if ds_disk_size - @headroom >= request_disk_size
            can_accomodate = true
            biggest_ds_first[index] = ds_disk_size-request_disk_size
            break
          else
            ds_disk_size
          end
        end
        can_accomodate
      end

    end

    def pick_datastore(requested_size, filter=nil, &block)
      scores = suitable_datastores(requested_size, filter).map do |name, free_space|
        [name, (block || default_scorer).call(name, free_space)]
      end
      if scores.empty?
        raise Bosh::Clouds::CloudError, "Could not find any suitable datastores matching filter: #{filter.inspect}, with size: #{requested_size}MB. Available datastores: #{@available_datastores.inspect}"
      end
      Resources::Util.weighted_random(scores)
    end

    private

    def default_scorer
      lambda { |name, free_space| free_space }
    end
  end
end
