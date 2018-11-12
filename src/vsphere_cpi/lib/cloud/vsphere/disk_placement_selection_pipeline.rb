require 'forwardable'

module VSphereCloud
  class DiskPlacementSelectionPipeline < SelectionPipeline
    class StoragePlacementCriteria
      DISK_HEADROOM = 1024

      attr_reader :size_in_mb, :target_datastore_pattern, :existing_ds_pattern,
        :ephemeral_disk, :max_swapfile_size

      alias ephemeral_disk? ephemeral_disk

      # TODO : make a named variable ctor
      def initialize(size_in_mb, target_ds_pattern, existing_ds_pattern = nil, ephemeral = false, max_swapfile_size = 0)
        @size_in_mb = size_in_mb
        @existing_ds_pattern = existing_ds_pattern
        @target_datastore_pattern = target_ds_pattern
        @ephemeral_disk = ephemeral
        @max_swapfile_size = max_swapfile_size
      end

      def required_space
        DISK_HEADROOM + size_in_mb + swapfile_headroom
      end

      def inspect
        "Storage Criteria: Space Req: #{size_in_mb} Target Pattern: #{target_datastore_pattern}
        Existing-DS:#{existing_ds_pattern}"
      end

      private

      def swapfile_headroom
        ephemeral_disk? ? max_swapfile_size : 0
      end
    end
    private_constant :StoragePlacementCriteria

    class StoragePlacement
      extend Forwardable

      def_delegators :@resource,
        :free_space, :accessible?, :name, :maintenance_mode?

      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def ==(other)
        instance_of?(other.class) && other.resource == resource
      end

      def hash
        resource.hash
      end

      def inspect
        "Storage #{resource.name} [free space: #{resource.free_space} maintenance_mode: #{resource.maintenance_mode?} accessible: #{resource.accessible?}]"
      end
      alias inspect_before inspect
    end
    private_constant :StoragePlacement

    # Select storage placements which match target datastore pattern
    with_filter do |storage_placement, criteria_object|
      #logger.debug("Filter #{storage_placement.name} for target DS pattern #{criteria_object.target_datastore_pattern}")
      storage_placement.name =~ Regexp.new(criteria_object.target_datastore_pattern)
    end

    # Reject storage placements that are in maintenance mode
    with_filter do |storage_placement|
      # logger.debug("Filter #{storage_placement.name} for maintenance mode")
      !storage_placement.maintenance_mode?
    end

    # Select storage placements that have at least as much free space as
    # specified in the criteria object plus the disk headroom
    with_filter do |storage_placement, criteria_object|
      #logger.debug("Filter #{storage_placement.name} for free space")
      storage_placement.free_space > criteria_object.required_space
    end

    # Score on basis on free space with a bit of randomness
    with_scorer do |p1, p2|
      StableRandom[p1] * p1.free_space <=> StableRandom[p2] * p2.free_space
    end

    def initialize(*args)
      super(StoragePlacementCriteria.new(*args))
    end

    def each
      # The supermethod returns enum_for(:each) when no block is given. Because
      # :each is indiscriminate the result of that call will actually be an
      # Enumerator that successively yields from *this* method (since even in
      # the supermethod method(:each) will return *this* method). Thus just call
      # the supermethod when no block is given.
      return super unless block_given?

      # When a block is given we can't use any method of Enumerable to satisfy
      # its logic since they all rely on #each (this #each) resulting in an
      # infinite loop. Instead we must pass a block with the actual #map logic.
      super { |placement| yield placement.resource }
    end

    def gather
      super.map { |resource| StoragePlacement.new(resource) }
    end

    def inspect
      "Disk Allocator with #{object.inspect}"
    end
  end
end