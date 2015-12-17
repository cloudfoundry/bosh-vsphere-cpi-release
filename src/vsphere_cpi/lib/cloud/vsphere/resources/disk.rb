module VSphereCloud
  class Resources
    class Disk
      attr_reader :cid, :size_in_mb, :datastore, :client, :folder

      def initialize(cid, size_in_mb, datastore, client, folder)
        @cid = cid
        @size_in_mb = size_in_mb
        @datastore = datastore
        @client = client
        @folder = folder
      end

      def create_virtual_device_spec(device)
        device_config_spec = VimSdk::Vim::Vm::Device::VirtualDeviceSpec.new
        device_config_spec.device = device
        device_config_spec.operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD

        device_config_spec
      end

      def create_virtual_disk(controller_key)
        virtual_disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
        virtual_disk.key = -1
        virtual_disk.controller_key = controller_key
        virtual_disk.backing = create_backing_info
        virtual_disk.capacity_in_kb = @size_in_mb * 1024

        virtual_disk
      end

      def create_backing_info
        backing_info = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
        backing_info.datastore = @datastore.mob
        backing_info.file_name = path

        backing_info
      end

      def path
        "[#{@datastore.name}] #{@folder}/#{@cid}.vmdk"
      end
    end
  end
end
