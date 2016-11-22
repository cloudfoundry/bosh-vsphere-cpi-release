require 'integration/spec_helper'

context 'when having cpu/mem hot add enabled' do

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => @vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let (:vm_type_with_hot_params) do
    vm_type.merge({
      'cpu_hot_add_enabled' => true,
      'memory_hot_add_enabled' => true
    })
  end

  it 'creates a VM with those properties enabled' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type_with_hot_params,
        network_spec,
        [],
        {}
      )

      expect(vm_id).to_not be_nil
      vm = @cpi.vm_provider.find(vm_id)
      vm_mob = vm.mob
      expect(vm_mob.config.cpu_hot_add_enabled).to be(true)
      expect(vm_mob.config.memory_hot_add_enabled).to be(true)
    ensure
      delete_vm(@cpi, vm_id)
    end
  end
end
