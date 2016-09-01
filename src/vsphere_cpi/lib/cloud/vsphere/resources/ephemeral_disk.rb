module VSphereCloud
  module Resources
    class EphemeralDisk
      DISK_NAME = 'ephemeral_disk'

      attr_reader :cid, :size_in_mb, :datastore, :folder, :disk_type

      def initialize(size_in_mb:, datastore:, folder:, disk_type:)
        @cid = DISK_NAME
        @size_in_mb = size_in_mb
        @datastore = datastore
        @folder = folder
        @disk_type = disk_type
      end

      def path
        "[#{@datastore.name}] #{@folder}/#{@cid}.vmdk"
      end

      def create_disk_attachment_spec(disk_controller_id:)
        backing = create_ephemeral_backing(
          should_thin_provision: @disk_type == 'thin',
        )
        virtual_disk = Helpers::Disks.create_virtual_disk(
          disk_controller_id: disk_controller_id,
          size_in_mb: @size_in_mb,
          backing: backing,
        )

        device_config_spec = Resources::VM.create_add_device_spec(virtual_disk)
        device_config_spec.file_operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE

        device_config_spec
      end

      private

      def create_ephemeral_backing(should_thin_provision:)
        backing_info = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
        backing_info.datastore = @datastore.mob
        backing_info.file_name = path

        # Note: DiskMode::PERSISTENT has no relation to BOSH's persistent disks;
        # https://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.device.VirtualDiskOption.DiskMode.html
        backing_info.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
        backing_info.thin_provisioned = should_thin_provision

        backing_info
      end
    end
  end
end
