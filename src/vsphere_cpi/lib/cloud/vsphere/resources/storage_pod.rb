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
        mob.summary.free_space
      end

      def capacity
        mob.summary.capacity
      end

      def drs_enabled?
        mob.pod_storage_drs_entry.storage_drs_config.pod_config.enabled
      end

      def self.find(name, datacenter_name, client)
        client.find_by_inventory_path("/#{datacenter_name}/datastore/#{name}")
      end
    end
  end
end
