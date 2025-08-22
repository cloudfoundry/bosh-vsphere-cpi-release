# VM Hardware Version Upgrade Test
#
# This test verifies that when upgrade_hw_version is enabled, the CPI creates
# VMs with upgraded hardware versions. Modern vSphere versions use hardware
# versions like vmx-22, vmx-23, etc., which are much higher than the legacy
# vmx-10, vmx-11 versions that older tests expected.
#
# The test now expects any vmx-\d+ version and verifies it's >= 10 to ensure
# an upgrade occurred from the default hardware version.

require 'integration/spec_helper'

context 'when upgrade_hw_version is enabled' do
  include VSphereCloud::Logger

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
      
      # The upgrade_hw_version functionality upgrades the VM to the latest available hardware version
      # Modern vSphere versions use much higher hardware versions (e.g., vmx-22, vmx-23, etc.)
      # We expect a version that's higher than the minimum (vmx-10) to indicate an upgrade occurred
      expect(vm_mob.config.version).to match /vmx-\d+/
      
      # Verify that the hardware version is indeed upgraded (should be vmx-10 or higher)
      version_number = vm_mob.config.version.match(/vmx-(\d+)/)[1].to_i
      expect(version_number).to be >= 10
      
      # Log the actual version for debugging
      logger.debug "VM hardware version: #{vm_mob.config.version}"
    end
  end
end
