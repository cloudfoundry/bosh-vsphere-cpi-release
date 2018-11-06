require 'integration/spec_helper'

context 'StoragePolicies' do
  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(optional_args))
  end

  let(:storage_policy_name) { 'Gold Storage Policy' }
  context 'when storage_policy is set in vm_type' do
    before(:all) do
      @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
      @datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    end

    let(:optional_args) { {} }
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'storage_policy' => {
          'name' => storage_policy_name
        }
      }
    end
    it 'applies storage policy to VM, disks and places them into compatible datastore' do
      simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
        vm = cpi.vm_provider.find(vm_id)
        ephemeral_disk = vm.ephemeral_disk
        ephemeral_datastore = ephemeral_disk.backing.datastore
        expect(ephemeral_datastore.name).to eq(@datastore)
        check_compliance(cpi, storage_policy_name, vm)
      end
    end
    xit 'raises an error if there are no compatible datastores for given storage policy'
  end

  context 'when "vm_encryption_policy_name" is set' do
    let(:encryption_policy_name) { 'VM Encryption Policy' }
    let(:optional_args) { { 'vm_encryption_policy_name' => encryption_policy_name } }
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end

    it 'encrypts the stemcell, system disk and cloned vm with given policy' do
      begin
        stemcell_id = upload_stemcell(cpi)
        stemcell = VSphereCloud::Resources::VM.new(
          stemcell_id,
          cpi.client.find_vm_by_name(cpi.datacenter.mob, stemcell_id),
          cpi.client
        )
        expect(stemcell.mob.config.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)
        expect(stemcell.system_disk.backing.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)

        vm_lifecycle(cpi, [], vm_type, get_network_spec, stemcell_id) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          check_compliance(cpi, encryption_policy_name, vm)
        end
      ensure
        cpi.delete_stemcell(stemcell_id)
      end
    end

    context 'when storage policy is set in vm_type' do
      let(:vm_type) do
        {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'storage_policy' => {
            'name' => storage_policy_name
          }
        }
      end
      it 'raises an error if non-encryption policy is set in vm_type' do
        begin
          stemcell_id = upload_stemcell(cpi)
          stemcell = VSphereCloud::Resources::VM.new(
            stemcell_id,
            cpi.client.find_vm_by_name(cpi.datacenter.mob, stemcell_id),
            cpi.client
          )
          expect(stemcell.mob.config.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)
          expect(stemcell.system_disk.backing.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)

          expect do
            cpi.create_vm(
              'agent-007',
              stemcell_id,
              vm_type,
              get_network_spec,
              [],
              { 'key' => 'value' }
            )
          end.to raise_error(VSphereCloud::VCenterClient::TaskException, /Invalid operation for device '0'/)
        ensure
          cpi.delete_stemcell(stemcell_id)
        end
      end
    end

    context 'when policy does not exists' do
      let(:optional_args) { { 'vm_encryption_policy_name' => 'Invalid Policy' } }

      it 'raises an error if the encryption policy does not exists' do
        expect{ upload_stemcell(cpi) }.to raise_error("Storage Policy: Invalid Policy not found")
      end
    end
  end
end
