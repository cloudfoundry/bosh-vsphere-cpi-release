require 'spec_helper'

module VSphereCloud
  describe VmType do
    let(:datacenter_mob)  { instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) { double('Dataceneter', mob: datacenter_mob)}
    let(:datastores) {['ds-1', 'ds-2', 'clusters' => [{ 'sp-1' => {} }]]}
    let(:gpu_details) { {'number_of_gpus' => 4, 'vm_group' => 'vcpi-vm-group-1',
                         'host_group' => 'vcpi-host-group-1', 'vm_host_affinity_rule_name' => 'vm-host-rule'} }
    let(:vm_type) { VmType.new(datacenter, {'datastores' => datastores, 'gpu' => gpu_details}) }

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
      context 'with gpu' do
        it 'returns vm_group name' do
          expect(vm_type.vm_group).to eq('vcpi-vm-group-1')
        end
      end
      context 'without gpu' do
        let(:vm_type) { VmType.new(datacenter, {'datastores' => datastores}) }
        it 'returns nil' do
          expect(vm_type.vm_group).to be_nil
        end
      end
    end

    describe '#host_group' do
      context 'with gpu' do
        it 'returns host_group name' do
          expect(vm_type.host_group).to eq('vcpi-host-group-1')
        end
      end
      context 'without gpu' do
        let(:vm_type) { VmType.new(datacenter, {'datastores' => datastores}) }
        it 'returns nil' do
          expect(vm_type.host_group).to be_nil
        end
      end
    end

    describe '#vm_host_affinity_rule_name' do
      context 'with gpu' do
        it 'returns vm_host_affinity_rule_name' do
          expect(vm_type.vm_host_affinity_rule_name).to eq('vm-host-rule')
        end
      end
      context 'without gpu' do
        let(:vm_type) { VmType.new(datacenter, {'datastores' => datastores}) }
        it 'returns nil' do
          expect(vm_type.vm_host_affinity_rule_name).to be_nil
        end
      end
    end
  end
end
