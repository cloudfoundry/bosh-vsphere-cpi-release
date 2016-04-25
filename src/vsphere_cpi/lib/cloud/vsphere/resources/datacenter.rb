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

      def pick_ephemeral_datastore(size, filter=nil)
        pick_datastore(:ephemeral, size, filter)
      end

      def pick_persistent_datastore(size, filter=nil)
        pick_datastore(:persistent, size, filter)
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

      # TODO: do we care about datastore.allocate?
      def ensure_disk_is_accessible_to_vm(disk, vm)
        disk_is_in_persistent_datastore = persistent_datastores.include?(disk.datastore.name)
        disk_is_in_accessible_datastore = vm.accessible_datastores.include?(disk.datastore.name)
        if disk_is_in_persistent_datastore && disk_is_in_accessible_datastore
          @logger.info("Disk #{disk.cid} found in an accessible, persistent datastore '#{disk.datastore.name}'")
          return disk
        end

        unless vm.accessible_datastores.include?(disk.datastore)
          destination_datastore = pick_persistent_datastore(disk.size_in_mb, vm.accessible_datastores)
          destination_path = path(destination_datastore.name, @disk_path, disk.cid)
          @logger.info("Moving #{disk.path} to #{destination_path}")
          @client.move_disk(mob, disk.path, mob, destination_path)
          @logger.info('Moved disk successfully')
          Resources::PersistentDisk.new(disk.cid, disk.size_in_mb, destination_datastore, @disk_path)
        end
      end

      # Find a cluster for a vm with the requested memory and ephemeral storage, attempting
      # to allocate it near existing persistent disks.
      #
      # @param [Integer] requested_memory_in_mb requested memory.
      # @param [Integer] requested_ephemeral_disk_size_in_mb requested ephemeral storage.
      # @param [Array<Resources::Disk>] existing_persistent_disks existing persistent disks, if any.
      # @return [Cluster] selected cluster if the resources were placed successfully, otherwise raises.
      def pick_cluster_for_vm(requested_memory_in_mb, requested_ephemeral_disk_size_in_mb, existing_persistent_disks)
        # calculate locality to prioritizing clusters that contain the most persistent data.
        cluster_objects = clusters.values
        persistent_disk_index = PersistentDiskIndex.new(cluster_objects, existing_persistent_disks)

        scored_clusters = cluster_objects.map do |cluster|
          persistent_disk_not_in_this_cluster = existing_persistent_disks.reject do |disk|
            persistent_disk_index.clusters_connected_to_disk(disk).include?(cluster)
          end

          score = Scorer.score(
            @logger,
            cluster,
            requested_memory_in_mb,
            requested_ephemeral_disk_size_in_mb,
            persistent_disk_not_in_this_cluster.map(&:size_in_mb)
          )

          [cluster, score]
        end

        acceptable_clusters = scored_clusters.select { |_, score| score > 0 }

        @logger.debug("Acceptable clusters: #{acceptable_clusters.inspect}")

        if acceptable_clusters.empty?
          total_persistent_size = existing_persistent_disks.map(&:size_in_mb).inject(0, :+)
          cluster_infos = cluster_objects.map { |cluster| cluster.describe }

          raise "Unable to allocate vm with #{requested_memory_in_mb}mb RAM, " +
              "#{requested_ephemeral_disk_size_in_mb / 1024}gb ephemeral disk, " +
              "and #{total_persistent_size / 1024}gb persistent disk from any cluster.\n#{cluster_infos.join(", ")}."
        end

        acceptable_clusters = acceptable_clusters.sort_by do |cluster, _score|
          persistent_disk_index.disks_connected_to_cluster(cluster).map(&:size_in_mb).inject(0, :+)
        end.reverse

        if acceptable_clusters.any? { |cluster, _| persistent_disk_index.disks_connected_to_cluster(cluster).any? }
          @logger.debug('Choosing cluster with the greatest available disk')
          selected_cluster, _ = acceptable_clusters.first
        else
          @logger.debug('Choosing cluster by weighted random')
          selected_cluster = Util.weighted_random(acceptable_clusters)
        end

        @logger.debug("Selected cluster '#{selected_cluster.name}'")

        selected_cluster.allocate(requested_memory_in_mb)
        selected_cluster
      end

      def move_disk(source_path, dest_path)
        @client.move_disk(mob, source_path, mob, dest_path)
      end

      private

      def pick_datastore(type, size, filter=nil)
        datastores_to_consider = (type == :ephemeral ? ephemeral_datastores : persistent_datastores).values

        if filter && !filter.empty?
          datastores_to_consider = datastores_to_consider.select { |ds| filter.include?(ds.name) }
        end

        available_datastores = datastores_to_consider.reject { |datastore| datastore.free_space - size < Resources::Datastore::DISK_HEADROOM }
        if available_datastores.empty?
          raise Bosh::Clouds::NoDiskSpace.new(true), "Couldn't find a '#{type}' datastore with #{size}MB of free space. Found:\n #{datastores_to_consider.map(&:debug_info).join("\n ")}\n"
        end

        @logger.debug("Looking for a '#{type}' datastore with #{size}MB free space.")
        @logger.debug("All datastores being considered within datacenter #{self.name}: #{datastores_to_consider.map(&:debug_info)}")
        @logger.debug("Datastores with enough space: #{available_datastores.map(&:debug_info)}")
        selected_datastore = Util.weighted_random(available_datastores.map { |datastore| [datastore, datastore.free_space] })

        selected_datastore
      end

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
