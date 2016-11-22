require 'integration/spec_helper'

describe 'ip conflict detection' do

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vlan) { @vlan }

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  describe 'avoiding the creation of vms with duplicate IP addresses' do
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
end
