module VSphereCloud
  module Resources
    class StoragePod
      attr_reader :mob

      def initialize(mob)
        @mob = mob
      end

      def name
        mob.summary.name
      end

      def free_space
        mob.summary.free_space.to_i / BYTES_IN_MB
      end

      def capacity
        mob.summary.capacity
      end

      def drs_enabled?
        mob.pod_storage_drs_entry.storage_drs_config.pod_config.enabled
      end

      def self.find(name, datacenter_name, client)
        datacenter_mob = client.find_by_inventory_path(datacenter_name)
        raise "Datacenter '#{datacenter_name}' not found." unless datacenter_mob
        datastore_clusters =  datacenter_mob.datastore_folder.child_entity.select {|ce| ce.class == VimSdk::Vim::StoragePod}
        datastore_cluster = datastore_clusters.select { |sp| sp.name == name }.first
        raise "Datastore Cluster with name: '#{name}' not found." unless datastore_cluster
        self.new(datastore_cluster)
      end

      def self.find_storage_pod(name, datacenter_mob)
        datastore_clusters =  datacenter_mob.datastore_folder.child_entity.select {|ce| ce.class == VimSdk::Vim::StoragePod}
        datastore_cluster = datastore_clusters.select { |sp| sp.name == name }.first
        raise "Datastore Cluster with name: '#{name}' not found." unless datastore_cluster
        new(datastore_cluster)
      end

      def datastores
        mob.child_entity
      end
    end
  end
end
