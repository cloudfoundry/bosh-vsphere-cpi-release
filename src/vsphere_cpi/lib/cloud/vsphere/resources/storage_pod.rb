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
        storage_pods = search_in_subfolders(datacenter_mob.datastore_folder)

        # Remove the leading datastore folder name from the paths
        storage_pods.transform_keys! { |key| key.sub("/#{datacenter_mob.datastore_folder.name}/", '') }

        matching_storage_pods = storage_pods.select { |path, _| path =~ name_pattern }
        matching_storage_pods.values.map { |storage_pod| new(storage_pod) }
      end

      def self.search_in_subfolders(child_entity, path_prefix = '')
        path_prefix = path_prefix + '/'
        if child_entity.class == VimSdk::Vim::Folder
          paths = {}
          child_entity.child_entity.each do |grandchild|
            paths.merge!(search_in_subfolders(grandchild, path_prefix + child_entity.name ))
          end
          return paths
        end
        if child_entity.class == VimSdk::Vim::StoragePod
          return { path_prefix + child_entity.name => child_entity }
        end
        {}
      end
      private_class_method :search_in_subfolders

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
