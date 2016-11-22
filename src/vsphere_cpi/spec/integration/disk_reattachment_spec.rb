require 'integration/spec_helper'

describe 're-attaching a persistent disk' do

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

  it 're-attaches the disk without locking the cd-rom' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )

      expect(vm_id).to_not be_nil
      expect(@cpi.has_vm?(vm_id)).to be(true)

      disk_id = @cpi.create_disk(2048, {}, vm_id)
      expect(disk_id).to_not be_nil

      @cpi.attach_disk(vm_id, disk_id)
      @cpi.detach_disk(vm_id, disk_id)
      @cpi.attach_disk(vm_id, disk_id)
      @cpi.detach_disk(vm_id, disk_id)
    ensure
      delete_vm(@cpi, vm_id)
      delete_disk(@cpi, disk_id)
    end
  end
end
