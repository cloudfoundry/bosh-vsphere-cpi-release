module VSphereCloud
  module Resources
    module Helpers
      class Disks
        class << self

          def create_virtual_disk(disk_controller_id:, size_in_mb:, backing:)
            virtual_disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
            virtual_disk.key = -1
            virtual_disk.controller_key = disk_controller_id
            virtual_disk.capacity_in_kb = size_in_mb * 1024
            virtual_disk.backing = backing

            virtual_disk
          end
        end
      end
    end
  end
end
