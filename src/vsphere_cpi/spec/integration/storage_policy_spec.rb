require 'integration/spec_helper'

context 'StoragePolicies' do
  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(optional_args))
  end

  context 'when "vm_encryption_policy_name" is set' do
    let(:optional_args) { { 'vm_encryption_policy_name' => 'VM Encryption Policy' } }
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
          expect(vm.mob.config.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)
          expect(vm.system_disk.backing.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)
          expect(vm.ephemeral_disk.backing.key_id).to be_a(VimSdk::Vim::Encryption::CryptoKeyId)
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
        }
      end
      xit 'raises an error if non-encryption policy is set in vm_type' do
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
          end.to raise_error('Cannot apply this policy')
        ensure
          cpi.delete_stemcell(stemcell_id)
        end
      end
    end

    context 'when policy does not exists' do
      let(:optional_args) { { 'vm_encryption_policy_name' => 'Invalid Policy' } }

      it 'raises an error if the encryption policy does not exists' do
        expect{ upload_stemcell(cpi) }.to raise_error("Policy Not found")
      end
    end
  end
end
