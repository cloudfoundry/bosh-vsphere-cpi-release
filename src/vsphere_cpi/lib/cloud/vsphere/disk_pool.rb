module VSphereCloud
  class DiskPool
    attr_reader :datacenter, :type, :datastores

    # @param datastores It is a list of datastores and datastore_clusters.
    # Eg. [datastore1, clusters: [{datastore_cluster1: {}, datatore_cluster2: {}}]]
    def initialize(datacenter, type, datastores)
      @datacenter = datacenter
      @type = type
      @datastores = datastores || []
    end

    def datastore_names
      @datastores.select do |entry|
        entry.is_a?(String)
      end
    end

    #Returns list of StoragePod objects for datastore_clusters
    def datastore_clusters
      clusters_hash = @datastores.find do |entry|
        hash = Hash.try_convert(entry)
        next if hash.nil?
        hash.key?('clusters')
      end
      return [] if clusters_hash.nil?
      clusters = clusters_hash['clusters']
      clusters.map do |cluster|
        Resources::StoragePod.find_storage_pod(cluster.keys.first, @datacenter.mob)
      end
    end
  end
end