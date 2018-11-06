require 'spec_helper'

module VSphereCloud
  describe VmType do
    let(:datacenter_mob)  { instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) { double('Dataceneter', mob: datacenter_mob)}
    let(:datastores) {['ds-1', 'ds-2', 'clusters' => [{ 'sp-1' => {} }]]}
    let(:cloud_properties) {
      {
        'datastores' => datastores,
        'vm_group' => 'vcpi-vm-group-1',
        'storage_policy' => {
          'name' => 'Gold Policy'
        }
      }
    }
    let(:vm_type) { VmType.new(datacenter, cloud_properties) }

    describe '#datastore_names' do
      context 'with datastores' do
        it 'returns list of datastore names' do
          expect(vm_type.datastore_names).to eq(['ds-1', 'ds-2'])
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
          expect(vm_type.datastore_clusters).to eq(datastore_clusters)
        end
      end
    end

    describe '#vm_group' do
      it 'returns vm_group name' do
        expect(vm_type.vm_group).to eq('vcpi-vm-group-1')
      end
    end

    describe '#storage_policy_name' do
      it 'returns storage_policy name' do
        expect(vm_type.storage_policy_name).to eq('Gold Policy')
      end
    end
  end
end
