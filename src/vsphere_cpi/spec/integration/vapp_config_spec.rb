require 'integration/spec_helper'

context 'when vApp Config is disabled' do

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

  it 'can attach a persistent disk' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec
      )
      vm = @cpi.vm_provider.find(vm_id)

      config = VimSdk::Vim::Vm::ConfigSpec.new
      config.v_app_config_removed = true
      @cpi.client.reconfig_vm(vm.mob, config)
      expect(vm.mob.config.v_app_config).to be_nil

      disk_id = @cpi.create_disk(2048, {}, vm_id)
      expect(disk_id).to_not be_nil

      @cpi.attach_disk(vm_id, disk_id)
      expect(@cpi.has_disk?(disk_id)).to be(true)

      v_app_config = vm.mob.config.v_app_config
      expect(v_app_config).to_not be_nil

      v_app_values = v_app_config.property.map { |prop| prop.value }
      expect(v_app_values).to include(match(/#{disk_id}.vmdk$/))
    ensure
      detach_disk(@cpi, vm_id, disk_id)
      delete_vm(@cpi, vm_id)
      delete_disk(@cpi, disk_id)
    end
  end

  it 'can detach a persistent disk' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec
      )
      vm = @cpi.vm_provider.find(vm_id)

      disk_id = @cpi.create_disk(2048, {}, vm_id)
      expect(disk_id).to_not be_nil

      @cpi.attach_disk(vm_id, disk_id)
      expect(@cpi.has_disk?(disk_id)).to be(true)

      config = VimSdk::Vim::Vm::ConfigSpec.new
      config.v_app_config_removed = true
      @cpi.client.reconfig_vm(vm.mob, config)
      expect(vm.mob.config.v_app_config).to be_nil

      @cpi.detach_disk(vm_id, disk_id)
    ensure
      detach_disk(@cpi, vm_id, disk_id)
      delete_vm(@cpi, vm_id)
      delete_disk(@cpi, disk_id)
    end
  end
end
