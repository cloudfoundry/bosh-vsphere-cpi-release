require 'integration/spec_helper'

describe 'ip conflict detection' do

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.3.33",
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
    # create a vm here
    it 'raises an error in create_vm if the ip address is in use' do
      begin
        test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {'key' => 'value'}
        )

        block_on_vmware_tools(@cpi, test_vm_id)

        duplicate_ip_vm_id = nil
        expect {
          duplicate_ip_vm_id = @cpi.create_vm(
              'agent-elba',
              @stemcell_id,
              vm_type,
              network_spec,
              [],
              {'key' => 'value'}
          )
        }.to raise_error /Detected IP conflicts with other VMs on the same networks/
      ensure
        delete_vm(@cpi, test_vm_id)
        delete_vm(@cpi, duplicate_ip_vm_id)
      end
    end
  end

  context 'when testing with fully qualified network names' do
    context 'when a VM already exists on network' do
      context 'when the VM exists on a different network with same unqualified name (we are creating on 1/2/3 and VM exists on 4/5/3)' do
        let(:network_spec_1) do
          {
              'static' => {
                  'ip' => "169.254.3.33",
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
                  'ip' => "169.254.3.33",
                  'netmask' => '255.255.254.0',
                  'cloud_properties' => {'name' => vlan_2},
                  'default' => ['dns', 'gateway'],
                  'dns' => ['169.254.1.2'],
                  'gateway' => '169.254.1.3'
              }
          }
        end
        let(:vlan_1) { ENV.fetch('BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_ONE') } # vcpi-network-folder/vcpi-pg-1-2
        let(:vlan_2) { ENV.fetch('BOSH_VSPHERE_CPI_FOLDER_PORTGROUOP_TWO') }  # vcpi-network-folder-2/vcpi-pg-1-2

        it 'should create the VM' do
          begin
            test_vm_id = @cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                network_spec_1,
                [],
                {'key' => 'value'}
            )

            # Wait for the test VM to get the IP
            # IP Conflict detector works on assumption that every VM in vCenter
            # has already got the IP and is not in boot phase
            block_on_vmware_tools(@cpi, test_vm_id)

            duplicate_ip_vm_id = nil
            expect {
              duplicate_ip_vm_id = @cpi.create_vm(
                  'agent-elba',
                  @stemcell_id,
                  vm_type,
                  network_spec_2,
                  [],
                  {'key' => 'value'}
              )
            }.to_not raise_error
            expect(duplicate_ip_vm_id).to_not be_nil
          ensure
            delete_vm(@cpi, test_vm_id)
            delete_vm(@cpi, duplicate_ip_vm_id)
          end
        end
      end
      context 'when the VM exists on a same network with same unqualified name (we are creating on 1/2/3 and vm exists on 1/2/3' do
        let(:vlan) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_STANDARD') } # vcpi-network-folder/vcpi-pg-1-2
        it 'should raise an error' do
          begin
            test_vm_id = @cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                network_spec,
                [],
                {'key' => 'value'}
            )

            # Wait for the test VM to get the IP
            # IP Conflict detector works on assumption that every VM in vCenter
            # has already got the IP and is not in boot phase
            block_on_vmware_tools(@cpi, test_vm_id)

            duplicate_ip_vm_id = nil
            expect {
              duplicate_ip_vm_id = @cpi.create_vm(
                  'agent-elba',
                  @stemcell_id,
                  vm_type,
                  network_spec,
                  [],
                  {'key' => 'value'}
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
end
