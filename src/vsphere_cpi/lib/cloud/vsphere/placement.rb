module VSphereCloud
  class Placement
    attr_reader :resource

    def ==(other)
      other.resource == resource
    end

    def hash
      [resource].hash
    end

    def initialize(resource)
      @resource = resource
    end
  end

  class StoragePlacement < Placement
    extend Forwardable

    def_delegators :@resource,
      :free_space, :accessible?, :name, :maintenance_mode
  end
end