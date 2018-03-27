module VSphereCloud
  # storageList is a list of datastores and datastore_clusters defined in cloud_properties as 'datastores'
  # Eg. [datastore1, clusters: [{datastore_cluster1: {}, datatore_cluster2: {}}]]
  module StorageList

    #Returns list of datastore names
    def datastore_names
      storage_list.map { |entry| String.try_convert(entry) }.compact
    end

    #Returns list of StoragePod objects for datastore_clusters
    def datastore_clusters
      clusters_hash = storage_list.find do |entry|
        Hash.try_convert(entry)&.key?('clusters')
      end
      return [] if clusters_hash.nil?
      clusters = clusters_hash['clusters']
      clusters.map do |cluster|
        Resources::StoragePod.find_storage_pod(cluster.keys.first, datacenter.mob)
      end
    end
  end
end