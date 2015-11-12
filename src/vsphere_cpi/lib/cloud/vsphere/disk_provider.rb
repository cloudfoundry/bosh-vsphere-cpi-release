require 'ostruct'
require 'cloud/vsphere/resources/disk'

module VSphereCloud
  class DiskProvider
  # https://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html
  SUPPORTED_DISK_TYPES = %w{
      eagerZeroedThick
      preallocated
      thick
      thin
    }

    DEFAULT_DISK_TYPE = 'preallocated'

    def initialize(virtual_disk_manager, datacenter, resources, disk_path, client, logger)
      @virtual_disk_manager = virtual_disk_manager
      @datacenter = datacenter
      @resources = resources
      @disk_path = disk_path
      @client = client
      @logger = logger
    end

    def create(disk_size_in_mb, disk_type, cluster)
      type = disk_type
      if type.nil?
        type = DEFAULT_DISK_TYPE
      end

      unless SUPPORTED_DISK_TYPES.include?(type)
        raise "Disk type: '#{disk_type}' is not supported"
      end

      if cluster
        datastore = @resources.pick_persistent_datastore_in_cluster(cluster.name, disk_size_in_mb)
      else
        datastore = @datacenter.pick_persistent_datastore(disk_size_in_mb)
      end
      disk_cid = "disk-#{SecureRandom.uuid}"
      @logger.debug("Creating disk '#{disk_cid}' in datastore '#{datastore.name}'")

      @client.create_disk(@datacenter, datastore, disk_cid, @disk_path, disk_size_in_mb, type)
    end

    def find_and_move(disk_cid, cluster, datacenter, accessible_datastores)
      disk = find(disk_cid)
      disk_in_persistent_datastore = @datacenter.persistent_datastores.include?(disk.datastore.name)
      disk_in_accessible_datastore = accessible_datastores.include?(disk.datastore.name)
      if disk_in_persistent_datastore && disk_in_accessible_datastore
        @logger.info("Disk #{disk_cid} found in an accessible, persistent datastore '#{disk.datastore.name}'")
        return disk
      end

      destination_datastore = @resources.pick_persistent_datastore_in_cluster(cluster.name, disk.size_in_mb)

      unless accessible_datastores.include?(destination_datastore.name)
        raise "Datastore '#{destination_datastore.name}' is not accessible to cluster '#{cluster.name}'"
      end

      destination_path = path(destination_datastore, disk_cid)
      @logger.info("Moving #{disk.path} to #{destination_path}")
      @client.move_disk(datacenter, disk.path, datacenter, destination_path)
      @logger.info('Moved disk successfully')
      Resources::Disk.new(disk_cid, disk.size_in_mb, destination_datastore, destination_path)
    end

    def find(disk_cid)
      persistent_datastores = @datacenter.persistent_datastores
      @logger.debug("Looking for disk #{disk_cid} in datastores: #{persistent_datastores}")
      persistent_datastores.each do |_, datastore|
        disk = @client.find_disk(disk_cid, datastore, @disk_path)
        @logger.debug("disk #{disk_cid} found in: #{datastore}") unless disk.nil?
        return disk unless disk.nil?
      end

      other_datastores = @datacenter.all_datastores.reject{|datastore_name, _| persistent_datastores[datastore_name] }
      @logger.debug("disk #{disk_cid} not found in filtered persistent datastores, trying other datastores: #{other_datastores}")
      other_datastores.each do |_, datastore|
        disk = @client.find_disk(disk_cid, datastore, @disk_path)
        @logger.debug("disk #{disk_cid} found in: #{datastore}") unless disk.nil?
        return disk unless disk.nil?
      end

      raise Bosh::Clouds::DiskNotFound.new(false), "Could not find disk with id '#{disk_cid}'"
    end

    private

    def path(datastore, disk_cid)
      "[#{datastore.name}] #{@disk_path}/#{disk_cid}.vmdk"
    end
  end
end
