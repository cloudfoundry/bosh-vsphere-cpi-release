require 'forwardable'

module VSphereCloud
  class HostPlacementSelectionPipeline < SelectionPipeline
    class HostPlacementCriteria

      attr_reader :num_gpu, :req_mem

      # TODO : make a named variable ctor
      def initialize(num_gpu, req_mem)
        @num_gpu = num_gpu
        @req_mem = req_mem
      end

      def inspect
        "Host Criteria: # of GPU required: #{num_gpu}, Memory required: #{req_mem}"
      end

    end
    private_constant :HostPlacementCriteria

    class HostPlacement
      extend Forwardable

      def_delegators :@resource,
                     :available_gpus, :raw_available_memory

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
        "Host #{resource.name} [Available GPUs: #{resource.available_gpus.size}, Available Memory: #{resource.raw_available_memory}]"
      end

      alias inspect_before inspect
    end
    private_constant :HostPlacement

    # Select host placements which meet the GPU requirement
    with_filter do |host_placement, criteria_object|
      logger.debug("Filter #{host_placement.inspect_before} for # of GPUs required: #{criteria_object.num_gpu}")
      host_placement.available_gpus.size >= criteria_object.num_gpu
    end

    # Select host placements that have at least the amount of memory specified
    with_filter do |host_placement, criteria_object|
      logger.debug("Filter #{host_placement.inspect_before} for required memory: #{criteria_object.req_mem})")
      host_placement.raw_available_memory >= criteria_object.req_mem
    end

    # Score on basis on available_gpus with a bit of randomness
    with_scorer do |p1, p2|
      StableRandom[p1] * p1.available_gpus.size <=> StableRandom[p2] * p2.available_gpus.size
    end

    def initialize(*args)
      super(HostPlacementCriteria.new(*args))
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
      super.map { |resource| HostPlacement.new(resource) }
    end

    def inspect
      "Host Allocator with #{object.inspect}"
    end
  end
end