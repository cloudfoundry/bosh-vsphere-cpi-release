require 'spec_helper'

module VSphereCloud
  describe DiskPool do
    let(:datacenter_mob)  { instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) { double('Dataceneter', mob: datacenter_mob)}
    let(:datastores) {['ds-1', 'ds-2', 'clusters' => [{ 'sp-1' => {} }]]}
    let(:disk_pool) { DiskPool.new(datacenter, 'thin', datastores) }

    describe '#datastore_names' do
      context 'with datastores' do
        it 'returns list of datastore names' do
          expect(disk_pool.datastore_names).to eq(['ds-1', 'ds-2'])
        end
      end
      context 'with nil datastores' do
        let(:datastores) { nil }
        it 'returns an empty list' do
          expect(disk_pool.datastore_names).to be_empty
        end
      end
      context 'with no datastores' do
        let(:datastores) { ['clusters' => [{ 'sp-1' => {} }]] }
        it 'returns an empty list' do
          expect(disk_pool.datastore_names).to be_empty
        end
      end
    end

    describe '#datastore_clusters' do
      context 'with clusters' do
        let(:datastore_cluster) { Resources::StoragePod.new('fake_storage_pod1_mob') }
        before do
          expect(Resources::StoragePod).to receive(:find_storage_pod).with('sp-1', datacenter_mob).and_return(datastore_cluster)
        end
        it 'returns list of storage_pod objects for given datastore clusters' do
          datastore_clusters = [datastore_cluster]
          expect(disk_pool.datastore_clusters).to eq(datastore_clusters)
        end
      end
      context 'with nil datastores' do
        let(:datastores) { nil }
        it 'returns an empty list' do
          expect(disk_pool.datastore_clusters).to be_empty
        end
      end
      context 'with no clusters' do
        let(:datastores) { ['ds-1', 'ds-2'] }
        it 'returns an empty list' do
          expect(disk_pool.datastore_clusters).to be_empty
        end
      end
    end
  end
end
