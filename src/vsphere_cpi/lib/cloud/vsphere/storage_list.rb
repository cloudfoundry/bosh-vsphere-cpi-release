module VSphereCloud
  module StorageList

    # storageList is a list of datastores and datastore_clusters defined in cloud_properties as 'datastores'
    # Eg. [datastore1, clusters: [{datastore_cluster1: {}, datatore_cluster2: {}}]]

    #Returns list of datastore names
    def datastore_names
      storage_list.select do |entry|
        entry.is_a?(String)
      end
    end

    #Returns list of StoragePod objects for datastore_clusters
    def datastore_clusters
      clusters_hash = storage_list.find do |entry|
        hash = Hash.try_convert(entry)
        next if hash.nil?
        hash.key?('clusters')
      end
      return [] if clusters_hash.nil?
      clusters = clusters_hash['clusters']
      clusters.map do |cluster|
        Resources::StoragePod.find_storage_pod(cluster.keys.first, datacenter.mob)
      end
    end
  end
end