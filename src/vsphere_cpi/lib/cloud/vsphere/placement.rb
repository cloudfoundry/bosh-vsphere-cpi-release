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
      :free_space, :accessible?, :name, :maintenance_mode?
  end

  class VmPlacement < Placement
    include Comparable
    extend Forwardable

    # Sorting in reverse order. This is important for prioritizing right
    # cluster.
    # other <=> this vs actual <=> this
    def <=>(other)
      return other.migration_size <=> migration_size unless
        (migration_size <=> other.migration_size) == 0
      return other.balance_score <=> balance_score unless
        (balance_score <=> other.balance_score) == 0
      other.free_memory <=> free_memory
    end

    def ==(other)
      other.resource.cluster.name == resource.cluster.name
    end

    def hash
      cluster.name.hash
    end

    def_delegators :@resource,
      :free_memory, :balance_score, :migration_size,:cluster, :datastores,
      :hosts, :cluster_ds_map=, :cluster_ds_map
  end

  class VmPlacementResource
    attr_reader :cluster, :hosts, :datastores
    attr_accessor :cluster_ds_map

    def initialize(cluster: , hosts: , datastores:)
      @cluster = cluster
      @hosts = hosts
      @datastores = datastores
      @cluster_ds_map = nil
    end

    def free_memory
      cluster.free_memory
    end

    def balance_score
      return nil unless cluster_ds_map
      cluster_ds_map[:balance_score]
    end

    def migration_size
      return nil unless cluster_ds_map
      cluster_ds_map[:migration_size]
    end
  end
end