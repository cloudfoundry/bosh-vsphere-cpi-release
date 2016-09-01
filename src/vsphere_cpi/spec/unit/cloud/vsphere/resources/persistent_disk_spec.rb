require 'spec_helper'

describe VSphereCloud::Resources::PersistentDisk do
  subject(:persistent_disk) { described_class.new(cid: disk_cid, size_in_mb: size, datastore: datastore, folder: folder_name) }

  let(:disk_cid) { 'disk-cid' }
  let(:size) { 1234 }
  let(:folder_name) { 'fake-folder-name' }
  let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', mob: datastore_mob, name: datastore_name) }
  let(:datastore_name) { 'fake-datastore-name' }
  let(:datastore_mob) { 'fake-datastore-mob' }

  describe 'allowed disk types' do
    it 'supports all documented disk types' do
      expect(described_class::SUPPORTED_DISK_TYPES).to include('eagerZeroedThick')
      expect(described_class::SUPPORTED_DISK_TYPES).to include('preallocated')
      expect(described_class::SUPPORTED_DISK_TYPES).to include('thick')
      expect(described_class::SUPPORTED_DISK_TYPES).to include('thin')
    end
  end

  describe '#create_disk_attachment_spec' do
    let(:controller_key) { double(:controller_key) }

    it 'creates a virtual disk attachment spec' do
      spec = persistent_disk.create_disk_attachment_spec(disk_controller_id: controller_key)

      expect(spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
      expect(spec.device.controller_key).to eq(controller_key)
      expect(spec.device.capacity_in_kb).to eq(size * 1024)
      expect(spec.device.backing.file_name).to eq("[#{datastore_name}] #{folder_name}/#{disk_cid}.vmdk")
      expect(spec.device.backing.datastore).to eq(datastore_mob)
      expect(spec.device.backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT)
    end
  end
end
