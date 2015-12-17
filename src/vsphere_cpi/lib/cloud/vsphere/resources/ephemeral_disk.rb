module VSphereCloud
  class Resources
    class EphemeralDisk < Disk
      DISK_NAME = 'ephemeral_disk'

      def create_virtual_device_spec(virtual_disk)
        device_config_spec = super(virtual_disk)
        device_config_spec.file_operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE

        device_config_spec
      end

      def create_backing_info
        backing_info = super
        backing_info.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT

        backing_info
      end
    end
  end
end
