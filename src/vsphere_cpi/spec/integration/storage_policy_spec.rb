require 'integration/spec_helper'

context 'StoragePolicies' do
  before(:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @first_datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    @mac_storage_profile_compliant_db_name = fetch_property('BOSH_VSPHERE_CPI_MAC_STORAGE_PROFILE_COMPLIANT_DS')
  end
  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(optional_args))
  end

  let(:storage_policy_name) { fetch_property('BOSH_VSPHERE_CPI_LINUX_STORAGE_PROFILE') }

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
        expect(ephemeral_datastore.name).to_not eq(@first_datastore_pattern)
        check_compliance(cpi, storage_policy_name, vm)
      end
    end

    context 'when ephemeral datastore pattern is also specified in vm_type' do
      let(:vm_type) do
        {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'datastores' => [@datastore_pattern],
          'storage_policy' => {
              'name' => storage_policy_name
          }
        }
      end

      it "applies storage policy to VM, disks and places them into compatible datastore and ignores ephemeral datastore pattern" do
        simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          ephemeral_datastore = ephemeral_disk.backing.datastore
          expect(ephemeral_datastore.name).to eq(@datastore)
          expect(ephemeral_datastore.name).to_not eq(@first_datastore_pattern)
          check_compliance(cpi, storage_policy_name, vm)
        end
      end
    end
    context 'and no compatible datastores exist for storage policy' do
      let(:storage_policy_name) { fetch_property('BOSH_VSPHERE_CPI_MINIX_STORAGE_PROFILE') }
      let(:vm_type) do
        {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datastores' => [@datastore_pattern],
            'storage_policy' => {
                'name' => storage_policy_name
            }
        }
      end
      it 'raises an error' do
        expect {
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec)
        }.to raise_error(RuntimeError, "No compatible Datastore for Storage Policy: #{storage_policy_name}" )
      end
    end
    context 'and it is an encryption policy' do
      # We can use the VM Encryption Policy directly as string here because
      # it is a default vCenter proile which is always going to be there before any
      # CPI tests or operations start.
      let(:storage_policy_name) { 'VM Encryption Policy' }
      it 'raises an error' do
        expect {
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec)
        }.to raise_error(VSphereCloud::VCenterClient::TaskException)
      end
    end
    context 'when storage policy is set in global config' do
      let(:global_storage_policy_name) { fetch_property('BOSH_VSPHERE_CPI_MAC_STORAGE_PROFILE') }
      let(:optional_args) { {'vm_storage_policy_name' => global_storage_policy_name} }
      it "applies vm_type storage policy to VM, disks and places them into compatible datastore and ignores global storage policy" do
        simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          ephemeral_datastore = ephemeral_disk.backing.datastore
          expect(ephemeral_datastore.name).to eq(@datastore)
          expect(ephemeral_datastore.name).to_not eq(@first_datastore_pattern)
          check_compliance(cpi, storage_policy_name, vm)
          check_non_compliance(cpi, global_storage_policy_name, vm)
        end
      end
    end
  end

  context 'when storage policy is not set in vm_type' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end
    context 'when storage policy is specified in global_type and global ephemeral pattern is also present' do
      let(:global_storage_policy_name) { fetch_property('BOSH_VSPHERE_CPI_MAC_STORAGE_PROFILE') }
      let(:optional_args) { {'vm_storage_policy_name' => global_storage_policy_name} }
      it 'creates the VM in compliance with global storage policy' do
        simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          ephemeral_datastore = ephemeral_disk.backing.datastore
          expect(ephemeral_datastore.name).to eq(@mac_storage_profile_compliant_db_name)
          expect(ephemeral_datastore.name).to_not eq(@first_datastore_pattern)
          check_compliance(cpi, global_storage_policy_name, vm)
        end
      end
      context 'when ephemeral datastore pattern is specified in vm_type' do
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datastores' => [@second_datastore_pattern],
          }
        end
        it 'creates vm on datastores matching ephemeral datastore pattern, ignoring storage policy at global config level' do
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            ephemeral_disk = vm.ephemeral_disk
            ephemeral_datastore = ephemeral_disk.backing.datastore
            expect(ephemeral_datastore.name).to eq(@second_datastore_pattern)
            expect(ephemeral_datastore.name).to_not eq(@mac_storage_profile_compliant_db_name)
            check_vm_not_assigned_any_policy(cpi, vm)
          end
        end
      end
    end
  end
end
