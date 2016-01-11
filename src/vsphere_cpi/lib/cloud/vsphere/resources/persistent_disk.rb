module VSphereCloud
  module Resources
    class PersistentDisk < Disk
      # https://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html
      SUPPORTED_DISK_TYPES = %w{
        eagerZeroedThick
        preallocated
        thick
        thin
      }

      DEFAULT_DISK_TYPE = 'preallocated'

      def create_backing_info
        backing_info = super
        backing_info.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT

        backing_info
      end
    end
  end
end
