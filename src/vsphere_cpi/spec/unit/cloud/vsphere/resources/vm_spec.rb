require 'spec_helper'
require 'timecop'

describe VSphereCloud::Resources::VM do
  subject(:vm) { described_class.new('vm-cid', vm_mob, client, logger) }
  let(:vm_mob) { instance_double('VimSdk::Vim::VirtualMachine') }
  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:logger) { double(:logger, debug: nil, info: nil) }

  let(:powered_off_state) { VimSdk::Vim::VirtualMachine::PowerState::POWERED_OFF }
  let(:powered_on_state) { VimSdk::Vim::VirtualMachine::PowerState::POWERED_ON }

  before do
    allow(cloud_searcher).to receive(:get_properties).with(
      vm_mob,
      VimSdk::Vim::VirtualMachine,
      ['runtime.powerState', 'runtime.question', 'config.hardware.device', 'name', 'runtime', 'resourcePool'],
      ensure: ['config.hardware.device', 'runtime']
    ).and_return(vm_properties)
  end

  let(:vm_properties) { {'runtime' => double(:runtime, host: 'vm-host')} }

  describe '#accessible_datastore_names' do
    it 'returns accessible datastores' do
      datastore_mob = instance_double('VimSdk::Vim::Datastore')
      host_properties = {'datastore' => [datastore_mob]}
      allow(cloud_searcher).to receive(:get_properties).with(
        'vm-host',
        VimSdk::Vim::HostSystem,
        ['datastore', 'parent'],
        ensure_all: true,
      ).and_return(host_properties)
      allow(cloud_searcher).to receive(:get_properties).with(
        datastore_mob,
        VimSdk::Vim::Datastore,
        'name',
        ensure_all: true,
      ).and_return({ 'name' => 'datastore-name' })

      expect(vm.accessible_datastore_names).to eq(['datastore-name'])
    end
  end

  describe '#fix_device_unit_numbers' do
    let(:vm_properties) { { 'config.hardware.device' => vm_devices } }
    let(:vm_devices) do
      vm_devices = []
      4.times do |i|
        vm_devices << double(:device, controller_key: 7, unit_number: i)
      end
      vm_devices
    end

    let(:device_changes) { [double(:device_change, device: device)] }
    let(:device) { VimSdk::Vim::Vm::Device::VirtualDisk.new(controller_key: 7) }

    it 'sets device unit number to available unit number' do
      vm.fix_device_unit_numbers(device_changes)
      expect(device.unit_number).to eq(4)
    end

    context 'when devices use all available unit numbers' do
      let(:vm_devices) do
        vm_devices = []
        16.times do |i|
          vm_devices << double(:device, controller_key: 7, unit_number: i)
        end
        vm_devices
      end

      it 'raises an error' do
        expect {
          vm.fix_device_unit_numbers(device_changes)
        }.to raise_error /No available unit numbers/
      end
    end
  end

  describe '#shutdown' do
    let(:vm_properties) { { 'config.hardware.device' => vm_devices } }
    let(:vm_devices) { [] }

    before do
      allow(vm).to receive(:persistent_disk_device_keys_from_vapp_config).and_return([])
    end

    it 'sends shutdown signal' do
      allow(cloud_searcher).to receive(:get_property).
        with(vm_mob, VimSdk::Vim::VirtualMachine, 'runtime.powerState').
        and_return(powered_off_state)

      expect(vm_mob).to receive(:shutdown_guest)
      vm.shutdown
    end

    it 'waits until vm is powered off' do
      expect(cloud_searcher).to receive(:get_property).
        with(vm_mob, VimSdk::Vim::VirtualMachine, 'runtime.powerState').
        and_return(powered_on_state, powered_on_state, powered_off_state).
        exactly(3).times
      expect(vm).to receive(:sleep).with(1.0).exactly(2).times

      expect(vm_mob).to receive(:shutdown_guest)
      vm.shutdown
    end

    context 'when waiting for shutdown exceeds 60 seconds' do
      it 'powers off vm' do
        started_time = Time.now
        passed_time = started_time + 61
        Timecop.freeze(started_time)

        expect(cloud_searcher).to receive(:get_property).with(
          vm_mob,
          VimSdk::Vim::VirtualMachine,
          'runtime.powerState'
        ) do
          Timecop.freeze(passed_time)
        end.and_return(powered_on_state)

        expect(vm_mob).to receive(:shutdown_guest)
        expect(client).to receive(:power_off_vm).with(vm_mob)
        vm.shutdown
      end
    end

    context 'when shutting down vm raises an error' do
      before do
        allow(vm_mob).to receive(:shutdown_guest).and_raise RuntimeError
      end

      it 'ignores the error and waits until vm is powered off' do
        expect(cloud_searcher).to receive(:get_property).
          with(vm_mob, VimSdk::Vim::VirtualMachine, 'runtime.powerState').
          and_return(powered_off_state)

        expect {
          vm.shutdown
        }.to_not raise_error
      end
    end

    context 'when a disk is attached with a non-persistent mode' do
      let(:persistent_disk_with_non_persistent_mode) do
        disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
        disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
        disk.backing.file_name = '[datastore] fake-disk-path/fake-file_name.vmdk'
        disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
        disk.key = 9002
        disk
      end
      let(:vm_devices) { [persistent_disk_with_non_persistent_mode] }

      before do
        allow(vm).to receive(:persistent_disk_device_keys_from_vapp_config).and_return([
          persistent_disk_with_non_persistent_mode.key
        ])
      end

      it 'throws an exception and does not send power off' do
        expect(vm_mob).to_not receive(:shutdown_guest)
        expect do
          vm.shutdown
        end.to raise_error("The following disks are attached with non-persistent disk modes: [ [datastore] fake-disk-path/fake-file_name.vmdk ]. Please change the disk modes to 'independent persistent' before attempting to power off the VM to avoid data loss.")
      end
    end

  end

  describe '#power_off' do
    let(:vm_properties) { { 'config.hardware.device' => vm_devices } }
    let(:vm_devices) { [] }

    before do
      allow(cloud_searcher).to receive(:get_property).with(
        vm_mob,
        VimSdk::Vim::VirtualMachine,
        ['runtime.powerState', 'runtime.question', 'config.hardware.device', 'name', 'runtime', 'resourcePool'],
        ensure: ['config.hardware.device', 'runtime']
      ).and_return({'runtime.question' => nil})
      allow(vm).to receive(:persistent_disk_device_keys_from_vapp_config).and_return([])
    end

    context 'when vsphere asks question' do
      before do
        choice_info = {2 => double(:second_choice, label: 'YES', key: 'yes')}
        choice = double(:choices, choice_info: choice_info, default_index: 2)
        question = double(:question, choice: choice, id: 'question-id', text: 'question?')
        allow(cloud_searcher).to receive(:get_properties).with(
          vm_mob,
          VimSdk::Vim::VirtualMachine,
          ['runtime.powerState', 'runtime.question', 'config.hardware.device', 'name', 'runtime', 'resourcePool'],
          ensure: ['config.hardware.device', 'runtime']
        ).and_return({'runtime.question' => question, 'config.hardware.device' => vm_devices})
        allow(cloud_searcher).to receive(:get_property).with(
          vm_mob,
          VimSdk::Vim::VirtualMachine,
          'runtime.powerState',
        ).and_return(powered_off_state)
      end

      it 'answers the question' do
        expect(client).to receive(:answer_vm).with(vm_mob, 'question-id', 'yes')
        vm.power_off
      end
    end

    context 'when current state is not powered off' do
      it 'sends power off' do
        expect(client).to receive(:power_off_vm).with(vm_mob)
        vm.power_off
      end
    end

    context 'when current state is powered off' do
      before do
        allow(cloud_searcher).to receive(:get_properties).with(
          vm_mob,
          VimSdk::Vim::VirtualMachine,
          ['runtime.powerState', 'runtime.question', 'config.hardware.device', 'name', 'runtime', 'resourcePool'],
          ensure: ['config.hardware.device', 'runtime']
        ).and_return({'runtime.powerState' => powered_off_state, 'config.hardware.device' => vm_devices})
      end

      it 'does not send power off' do
        expect(client).to_not receive(:power_off_vm).with(vm_mob)
        vm.power_off
      end
    end

    context 'when a disk is attached with a non-persistent mode' do
      let(:persistent_disk_with_non_persistent_mode) do
        disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
        disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
        disk.backing.file_name = '[datastore] fake-disk-path/fake-file_name.vmdk'
        disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
        disk.key = 9002
        disk
      end
      let(:vm_devices) { [persistent_disk_with_non_persistent_mode] }

      before do
        allow(vm).to receive(:persistent_disk_device_keys_from_vapp_config).and_return([
          persistent_disk_with_non_persistent_mode.key
        ])
      end

      it 'throws an exception and does not send power off' do
        expect(client).to_not receive(:power_off_vm).with(vm_mob)
        expect do
          vm.power_off
        end.to raise_error("The following disks are attached with non-persistent disk modes: [ [datastore] fake-disk-path/fake-file_name.vmdk ]. Please change the disk modes to 'independent persistent' before attempting to power off the VM to avoid data loss.")
      end
    end
  end

  describe '#attach_disk' do
    let(:disk) { VSphereCloud::Resources::PersistentDisk.new('fake-disk-cid', 1024, datastore, 'fake-folder') }
    let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', name: 'fake-datastore')}
    let(:devices) { [disk] }

    it 'updates persistent disk' do
      allow(vm).to receive(:fix_device_unit_numbers)
      allow(vm).to receive(:devices).and_return(devices)
      allow(vm).to receive(:system_disk).and_return(disk)
      allow(disk).to receive(:controller_key).and_return('fake-controller-key')
      allow(datastore).to receive(:mob).and_return('fake-datastore')

      expect(client).to receive(:reconfig_vm) do |reconfig_vm, vm_config|
        expect(reconfig_vm).to eq(vm_mob)
        expect(vm_config.device_change.size).to eq(1)
        disk_spec = vm_config.device_change.first
        expect(disk_spec.device.capacity_in_kb).to eq(1024 * 1024)
        expect(disk_spec.device.backing.datastore).to eq(datastore.name)
        expect(disk_spec.device.controller_key).to eq('fake-controller-key')
      end
      allow(client).to receive(:add_persistent_disk_property_to_vm)
      vm.attach_disk(disk)
    end
  end

  describe '#detach_disks' do
    let(:disk0) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.file_name = '[datastore] fake-disk-path/fake-file_name.vmdk'
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT
      disk.key = 'first-disk-key'
      disk
    end
    let(:disk1) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.file_name = '[datastore] fake-disk-path/fake-file_name2.vmdk'
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT
      disk.key = 'second-disk-key'
      disk
    end
    let(:vm_devices) { [disk0, disk1]}
    let(:vm_properties) { { 'config.hardware.device' => vm_devices } }
    let(:disk0_property) do
      instance_double(
        'VimSdk::Vim::VApp::PropertyInfo',
        key: 'first-disk-key',
        category: 'BOSH Persistent Disks',
        value: '[datastore] fake-disk-path/fake-file_name.vmdk'
      )
    end
    let(:disk1_property) do
      instance_double('VimSdk::Vim::VApp::PropertyInfo',
        key: 'first-disk-key',
        category: 'BOSH Persistent Disks',
        value: '[datastore] fake-disk-path/fake-file_name2.vmdk'
      )
    end

    let(:datacenter) { instance_double('VimSdk::Vim::Datacenter')}

    before {
      allow(vm).to receive(:has_persistent_disk_property_mismatch?).and_return(false)
      allow(vm).to receive(:datacenter).and_return(datacenter)
      allow(vm_mob).to receive_message_chain('config.v_app_config.property').and_return([
        disk0_property,
        disk1_property
      ])
    }

    it 'detaches the given virtual disks' do
      expect(client).to receive(:reconfig_vm) do |mob, spec|
        expect(mob).to equal(vm_mob)
        expect(spec.device_change.first.device).to eq(disk0)
        expect(spec.device_change.first.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::REMOVE)
        expect(spec.device_change[1].device).to eq(disk1)
        expect(spec.device_change[1].operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::REMOVE)
      end
      expect(client).to_not receive(:move_disk)
      expect(client).to receive(:delete_persistent_disk_property_from_vm).with(vm, 'first-disk-key')
      expect(client).to receive(:delete_persistent_disk_property_from_vm).with(vm, 'second-disk-key')
      vm.detach_disks([disk0, disk1])
    end

    context 'when a disk has a property mismatch' do
      let(:disk0_property) do
        instance_double(
          'VimSdk::Vim::VApp::PropertyInfo',
          key: 'first-disk-key',
          category: 'BOSH Persistent Disks',
          value: '[old-datastore] old-disk-path/old-file_name.vmdk'
        )
      end
      before do
        allow(vm).to receive(:has_persistent_disk_property_mismatch?).and_return(true)
        allow(vm).to receive(:get_old_disk_filepath).and_return('[old-datastore] old-disk-path/old-file-name.vmdk')
        allow(client).to receive(:disk_path_exists?).and_return(false)
      end
      it 'renames the disk to its original name' do
        expect(client).to receive(:reconfig_vm) do |mob, spec|
          expect(mob).to equal(vm_mob)
          expect(spec.device_change.first.device).to eq(disk0)
          expect(spec.device_change.first.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::REMOVE)
        end
        expect(client).to receive(:move_disk).with(
          datacenter,
          '[datastore] fake-disk-path/fake-file_name.vmdk',
          datacenter,
          '[datastore] old-disk-path/old-file-name.vmdk'
        )
        expect(client).to receive(:delete_persistent_disk_property_from_vm).with(vm, 'first-disk-key')
        vm.detach_disks([disk0])
      end

      context 'when original disk still exists' do
        before do
          allow(client).to receive(:disk_path_exists?).and_return(true)
        end
        it 'does not try to move the disk to its original name' do
          expect(client).to receive(:reconfig_vm) do |mob, spec|
            expect(mob).to equal(vm_mob)
            expect(spec.device_change.first.device).to eq(disk0)
            expect(spec.device_change.first.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::REMOVE)
          end
          expect(client).to_not receive(:move_disk)
          expect(client).to receive(:delete_persistent_disk_property_from_vm).with(vm, 'first-disk-key')
          vm.detach_disks([disk0])
        end
      end
    end
  end

  describe '#disk_path' do

    let(:disk) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.file_name = '[datastore] fake-disk-path/fake-file_name.vmdk'
      disk.key = 'first-disk-key'
      disk
    end

    before do
      allow(vm).to receive(:disk_by_cid).and_return(disk)
    end

    it 'returns the file name of the virtual disk' do
      disk_path = vm.disk_path_by_cid('fake-file_name')
      expect(disk_path).to eq('[datastore] fake-disk-path/fake-file_name.vmdk')
    end

    context 'when disk_cid does not exist' do
      before do
        allow(vm).to receive(:disk_by_cid).and_return(nil)
      end
      it 'returns nil' do
        disk_path = vm.disk_path_by_cid('other-file_name')
        expect(disk_path).to be_nil
      end
    end
  end

  describe '#ephemeral_disk and #persistent_disks' do
    let(:persistent_disk) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT
      disk.key = 9001
      disk
    end
    let(:persistent_disk_with_non_persistent_mode) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
      disk.key = 9002
      disk
    end
    let(:persistent_disk_with_non_independent_mode) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
      disk.key = 9003
      disk
    end
    let(:ephemeral_disk) do
      disk = VimSdk::Vim::Vm::Device::VirtualDisk.new
      disk.backing = VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo.new
      disk.backing.file_name = "#{VSphereCloud::Resources::EphemeralDisk::DISK_NAME}.vmdk"
      disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
      disk.key = 7777
      disk
    end
    let(:vm_devices) do
      vm_devices = []
      vm_devices << persistent_disk
      vm_devices << persistent_disk_with_non_independent_mode
      vm_devices << persistent_disk_with_non_persistent_mode
      vm_devices << ephemeral_disk
      vm_devices
    end
    let(:vm_properties) { { 'config.hardware.device' => vm_devices } }

    before do
      allow(vm).to receive(:persistent_disk_device_keys_from_vapp_config).and_return([
        persistent_disk_with_non_persistent_mode.key,
        persistent_disk_with_non_independent_mode.key
      ])
    end

    it 'returns all persistent disks' do
      expect(vm.persistent_disks).to include(
        persistent_disk,
        persistent_disk_with_non_persistent_mode,
        persistent_disk_with_non_independent_mode
      )
      expect(vm.persistent_disks).to_not include(
        ephemeral_disk
      )
    end

    it 'returns the ephemeral disk' do
      expect(vm.ephemeral_disk).to eq(ephemeral_disk)
    end
  end

  describe '#to_s' do
    it 'show relevant info' do
      expect(subject.to_s).to eq("(#{subject.class.name} (cid=\"vm-cid\"))")
    end
  end
end
