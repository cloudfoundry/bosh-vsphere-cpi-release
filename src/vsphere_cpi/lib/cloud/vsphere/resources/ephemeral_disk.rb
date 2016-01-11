module VSphereCloud
  module Resources
    class EphemeralDisk < Disk
      DISK_NAME = 'ephemeral_disk'

      def create_disk_attachment_spec(disk_controller_id)
        device_config_spec = super(disk_controller_id)
        device_config_spec.file_operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE

        device_config_spec
      end

      private

      def create_backing_info
        backing_info = super
        backing_info.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT

        backing_info
      end
    end
  end
end
