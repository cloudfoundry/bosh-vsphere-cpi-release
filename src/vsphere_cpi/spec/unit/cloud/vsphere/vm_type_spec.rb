require 'spec_helper'

module VSphereCloud
  describe VmType do
    let(:datacenter_mob)  { instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) { double('Dataceneter', mob: datacenter_mob)}
    let(:datastores) {['ds-1', 'ds-2', 'clusters' => [{ 'sp-1' => {} }]]}
    let(:gpu_details) { {number_of_gpus: 4} }
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

    describe '#gpu' do
      context 'with gpu' do
        it 'returns a gpu hash with key number_of_gpus and value 4' do
          vm_type_gpu = vm_type.gpu
          puts "#{vm_type_gpu}"
          expect(vm_type_gpu).to_not be(nil)
          expect(vm_type_gpu[:number_of_gpus]).to eq(4)
        end
      end
      context 'without gpu' do
        let(:vm_type) { VmType.new(datacenter, {'datastores' => datastores}) }
        it 'return nil for gpu hash' do
          expect(vm_type.gpu).to be(nil)
        end
      end
    end
  end
end
