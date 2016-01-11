module VSphereCloud
  module Resources
    class Disk
      attr_reader :cid, :size_in_mb, :datastore, :folder

      def initialize(cid, size_in_mb, datastore, folder)
        @cid = cid
        @size_in_mb = size_in_mb
        @datastore = datastore
        @folder = folder
      end

      def path
        "[#{@datastore.name}] #{@folder}/#{@cid}.vmdk"
      end

      def create_disk_attachment_spec(disk_controller_id)
        virtual_disk = create_virtual_disk(disk_controller_id)
        disk_config_spec = Resources::VM.create_add_device_spec(virtual_disk)

        disk_config_spec
      end

      private

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
    end
  end
end
