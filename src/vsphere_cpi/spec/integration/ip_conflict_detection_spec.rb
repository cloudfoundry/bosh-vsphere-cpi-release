require 'integration/spec_helper'

describe 'ip conflict detection' do

  let(:fixed_ip_address) { '169.254.3.33' }
  let(:network_spec) do
    {
      'static' => {
        'ip' => fixed_ip_address,
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when testing with just unqualified network name' do
    let(:vlan) { @vlan }

    it 'raises an error in create_vm if the ip address is in use' do
      begin
        test_vm_id, _ = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {}
        )

        block_on_vmware_tools(@cpi, test_vm_id)

        duplicate_ip_vm_id = nil
        expect {
          duplicate_ip_vm_id, _ = @cpi.create_vm(
            'agent-elba',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
        }.to raise_error /Detected IP conflicts with other VMs on the same networks/
      ensure
        delete_vm(@cpi, test_vm_id)
        delete_vm(@cpi, duplicate_ip_vm_id)
      end
    end
  end

  context 'when testing with fully qualified network names' do
    context 'when a VM already exists on a different network with same unqualified name' do

      let(:network_spec_1) do
        {
          'static' => {
            'ip' => fixed_ip_address,
            'netmask' => '255.255.254.0',
            'cloud_properties' => {'name' => vlan_1},
            'default' => ['dns', 'gateway'],
            'dns' => ['169.254.1.2'],
            'gateway' => '169.254.1.3'
          }
        }
      end

      let(:network_spec_2) do
        {
          'static' => {
            'ip' => fixed_ip_address,
            'netmask' => '255.255.254.0',
            'cloud_properties' => {'name' => vlan_2},
            'default' => ['dns', 'gateway'],
            'dns' => ['169.254.1.2'],
            'gateway' => '169.254.1.3'
          }
        }
      end

      let(:vlan_1) { ENV.fetch('BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_ONE') }
      let(:vlan_2) { ENV.fetch('BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_TWO') }

      before do
        verify_vlan(@cpi, vlan_1, 'BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_ONE')
        verify_vlan(@cpi, vlan_2, 'BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_TWO')
      end

      it 'should create the VM' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec_1,
            [],
            {}
          )

          block_on_vmware_tools(@cpi, test_vm_id)

          duplicate_ip_vm_id = nil
          expect {
            duplicate_ip_vm_id, _ = @cpi.create_vm(
              'agent-elba',
              @stemcell_id,
              vm_type,
              network_spec_2,
              [],
              {}
            )
          }.to_not raise_error

          expect(duplicate_ip_vm_id).to_not be_nil
          block_on_vmware_tools(@cpi, duplicate_ip_vm_id)

          test_vm = @cpi.vm_provider.find(test_vm_id)
          duplicate_ip_vm = @cpi.vm_provider.find(duplicate_ip_vm_id)

          expect(test_vm.mob.guest.ip_address).to eq(duplicate_ip_vm.mob.guest.ip_address)
        ensure
          delete_vm(@cpi, test_vm_id)
          delete_vm(@cpi, duplicate_ip_vm_id)
        end
      end
    end
    context 'when the VM already exists on the same network with same unqualified name' do
      let(:vlan) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_STANDARD') }
      it 'should raise an error' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )

          block_on_vmware_tools(@cpi, test_vm_id)

          duplicate_ip_vm_id = nil
          expect {
            duplicate_ip_vm_id, _ = @cpi.create_vm(
              'agent-elba',
              @stemcell_id,
              vm_type,
              network_spec,
              [],
              {}
            )
          }.to raise_error /Detected IP conflicts with other VMs on the same networks/
        ensure
          delete_vm(@cpi, test_vm_id)
          delete_vm(@cpi, duplicate_ip_vm_id)
        end
      end
    end
  end
end
