require 'cloud/vsphere/resources/cluster'

module VSphereCloud
  module Resources
    class Datacenter
      include VimSdk
      include ObjectStringifier
      stringify_with :name

      attr_accessor :config

      def initialize(attrs)
        @client = attrs.fetch(:client)
        @use_sub_folder = attrs.fetch(:use_sub_folder)
        @vm_folder = attrs.fetch(:vm_folder)
        @template_folder = attrs.fetch(:template_folder)
        @name = attrs.fetch(:name)
        @disk_path = attrs.fetch(:disk_path)
        @ephemeral_pattern = attrs.fetch(:ephemeral_pattern)
        @persistent_pattern = attrs.fetch(:persistent_pattern)
        @clusters = attrs.fetch(:clusters)
        @logger = attrs.fetch(:logger)
        @mem_overcommit = attrs.fetch(:mem_overcommit)

        @cluster_provider = ClusterProvider.new(self, @client, @logger)
      end

      attr_reader :name, :disk_path, :ephemeral_pattern, :persistent_pattern, :mem_overcommit

      def mob
        mob = @client.find_by_inventory_path(name)
        raise "Datacenter '#{name}' not found" if mob.nil?
        mob
      end

      def vm_folder
        if @use_sub_folder
          folder_path = [@vm_folder, Bosh::Clouds::Config.uuid].join('/')
          Folder.new(folder_path, @logger, @client, name)
        else
          master_vm_folder
        end
      end

      def vm_path(vm_cid)
        [name, 'vm', vm_folder.path_components, vm_cid].join('/')
      end

      def master_vm_folder
        Folder.new(@vm_folder, @logger, @client, name)
      end

      def template_folder
        if @use_sub_folder
          folder_path = [@template_folder, Bosh::Clouds::Config.uuid].join('/')
          Folder.new(folder_path, @logger, @client, name)
        else
          master_template_folder
        end
      end

      def master_template_folder
        Folder.new(@template_folder, @logger, @client, name)
      end

      def inspect
        "<Datacenter: #{mob} / #{name}>"
      end

      def clusters
        @logger.debug("All clusters provided: #{@clusters}")
        @clusters.keys.inject({}) do |acc, cluster_name|
          acc[cluster_name] = find_cluster(cluster_name)
          acc
        end
      end

      def clusters_hash
        available_clusters = {}
        clusters.each do |cluster_name, cluster|
          cluster_datastores = {}
          cluster.all_datastores.each do |datastore_name, datastore|
            cluster_datastores[datastore_name] = datastore.free_space
          end
          available_clusters[cluster_name] = {
            memory: cluster.free_memory,
            datastores: cluster_datastores
          }
        end
        available_clusters
      end

      def datastores_hash
        available_datastores = {}
        clusters.each do |cluster_name, cluster|
          cluster.all_datastores.each do |datastore_name, datastore|
            available_datastores[datastore_name] = datastore.free_space
          end
        end
        available_datastores
      end

      def find_cluster(cluster_name)
        cluster_config = @clusters[cluster_name]
        @cluster_provider.find(cluster_name, cluster_config)
      end

      def find_datastore(datastore_name)
        datastore = all_datastores[datastore_name]
        raise "Can't find datastore '#{datastore_name}'" if datastore.nil?
        datastore
      end

      def ephemeral_datastores
        clusters.values.inject({}) do |acc, cluster|
          acc.merge!(cluster.ephemeral_datastores)
          acc
        end
      end

      def persistent_datastores
        clusters.values.inject({}) do |acc, cluster|
          acc.merge!(cluster.persistent_datastores)
          acc
        end
      end

      def all_datastores
        clusters.values.inject({}) do |acc, cluster|
          acc.merge!(cluster.all_datastores)
          acc
        end
      end

      def disks_hash(cids)
        disks = {}
        cids.each do |cid|
          disk = find_disk(cid)
          datastore_name = disk.datastore.name
          disks[datastore_name] = {} if disks[datastore_name].nil?
          disks[datastore_name][cid] = disk.size_in_mb
        end
        disks
      end

      # TODO: do we care about datastore.allocate?
      def create_disk(datastore, size_in_mb, type)
        disk_type = type

        if disk_type.nil?
          disk_type = Resources::PersistentDisk::DEFAULT_DISK_TYPE
        end

        unless Resources::PersistentDisk::SUPPORTED_DISK_TYPES.include?(disk_type)
          raise "Disk type: '#{disk_type}' is not supported"
        end

        disk_cid = "disk-#{SecureRandom.uuid}"
        @logger.debug("Creating disk '#{disk_cid}' in datastore '#{datastore.name}'")

        @client.create_disk(mob, datastore, disk_cid, @disk_path, size_in_mb, disk_type)
      end

      def find_disk(disk_cid)
        @logger.debug("Looking for disk #{disk_cid} in datastores: #{persistent_datastores}")

        disk = find_disk_cid_in_datastores(disk_cid, persistent_datastores)
        return disk unless disk.nil?

        other_datastores = all_datastores.reject{|datastore_name, _| persistent_datastores[datastore_name] }
        @logger.debug("disk #{disk_cid} not found in filtered persistent datastores, trying other datastores: #{other_datastores}")
        disk = find_disk_cid_in_datastores(disk_cid, other_datastores)
        return disk unless disk.nil?

        @logger.debug("disk #{disk_cid} not found in all datastores, searching VM attachments")
        vm_mob = @client.find_vm_by_disk_cid(mob, disk_cid)
        unless vm_mob.nil?
          vm = Resources::VM.new(vm_mob.name, vm_mob, @client, @logger)
          disk_path = vm.disk_path_by_cid(disk_cid)
          datastore_name, disk_folder, disk_file = /\[(.+)\] (.+)\/(.+)\.vmdk/.match(disk_path)[1..3]
          datastore = all_datastores[datastore_name]
          disk = @client.find_disk(disk_file, datastore, disk_folder)

          @logger.debug("disk #{disk_cid} found at new location: #{disk.path}") unless disk.nil?
          return disk unless disk.nil?
        end
        raise Bosh::Clouds::DiskNotFound.new(false), "Could not find disk with id '#{disk_cid}'"
      end

      def move_disk_to_datastore(disk, destination_datastore)
        destination_path = path(destination_datastore.name, @disk_path, disk.cid)
        @logger.info("Moving #{disk.path} to #{destination_path}")
        @client.move_disk(mob, disk.path, mob, destination_path)
        @logger.info('Moved disk successfully')
        Resources::PersistentDisk.new(disk.cid, disk.size_in_mb, destination_datastore, @disk_path)
      end

      private

      def path(datastore_name, disk_path, disk_cid)
        "[#{datastore_name}] #{disk_path}/#{disk_cid}.vmdk"
      end

      def find_disk_cid_in_datastores(disk_cid, datastores)
        datastores.each do |_, datastore|
          disk = @client.find_disk(disk_cid, datastore, @disk_path)
          unless disk.nil?
            @logger.debug("disk #{disk_cid} found in: #{datastore}")
            return disk
          end
        end
        nil
      end

      class PersistentDiskIndex
        def initialize(clusters, existing_persistent_disks)
          @clusters_to_disks = Hash[*clusters.map do |cluster|
              [cluster, existing_persistent_disks.select { |disk| cluster_includes_datastore?(cluster, disk.datastore) }]
            end.flatten(1)]

          @disks_to_clusters = Hash[*existing_persistent_disks.map do |disk|
              [disk, clusters.select { |cluster| cluster_includes_datastore?(cluster, disk.datastore) }]
            end.flatten(1)]
        end

        def cluster_includes_datastore?(cluster, datastore)
          cluster.persistent(datastore.name) != nil
        end

        def disks_connected_to_cluster(cluster)
          @clusters_to_disks[cluster]
        end

        def clusters_connected_to_disk(disk)
          @disks_to_clusters[disk]
        end
      end
    end
  end
end
