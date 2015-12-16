require 'spec_helper'

module VSphereCloud
  class Resources
    class Disk
      describe EphemeralDisk do
        subject(:ephemeral_disk) { EphemeralDisk.new(VSphereCloud::Resources::EphemeralDisk::DISK_NAME, size, datastore, client, folder_name) }

        let(:size) { 1234 }
        let(:folder_name) { 'fake-folder-name' }
        let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', mob: datastore_mob, name: 'fake-datastore-name') }
        let(:client) { instance_double('VSphereCloud::Client') }
        let(:datastore_mob) { double(:datastore_mob) }

        describe '#create_spec' do
          let(:controller_key) { double(:controller_key) }

          it 'creates a disk' do
            spec = ephemeral_disk.create_spec(controller_key)

            expect(spec.file_operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE)
            expect(spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
            expect(spec.device.controller_key).to eq(controller_key)
            expect(spec.device.capacity_in_kb).to eq(size * 1024)
            expect(spec.device.backing.file_name).to eq('[fake-datastore-name] fake-folder-name/ephemeral_disk.vmdk')
            expect(spec.device.backing.datastore).to eq(datastore_mob)
            expect(spec.device.backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT)
          end
        end
      end
    end
  end
end
