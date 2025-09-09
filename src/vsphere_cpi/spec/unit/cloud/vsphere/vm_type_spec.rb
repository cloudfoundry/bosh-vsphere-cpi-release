require 'spec_helper'

module VSphereCloud
  describe VmType do
    let(:datacenter_mob) { instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) { double('Dataceneter', mob: datacenter_mob) }
    let(:datastores) { ['ds-1', 'ds-2', 'clusters' => [{ 'sp-1' => {} }]] }
    let(:vmx_options) { nil }
    let(:cloud_properties) {
      {
        'datastores' => datastores,
        'vm_group' => 'vcpi-vm-group-1',
        'storage_policy' => storage_policy,
        'vmx_options' => vmx_options
      }
    }
    let(:storage_policy) { {  } }
    let(:pbm) { instance_double(Pbm) }

    let(:vm_type) { VmType.new(datacenter, cloud_properties, pbm) }

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
      let(:storage_policy) { { 'name' => 'Gold Policy' } }
      it 'returns storage_policy name' do
        expect(vm_type.storage_policy_name).to eq('Gold Policy')
      end
    end

    describe '#storage_policy_datastores' do
      context 'when storage policy is not defined' do
        it 'returns empty array' do
          expect(vm_type.storage_policy_datastores(nil)).to be_empty
        end
      end
      context 'when storage policy name is defined' do
        let(:storage_policy) { { 'name' => 'Gold Policy' } }
        it 'returns list of compatible datastores when storage_policy_name is defined' do
          expect(pbm).to receive(:find_compatible_datastores).with('Gold Policy', datacenter).and_return(['expected-datastore'])
          expect(vm_type.storage_policy_datastores('Gold Policy')).to eq(['expected-datastore'])
        end
      end
    end


    describe '#vgpus' do
      let(:cloud_properties) {
        {
          'vgpus' => vgpus
        }
      }
      context 'with vgpus' do
        let(:vgpus) { ['fake-vgpu1', 'fake-vgpu2'] }
        it 'returns list of vgpus' do
          expect(vm_type.vgpus).to eq(vgpus)
        end
      end
      context 'with no vgpus' do
        let(:vgpus) { [] }
        it 'returns an empty array' do
          expect(vm_type.vgpus).to eq(vgpus)
        end
      end
    end

    describe '#vmx_options' do
      context 'with a nil vmx properties' do
        let(:vmx_options) { nil }

        it 'returns nil' do
          expect(vm_type.vmx_options).to eq(nil)
        end
      end

      context 'with a vmx properties object' do
        let(:vmx_options) { { 'abc' => 123 } }

        it 'returns the properties' do
          expect(vm_type.vmx_options).to eq(vmx_options)
        end
      end

      context 'with an invalid type' do
        let(:vmx_options) { ['abc' => 123] }

        it 'raises an error during initialisation' do
          expect { vm_type }.to raise_error(/'vmx_options' is not a Hash/)
        end
      end
    end
  end
end
