require 'spec_helper'

describe VSphereCloud::Resources::StoragePod do
  subject(:storage_pod) {
    described_class.new(storage_pod_mob)
  }
  let(:pod_storage_drs_entry) { instance_double('VimSdk::Vim::StorageResourceManager::PodStorageDrsEntry')}
  let(:summary) { double(:fake_summary, name: 'cpi-sp1', free_space: 1048576, capacity: 1060000)}
  let(:storage_pod_mob)  { instance_double('VimSdk::Vim::StoragePod', summary: summary, pod_storage_drs_entry: pod_storage_drs_entry) }

  describe '#mob' do
    it 'returns the mob' do
      expect(storage_pod.mob).to eq(storage_pod_mob)
    end
  end

  describe '#name' do
    it 'returns the name' do
      expect(storage_pod.name).to eq('cpi-sp1')
    end
  end

  describe '#capacity' do
    it 'returns the total space' do
      expect(storage_pod.capacity).to eq(1060000)
    end
  end

  describe '#free_space' do
    it 'returns the free space in MB' do
      expect(storage_pod.free_space).to eq(1)
    end
  end

  describe '#drs_enabled?' do
    it 'returns true when drs is enabled' do
      allow(pod_storage_drs_entry).to receive_message_chain(:storage_drs_config, :pod_config, :enabled).and_return(true)
      expect(storage_pod.drs_enabled?).to eq(true)
    end
  end

  describe '.find' do
    let(:datacenter) { double('VimSdk::Vim::Datacenter')}
    let(:datastore_folder) { double('datastore_folder')}
    let(:client) { double('VSphereCloud::VCenterClient') }
    let(:storage_pod_name) {'cpi-sp1'}
    let(:storage_pod) {instance_double('VimSdk::Vim::StoragePod', name: storage_pod_name)}
    context 'with non-existent datacenter' do
      it 'raises an error' do
        allow(client).to receive(:find_by_inventory_path).with('dc1').and_return(nil)
        expect {
          described_class.find(storage_pod_name, 'dc1', client)
        }.to raise_error /Datacenter 'dc1' not found/
      end
    end

    context 'with valid datacenter' do
      before do
        expect(client).to receive(:find_by_inventory_path).with('dc1').and_return(datacenter)
        allow(datacenter).to receive(:datastore_folder).and_return(datastore_folder)
      end

      it 'raises an error if storage_pod is not found' do
        expect(datastore_folder).to receive(:child_entity).and_return([])
        expect {
          described_class.find(storage_pod_name, 'dc1', client)
        }.to raise_error /Storage Pod 'cpi-sp1' not found/
      end

      it 'returns an instance of Resources::StoragePod when storage_pod if found' do
        expect(datastore_folder).to receive(:child_entity).and_return([storage_pod])
        allow(storage_pod).to receive(:class).and_return(VimSdk::Vim::StoragePod)
        storage_pod = described_class.find(storage_pod_name, 'dc1', client)
        expect(storage_pod).to be_a(VSphereCloud::Resources::StoragePod)
      end
    end
  end

end
