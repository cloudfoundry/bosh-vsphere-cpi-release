module VSphereCloud
  module Resources
    module Disk

      attr_reader :cid, :size_in_mb, :datastore, :folder
      protected :initialize

      def initialize(size_in_mb, datastore, folder)
        @size_in_mb = size_in_mb
        @datastore = datastore
        @folder = folder
      end

      def path
        "[#{@datastore.name}] #{@folder}/#{@cid}.vmdk"
      end

      def create_disk_attachment_spec(disk_controller_id:)
        backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new.tap do |backing_info|
          backing_info.datastore = datastore.mob
          backing_info.file_name = path
        end

        virtual_disk = VimSdk::Vim::Vm::Device::VirtualDisk.new.tap do |virtual_disk|
          virtual_disk.key = -1
          virtual_disk.controller_key = disk_controller_id
          virtual_disk.capacity_in_kb = size_in_mb * 1024
          virtual_disk.backing = backing
        end

        Resources::VM.create_add_device_spec(virtual_disk)
      end
    end

    class EphemeralDisk
      include Disk
      DISK_NAME = 'ephemeral_disk'.freeze

      attr_reader :disk_type

      def initialize(size_in_mb:, datastore:, folder:, disk_type:)
        super(size_in_mb, datastore, folder)
        @cid = DISK_NAME
        @disk_type = disk_type
      end

      def create_disk_attachment_spec(disk_controller_id:)
        super.tap do |spec|
          # Note: DiskMode::PERSISTENT has no relation to BOSH's persistent disks;
          # https://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.device.VirtualDiskOption.DiskMode.html
          spec.device.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
          spec.device.backing.thin_provisioned = @disk_type == 'thin'

          spec.file_operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE
        end
      end
    end

    class PersistentDisk
      include Disk

      # https://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html
      SUPPORTED_DISK_TYPES = %w{
        eagerZeroedThick
        preallocated
        thick
        thin
      }

      def initialize(cid:, size_in_mb:, datastore:, folder:)
        super(size_in_mb, datastore, folder)
        @cid = cid
      end

      def create_disk_attachment_spec(disk_controller_id:)
        super.tap do |spec|
          spec.device.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT
        end
      end
    end
  end
end
