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

      def maintenance_mode?
        mob.child_entity.all? do |ds|
          ds.summary.maintenance_mode != 'normal'
        end
      end

      def accessible?
        mob.child_entity.any? do |ds|
          ds.host.any? do |host_mount|
            !host_mount.key.runtime.in_maintenance_mode
          end
        end
      end

      def capacity
        mob.summary.capacity
      end

      def drs_enabled?
        mob.pod_storage_drs_entry.storage_drs_config.pod_config.enabled
      end

      def self.find_storage_pod(name, datacenter_mob)
        path_segments = name.split('/')
        current_folder = datacenter_mob.datastore_folder
        while path_segments.length > 1
          current_segment = path_segments.shift
          current_folder = current_folder.child_entity.find { |child| child.class == VimSdk::Vim::Folder && child.name == current_segment }
          raise "Datastore Cluster with name: '#{name}' not found." unless current_folder
        end
        pod_name = path_segments.shift
        datastore_cluster = current_folder.child_entity.find { |child| child.class == VimSdk::Vim::StoragePod && child.name == pod_name }
        raise "Datastore Cluster with name: '#{name}' not found." unless datastore_cluster
        new(datastore_cluster)
      end

      def self.search_storage_pods(name_pattern, datacenter_mob)
        path_segments = name_pattern.split('/')
        current_folders = [datacenter_mob.datastore_folder]
        while path_segments.length > 1
          current_segment = Regexp.new("^#{path_segments.shift}$")
          current_folders = current_folders.map { |current_folder| current_folder.child_entity.select { |child| child.class == VimSdk::Vim::Folder && child.name =~ current_segment } }.flatten
        end
        pod_name = Regexp.new("^#{path_segments.shift}$")
        datastore_clusters = current_folders.map { |current_folder| current_folder.child_entity.select { |child| child.class == VimSdk::Vim::StoragePod && child.name =~ pod_name } }.flatten
        datastore_clusters.map do |cluster|
          new(cluster)
        end
      end

      def datastores
        mob.child_entity
      end

      # @return [String] debug storagePod information.
      def inspect
        "<StoragePod: #@mob / #{name}>"
      end

    end
  end
end
