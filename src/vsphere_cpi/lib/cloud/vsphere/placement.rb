module VSphereCloud
  class Placement
    include Comparable

    attr_reader :resource
    attr_accessor :score

    def ==(other)
      other.resource == resource && other.score == score
    end

    alias eql? ==

    def hash
      [resource].hash
    end

    def initialize(resource)
      @resource = resource
      @score = 0
    end

    def <=>(other)
      raise ArgumentError, "Comparison of  #{resource.class} with #{other.class} failed" unless other.instance_of?(self.class)
      score <=> other.score
    end
  end


  class StoragePlacement < Placement
    extend Forwardable

    def initialize(resource)
      unless resource.is_a?(VSphereCloud::Resources::Datastore) || resource.is_a?(VSphereCloud::Resources::StoragePod)
        raise TypeError, "no implicit conversion of #{resource.class} to either VSphereCloud::Resources::Datastore or VSphereCloud::Resources::StoragePod"
      end
      super
    end

    def_delegators :@resource,
      :free_space, :accessible?, :name, :maintenance_mode

    # @return [String] debug StoragePlacement information.
    def inspect
      "#<StoragePlacement @resource : #{resource.inspect} score #{score}>"
    end
  end
end