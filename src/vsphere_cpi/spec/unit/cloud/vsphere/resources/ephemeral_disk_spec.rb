require 'spec_helper'

describe VSphereCloud::Resources::EphemeralDisk do
  subject(:ephemeral_disk) { described_class.new(size_in_mb: size, datastore: datastore, folder: folder_name, disk_type: global_disk_type) }

  let(:size) { 1234 }
  let(:folder_name) { 'fake-folder-name' }
  let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', mob: datastore_mob, name: datastore_name) }
  let(:datastore_name) { 'fake-datastore-name' }
  let(:datastore_mob) { 'fake-datastore-mob' }
  let(:global_disk_type) { 'fake-global-disk-type' }

  describe '#create_disk_attachment_spec' do
    let(:controller_key) { double(:controller_key) }

    it 'creates a virtual disk attachment spec' do
      spec = ephemeral_disk.create_disk_attachment_spec(disk_controller_id: controller_key)

      expect(spec.file_operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::FileOperation::CREATE)
      expect(spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
      expect(spec.device.controller_key).to eq(controller_key)
      expect(spec.device.capacity_in_kb).to eq(size * 1024)
      expect(spec.device.backing.file_name).to eq("[#{datastore_name}] #{folder_name}/ephemeral_disk.vmdk")
      expect(spec.device.backing.datastore).to eq(datastore_mob)
      expect(spec.device.backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT)
      expect(spec.device.backing.thin_provisioned).to eq(false)
    end

    context 'when default_disk_type is set to "thin"' do
      subject(:ephemeral_disk) { described_class.new(size_in_mb: size, datastore: datastore, folder: folder_name, disk_type: 'thin') }

      it 'creates a thin-provisioned virtual disk attachment spec' do
        spec = ephemeral_disk.create_disk_attachment_spec(disk_controller_id: controller_key)

        expect(spec.device.backing.thin_provisioned).to eq(true)
      end
    end

    context 'when default_disk_type is set to "preallocated"' do
      subject(:ephemeral_disk) { described_class.new(size_in_mb: size, datastore: datastore, folder: folder_name, disk_type: 'preallocated') }

      it 'creates a thin-provisioned virtual disk attachment spec' do
        spec = ephemeral_disk.create_disk_attachment_spec(disk_controller_id: controller_key)

        expect(spec.device.backing.thin_provisioned).to eq(false)
      end
    end
  end
end
