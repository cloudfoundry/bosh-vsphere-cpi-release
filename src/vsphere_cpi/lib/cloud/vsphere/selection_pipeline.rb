module VSphereCloud
  class SelectionPipeline
    include Enumerable
    include Logger

    module StableRandom
      def self.[](object)
        @memo ||= {}
        @memo[object] ||= Random.rand
      end
    end

    # @return [Object] the object to select placements for
    attr_reader :object

    def self.with_filter(*args, &block)
      filter_list << { args: args, block: block }
    end

    def self.filter_list
      @filter_list ||= []
    end

    def self.with_scorer(*args, &block)
      scorer_list << { args: args, block: block }
    end

    def self.scorer_list
      @scorer_list ||= []
    end

    # @param object [Object] the object to select placements for
    def initialize(object, *args)
      raise ArgumentError, 'No gather block provided' unless block_given?

      @object = object
      @gather = Proc.new

      self.class.filter_list.each do |filter|
        with_filter(*filter[:args], &filter[:block])
      end

      self.class.scorer_list.each do |scorer|
        with_scorer(*scorer[:args], &scorer[:block])
      end
    end

    def inspect
      "#<SelectionPipeline @filter_list #{filter_list} @scorer_list #{scorer_list}>"
    end

    def accept?(placement)
      result = filter_list.all? do |filter|
        result = filter.call(placement, @object)
        logger.info("Rejecting #{placement.inspect}") unless result
        result
      end
      logger.info("Selecting (All filter passed) : #{placement.inspect}") if result
      result
    end

    def each
      return enum_for(:each) unless block_given?

      logger.info("Initiating #{inspect}")

      gather.select do |placement|
        logger.info("Applying filters to #{placement.inspect_before}")
        accept?(placement)
      end.sort(&compare_placements).each(&Proc.new)
    end

    def with_filter(*args)
      if block_given?
        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end

        filter_list << Proc.new
      else
        raise ArgumentError, "0 arguments passed, expected atleast 1 arg or a block if no args provided" if args.empty?
        filter_list.concat(args)
      end
      self
    end

    def with_scorer(*args)
      if block_given?
        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end
        scorer_list << Proc.new
      else
        raise ArgumentError, "0 arguments passed, expected at least 1 arg or a block if no args provided" if args.empty?
        scorer_list.concat(args)
      end
      self
    end

    private

    def compare_placements
      lambda do |p1, p2|
        scorer_list.each do |scorer|
          result = scorer.call(p1, p2)
          if result != 0
            return result
          end
        end
        return 0
      end
    end

    def gather
      @gather.call
    end

    def filter_list
      @filter_list ||= []
    end

    def scorer_list
      @scorer_list ||= []
    end
  end
end
