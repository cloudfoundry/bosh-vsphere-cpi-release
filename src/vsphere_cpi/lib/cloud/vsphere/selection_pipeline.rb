module VSphereCloud
  class SelectionPipeline
    include Enumerable

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
      "<Selection Pipeline is composed of these filters #{filter_list} and these scorers #{scorer_list}>"
    end

    def accept?(placement)
      filter_list.all? do |filter|
        filter.call(placement, @object)
      end
    end

    def score(placement)
      scorer_list.each do |scorer|
        placement.score = scorer.call(placement, @object)
      end
    end

    def with_scorer(*args)
      if block_given?
        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end
        scorer_list << Proc.new
      else
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
        filter_list.concat(args)
      end
      self
    end

    # Need to be figured out.
    # TODO: make this return an enumerator if a block is not given
    def each(&block)
      @gather.call.select do |placement|
        accept?(placement)
      end.each do |placement|
        score(placement)
      end.sort.each(&block)
    end

    private

    def filter_list
      @filter_list ||= []
    end

    def scorer_list
      @scorer_list ||= []
    end
  end

  class DiskPlacementSelectionPipeline < SelectionPipeline
    def initialize(object, *args)
      super
      with_filter Filter_Maintenance_Mode_DS, Filter_Free_Space_DS, Filter_Target_Pattern_DS, Filter_Inaccessible_DS
    end
  end
end
