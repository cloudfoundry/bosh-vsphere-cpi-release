module VSphereCloud
  class Placement
    include Comparable

    attr_reader :resource, :score

    METHOD_NOT_IMPLEMENTED = "method is not overridden/implemented in sub class"

    def eql?(other)
      other.resource == resource && other.score == score
    end

    def hash
      [resource].hash
    end

    def inspect
      raise NotImplementedError, "#{METHOD_NOT_IMPLEMENTED}"
    end

    def initialize(resource)
      @resource = resource
      @score = 0
    end

    def <=>(other)
      raise TypeError, "no implicit conversion of #{other.class} to #{resource.class}" unless other.instance_of?(self.class)
      score <=> other.score
    end
  end


  class StoragePlacement < Placement
    def initialize(resource)
      unless resource.is_a?(VSphereCloud::Resources::Datastore) || resource.is_a?(VSphereCloud::Resources::StoragePod) then
        raise TypeError, "no implicit conversion of #{resource.class} to either VSphereCloud::Resources::Datastore or VSphereCloud::Resources::StoragePod"
      end
      super
    end

    # @return [Integer] free space present with the resource
    def free_space
      resource.free_space
    end

    # @return [Boolean] accessibility of the resource
    def accessible?
      resource.accessible?
    end

    # @return [Boolean] whether resource is in normal maintenance mode state
    def maintenance_mode
      resource.maintenance_mode
    end

    # @return [String] name of the resource
    def name
      resource.name
    end

    # @return [String] debug StoragePlacement information.
    def inspect
      "<Placement has resource : #{resource.inspect} and score #{score}>"
    end
  end
end