module VSphereCloud
  class SelectionPipeline
    include Enumerable
    include Logger

    # @return [Object] the object to select placements for
    attr_reader :object

    # @param object [Object] the object to select placements for
    def initialize(object, *args)
      raise ArgumentError, 'No gather block provided' unless block_given?
      @object = object
      @gather = Proc.new
    end

    # @return [String] debug Selection Pipeline information.
    def inspect
      "#<SelectionPipeline @filter_list #{filter_list} @scorer_list #{scorer_list}>"
    end

    def accept?(placement)
      filter_list.all? do |filter|
        filter.call(placement, @object)
      end
    end

    def score(placement)
      scorer_list.reduce(0) do |score, scorer|
        score + scorer.call(placement, @object)
      end
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

    def each(&block)
      return enum_for(:each) unless block_given?

      @gather.call.select do |placement|
        accept?(placement)
      end.sort_by do |placement|
        score(placement)
      end.each(&block)
    end

    private

    def filter_list
      @filter_list ||= []
    end

    def scorer_list
      @scorer_list ||= []
    end
  end
end
