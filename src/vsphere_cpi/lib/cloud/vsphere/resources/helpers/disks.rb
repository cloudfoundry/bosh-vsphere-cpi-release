module VSphereCloud
  module Resources
    # TODO(cdutra, kaitingc): Refactor this into Disk class to be inherited by
    #                         EphemeralDisk and PersistentDisk
    module Helpers
      class Disks
        class << self

          def create_virtual_disk(disk_controller_id:, size_in_mb:, backing:)
            VimSdk::Vim::Vm::Device::VirtualDisk.new.tap do |virtual_disk|
              virtual_disk.key = -1
              virtual_disk.controller_key = disk_controller_id
              virtual_disk.capacity_in_kb = size_in_mb * 1024
              virtual_disk.backing = backing
            end
          end
        end
      end
    end
  end
end
