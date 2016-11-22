require 'integration/spec_helper'

context 'when a persistent disk is attached' do
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

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'in "persistent" (dependent) mode' do

    before do
      @vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )
      expect(@vm_id).to_not be_nil
      expect(@cpi.has_vm?(@vm_id)).to be(true), 'Expected has_vm? to be true'

      @disk_id = @cpi.create_disk(2048, {}, @vm_id)
      expect(@disk_id).to_not be_nil

      @cpi.attach_disk(@vm_id, @disk_id)

      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'

      @vm = @cpi.vm_provider.find(@vm_id)

      virtual_disk = @vm.persistent_disks.first
      virtual_disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
      edit_spec = VSphereCloud::Resources::VM.create_edit_device_spec(virtual_disk)

      config = VimSdk::Vim::Vm::ConfigSpec.new
      config.device_change << edit_spec

      @vm.power_off
      @cpi.client.reconfig_vm(@vm.mob, config)
      @vm.power_on
    end

    after do
      delete_vm(@cpi, @vm_id)

      if @disk_id && @cpi.has_disk?(@disk_id)
        delete_disk(@cpi, @disk_id)
      end
    end

    it 'can still find disk after deleting VM' do
      @cpi.delete_vm(@vm_id)
      @vm_id = nil

      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
    end
  end

  context 'in "nonpersistent" mode' do

    before do
      @vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )
      expect(@vm_id).to_not be_nil
      expect(@cpi.has_vm?(@vm_id)).to be(true), 'Expected has_vm? to be true'

      @disk_id = @cpi.create_disk(2048, {}, @vm_id)
      expect(@disk_id).to_not be_nil

      @cpi.attach_disk(@vm_id, @disk_id)

      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'

      @vm = @cpi.vm_provider.find(@vm_id)

      # power off VM first to ensure new disk mode is in use
      @vm.power_off

      virtual_disk = @vm.persistent_disks.first
      virtual_disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
      edit_spec = VSphereCloud::Resources::VM.create_edit_device_spec(virtual_disk)

      config = VimSdk::Vim::Vm::ConfigSpec.new
      config.device_change << edit_spec

      @cpi.client.reconfig_vm(@vm.mob, config)
      @vm.power_on
    end

    after do
      # use lower-level client calls to bypass disk safety checks on cleanup
      if @vm_id
        @cpi.client.power_off_vm(@vm.mob)
        @cpi.client.delete_vm(@vm.mob)
      end

      if @disk_id && @cpi.has_disk?(@disk_id)
        @cpi.delete_disk(@disk_id)
      end
    end

    it 'refuses to delete the VM' do
      expect do
        @cpi.delete_vm(@vm_id)
      end.to raise_error(/The following disks are attached with non-persistent disk modes/)

      expect(@cpi.has_vm?(@vm_id)).to be(true), "Expected #{@vm_id} to still exist"
      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
    end

    it 'refuses to reboot the VM' do
      expect do
        @cpi.reboot_vm(@vm_id)
      end.to raise_error(/The following disks are attached with non-persistent disk modes/)

      expect(@cpi.has_vm?(@vm_id)).to be(true), "Expected #{@vm_id} to still exist"
      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
    end

    it 'refuses to detach the disk' do
      expect do
        @cpi.detach_disk(@vm_id, @disk_id)
      end.to raise_error(/The following disks are attached with non-persistent disk modes/)

      expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
    end
  end
end
