require 'integration/spec_helper'

context 'when upgrade_hw_version is enabled' do

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'upgrade_hw_version' => true

    }
  end

  it 'creates a VM with those properties enabled' do
    simple_vm_lifecycle(@cpi, @vlan, vm_type) do |vm_id|
      vm = @cpi.vm_provider.find(vm_id)
      vm_mob = vm.mob
      expect(vm_mob.config.version).to match /vmx-1./
    end
  end
end
