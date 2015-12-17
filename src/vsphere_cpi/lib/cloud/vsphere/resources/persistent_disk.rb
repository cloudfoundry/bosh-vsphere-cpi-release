module VSphereCloud
  class Resources
    class PersistentDisk < Disk
      def create_backing_info
        backing_info = super
        backing_info.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT

        backing_info
      end
    end
  end
end
