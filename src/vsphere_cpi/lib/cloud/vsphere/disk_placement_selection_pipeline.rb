require 'forwardable'

module VSphereCloud
  class DiskPlacementSelectionPipeline < SelectionPipeline
    DISK_HEADROOM = 1024

    class StoragePlacementCriteria
      attr_reader :size_in_mb, :target_datastore_pattern, :existing_ds_pattern

      def initialize(size_in_mb, target_ds_pattern, existing_ds_pattern = nil)
        @size_in_mb = size_in_mb
        @existing_ds_pattern = existing_ds_pattern
        @target_datastore_pattern = target_ds_pattern
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
    end
    private_constant :StoragePlacement

    # Reject storage placements that are in maintenance mode
    with_filter do |storage_placement|
      !storage_placement.maintenance_mode?
    end

    # Select storage placements that have at least as much free space as
    # specified in the criteria object plus the disk headroom
    with_filter do |storage_placement, criteria_object|
      storage_placement.free_space > DISK_HEADROOM + criteria_object.size_in_mb
    end

    # Select storage placements which match target datastore pattern
    with_filter do |storage_placement, criteria_object|
      storage_placement.name =~ Regexp.new(criteria_object.target_datastore_pattern)
    end

    # Select storage placements that are accessible from any host
    with_filter { |storage_placement| storage_placement.accessible? }

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
  end
end