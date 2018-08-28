require 'cloud/vsphere/logger'
require 'cloud/vsphere/resources/cluster'

module VSphereCloud
  module Resources
    class Datacenter
      include VimSdk
      include ObjectStringifier
      include Logger
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
        @cluster_provider = attrs.fetch(:cluster_provider)
      end

      attr_reader :name, :disk_path, :ephemeral_pattern, :persistent_pattern, :client

      def mob
        mob = @client.find_by_inventory_path(name)
        raise "Datacenter '#{name}' not found" if mob.nil?
        mob
      end

      def vm_folder
        if @use_sub_folder
          folder_path = [@vm_folder, Bosh::Clouds::Config.uuid].join('/')
          Folder.new(folder_path, @client, name)
        else
          master_vm_folder
        end
      end

      def vm_path(vm_cid)
        [name, 'vm', vm_folder.path_components, vm_cid].join('/')
      end

      def master_vm_folder
        Folder.new(@vm_folder, @client, name)
      end

      def template_folder
        if @use_sub_folder
          folder_path = [@template_folder, Bosh::Clouds::Config.uuid].join('/')
          Folder.new(folder_path, @client, name)
        else
          master_template_folder
        end
      end

      def master_template_folder
        Folder.new(@template_folder, @client, name)
      end

      def inspect
        "<Datacenter: #{mob} / #{name}>"
      end

      def clusters
        logger.debug("All clusters provided: #{@clusters}")
        @clusters.keys.map do |cluster_name|
          find_cluster(cluster_name)
        end
      end

      def find_cluster(cluster_name)
        cluster_config = @clusters[cluster_name]
        @cluster_provider.find(cluster_name, cluster_config)
      end

      def find_datastore(datastore_name)
        datastore = accessible_datastores[datastore_name]
        raise "Can't find datastore '#{datastore_name}'" if datastore.nil?
        datastore
      end

      def accessible_datastores
        clusters.inject({}) do |acc, cluster|
          acc.merge!(cluster.accessible_datastores)
          acc
        end
      end

      def create_disk(datastore, size_in_mb, disk_type)
        unless Resources::PersistentDisk::SUPPORTED_DISK_TYPES.include?(disk_type)
          raise "Disk type: '#{disk_type}' is not supported"
        end

        disk_cid = "disk-#{SecureRandom.uuid}"
        logger.debug("Creating disk '#{disk_cid}' in datastore '#{datastore.name}'")

        @client.create_disk(mob, datastore, disk_cid, @disk_path, size_in_mb, disk_type)
      end

      # Find disk in cluster.accessible_datastores,
      # trying to look at datastore where it is most likely to be present first.
      # If disk is not found and vm is present, find disk in vm.accessible_datastores
      # @param [DirectorDiskCID] director_disk_cid
      # @param [Resources::VirtualMachine] vm
      def find_disk(director_disk_cid, vm=nil)
        disk_cid = director_disk_cid.value
        datastore_pattern = director_disk_cid.target_datastore_pattern
        hint_datastores = {}
        unless datastore_pattern.nil?
          logger.debug("Looking for disk #{disk_cid} in datastores matching pattern #{datastore_pattern}")

          regexp = Regexp.new(datastore_pattern)
          hint_datastores = accessible_datastores.select do |name, _|
            name =~ regexp
          end
          disk = find_disk_cid_in_datastores(disk_cid, hint_datastores)
          return disk unless disk.nil?
        end

        logger.debug("Looking for disk #{disk_cid} in datastores matching persistent pattern #{persistent_pattern}")
        regexp = Regexp.new(persistent_pattern)
        persistent_datastores = accessible_datastores.select do |name, _|
          name =~ regexp && !hint_datastores.key?(name)
        end
        disk = find_disk_cid_in_datastores(disk_cid, persistent_datastores)
        return disk unless disk.nil?

        other_datastores = accessible_datastores.reject do |datastore_name, _|
          persistent_datastores.key?(datastore_name) || hint_datastores.key?(datastore_name)
        end
        logger.debug("Disk #{disk_cid} not found in filtered persistent datastores, trying other datastores: #{other_datastores}")
        disk = find_disk_cid_in_datastores(disk_cid, other_datastores)
        return disk unless disk.nil?

        # Disk is not present on any datastore accessible from cluster in global
        # configuration.
        # This means disk is present on a datastore that VM can access. This is
        # because in create_disk there are only two options for a datastore
        #  1. Either a DS accessible from cluster listed in global config
        #  2. Or DS that vm can access (vm refers to vm_cid passed)
        unless vm.nil?
          # @TODO: Filter already looked up datastores from above.
          vm_datastores = vm.accessible_datastores
          logger.debug("Disk #{disk_cid} not found in datastores accessible from global config cluster, searching VM accessible datastores: #{vm_datastores}")
          disk = find_disk_cid_in_datastores(disk_cid, vm_datastores)
          return disk unless disk.nil?
        end

        logger.debug("Disk #{disk_cid} not found in all datastores, searching VM attachments")
        vm_mob = @client.find_vm_by_disk_cid(mob, disk_cid)
        unless vm_mob.nil?
          vm = Resources::VM.new(vm_mob.name, vm_mob, @client)
          disk_path = vm.disk_path_by_cid(disk_cid)
          unless disk_path.nil?
            datastore_name, disk_folder, disk_file = /\[(.+)\] (.+)\/(.+)\.vmdk/.match(disk_path)[1..3]
            datastore = accessible_datastores[datastore_name]
            raise Bosh::Clouds::DiskNotFound.new(false),
              "Could not find disk with id '#{disk_cid}'. Datastore '#{datastore_name}' is not accessible." if datastore.nil?
            disk = @client.find_disk(disk_file, datastore, disk_folder)

            logger.debug("Disk #{disk_cid} found at new location: #{disk.path}") unless disk.nil?
            return disk unless disk.nil?
          end
        end
        raise Bosh::Clouds::DiskNotFound.new(false), "Could not find disk with id '#{disk_cid}'"
      end

      def move_disk_to_datastore(disk, destination_datastore)
        destination_path = "[#{destination_datastore.name}] #{@disk_path}/#{disk.cid}.vmdk"
        logger.info("Moving #{disk.path} to #{destination_path}")
        @client.move_disk(mob, disk.path, mob, destination_path)
        logger.info('Moved disk successfully')
        Resources::PersistentDisk.new(cid: disk.cid, size_in_mb: disk.size_in_mb, datastore: destination_datastore, folder: @disk_path)
      end

      private

      def find_disk_cid_in_datastores(disk_cid, datastores)
        mutex = Mutex.new
        error = nil

        pool = Bosh::ThreadPool.new(max_threads: 5, logger: logger)
        pool.pause

        datastores.each do |_, datastore|
          pool.process do
            begin
              disk = @client.find_disk(disk_cid, datastore, @disk_path)
              unless disk.nil?
                logger.debug("disk #{disk_cid} found in: #{datastore}")
                raise FindSuccessfulException.new(disk)
              end
            rescue => e
              mutex.synchronize do
                error = e if error.nil?
              end
            end
          end
        end

        begin
          pool.resume
          pool.wait
        rescue FindSuccessfulException => e
          return e.result
        ensure
          pool.shutdown
        end

        raise error unless error.nil?

        nil
      end
    end
  end

  class FindSuccessfulException < Exception
    attr_reader :result

    def initialize(result)
      @result = result
    end

    def to_s
      "Successfully found disk '#{result}' (this is not an error)"
    end
  end
end
