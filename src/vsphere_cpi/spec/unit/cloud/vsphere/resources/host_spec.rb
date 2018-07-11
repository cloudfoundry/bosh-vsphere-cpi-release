require 'spec_helper'
require 'rspec/its'

RSpec::Matchers.define :have_same_GPU_as do |gpu_list|
  match do |actual|
    actual = actual.map do |dev|
      dev.id
    end
    gpu_list = gpu_list.map do |dev|
      dev.id
    end
    actual.sort! == gpu_list.sort!
  end
end

def create_fake_pci_device
  fake_device = VimSdk::Vim::Host::PciDevice.new
  fake_device.bus = 0b1010
  fake_device.class_id = 1024
  fake_device.device_id	= 4096 + SecureRandom.random_number(100)
  fake_device.device_name = (0...8).map { (65 + rand(26)).chr }.join
  fake_device.id = (0...5).map { (97 + rand(26)).chr }.join
  fake_device
end

def fake_direct_graphics_info(id)
  fake_graphics_info = VimSdk::Vim::Host::GraphicsInfo.new
  fake_graphics_info.pci_id = id
  fake_graphics_info.vendor_name = 'nvidia'
  fake_graphics_info.graphics_type = 'direct'
  fake_graphics_info.device_name = 'GT100'
  fake_graphics_info.memory_size_in_kb = 1000
  fake_graphics_info.vm = []
  fake_graphics_info
end

def fake_shared_graphics_info(id)
  fake_graphics_info = VimSdk::Vim::Host::GraphicsInfo.new
  fake_graphics_info.pci_id = id
  fake_graphics_info.vendor_name = 'nvidia'
  fake_graphics_info.graphics_type = 'shared'
  fake_graphics_info.device_name = 'GT97'
  fake_graphics_info.memory_size_in_kb = 1000
  fake_graphics_info
end

describe VSphereCloud::Resources::Host do
  subject do
    described_class.new('foo_host', mob, [1,2,3], [1,2,3], runtime)
  end

  let(:runtime) do
    instance_double('VimSdk::Vim::Host::RuntimeInfo', :in_maintenance_mode => host_maintenance_mode,
      :connection_state => host_connection_state, :power_state => host_power_state)
  end

  let(:host_power_state) do
    'poweredOn'
  end

  let(:host_connection_state) do
    'connected'
  end

  let(:host_maintenance_mode) do
    false
  end

  let(:mob) do
    instance_double('VimSdk::Vim::HostSystem', to_s: 'mob_as_string')
  end

  describe '#mob' do
    it('returns the mob') { expect(subject.mob).to eq(mob) }
  end

  describe '#name' do
    it('returns the name') { expect(subject.name).to eq('foo_host') }
  end

  describe '#pci_devices' do
    it 'returns the list of pci devices' do
      expect(subject.pci_devices).to eq([1,2,3])
    end
  end

  describe '#graphics_info' do
    it 'returns the list of graphics devices' do
      expect(subject.graphics_info).to eq([1,2,3])
    end
  end

  describe '#inspect' do
    it 'returns the printable form' do
      expect(subject.inspect).to eq("<Host: #{mob} / foo_host>")
    end
  end

  describe '#to_s' do
    it 'show relevant info' do
      expect(subject.to_s).to eq(%Q[(#{described_class.name} (name="foo_host", mob="mob_as_string"))])
    end
  end

  describe '#eql' do
    let(:other_1) { described_class.new('foo_host_2', mob, [1,2,3], [1,2,3], runtime)}
    let(:other_2) { described_class.new('foo_host', mob, [1,2,3], [1,2,3], runtime)}
    it 'returns equality of oher objects' do
      expect(subject.eql?(other_1)).to be(false)
      expect(subject.eql?(other_2)).to be(true)
    end
  end

  describe '#hash' do
    it 'returns hash of the object' do
      expect(subject.hash).to eql('foo_host'.hash)
    end
  end

  describe '#raw_available_memory' do
    before do
      allow(subject.mob).to receive_message_chain(:hardware, :memory_size).and_return(1024*1024*1025)
      allow(subject.mob).to receive_message_chain(:summary, :quick_stats, :overall_memory_usage).and_return(1024*1024*1)
    end
    it 'return raw available memory with the host in MB' do
      expect(subject.raw_available_memory).to be(1024)
    end
  end

  describe '#active?' do
    context 'when host is in maintenance mode' do
      let(:host_maintenance_mode) do
        true
      end
      it 'returns false' do
        expect(subject.active?).to be(false)
      end
    end
    context 'when host is not connected' do
      let(:host_connection_state) do
        'disconnected'
      end
      it 'returns false' do
        expect(subject.active?).to be(false)
      end
    end
    context 'when host is not powered on or on stand by' do
      let(:host_power_state) do
        'standBy'
      end
      it 'returns false' do
        expect(subject.active?).to be(false)
      end
    end
    context 'when host is not powered on and not connected' do
      let(:host_power_state) do
        'standBy'
      end
      let(:host_connection_state) do
        'disconnected'
      end
      it 'returns false' do
        expect(subject.active?).to be(false)
      end
    end
  end

  context '#available_gpus' do
    let(:fake_pci_devices) do
      fake_array = []
      10.times do
        fake_array << create_fake_pci_device
      end
      fake_array
    end

    let(:mix_graphics_info) do
      @graphic_devices = fake_pci_devices.sample(fake_pci_devices.length/2)
      graphics_info = @graphic_devices.map do |device|
        fake_direct_graphics_info(device.id)
      end
      graphics_info << fake_shared_graphics_info("woozydozzy")
      graphics_info << fake_shared_graphics_info("swankplank")
    end

    let(:mix_graphics_info_with_vm) do
      @graphic_devices = fake_pci_devices.sample(fake_pci_devices.length/2)
      graphics_info = @graphic_devices.map do |device|
        fake_g = fake_direct_graphics_info(device.id)
        fake_g.vm = ['dummy_vm']
        fake_g
      end
      graphics_info << fake_shared_graphics_info("woozydozzy")
      graphics_info << fake_shared_graphics_info("swankplank")
    end

    let(:mix_graphics_info_with_only_one_available) do
      @graphic_devices = fake_pci_devices.sample(fake_pci_devices.length/2)
      graphics_info = @graphic_devices.map do |device|
        fake_g = fake_direct_graphics_info(device.id)
        fake_g.vm = ['dummy_vm']
        fake_g
      end
      graphics_info.last.vm = []
      graphics_info << fake_shared_graphics_info("woozydozzy")
      graphics_info << fake_shared_graphics_info("swankplank")
    end

    let(:shared_graphics_info) do
      @graphic_devices = fake_pci_devices.sample(fake_pci_devices.length/2)
      @graphic_devices.map do |device|
        fake_shared_graphics_info(device.id)
      end
    end
    let(:empty_graphics_info) do
      []
    end
    let(:vm_list) do
      []
    end
    context 'when there are no gpu devices on host' do
      before do
        allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
        allow(subject).to receive(:graphics_info).and_return(empty_graphics_info)
        allow(mob).to receive(:vm).and_return(vm_list)
      end
      it 'returns empty graphics devices list' do
        got_graphics = subject.available_gpus
        expect(got_graphics).to eql([])
      end
    end
    context 'when there are no vms using any graphics and graphics are a mix of shared and direct' do
      before do
        allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
        allow(subject).to receive(:graphics_info).and_return(mix_graphics_info)
        allow(mob).to receive(:vm).and_return(vm_list)
      end
      it 'returns filtered graphics info list' do
        got_graphics = subject.available_gpus
        expect(got_graphics).to have_same_GPU_as(@graphic_devices)
      end
    end
    context 'when there are no vms using any graphics and graphics are only shared mode' do
      before do
        allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
        allow(subject).to receive(:graphics_info).and_return(shared_graphics_info)
        allow(mob).to receive(:vm).and_return(vm_list)
      end
      it 'returns empty graphics info list' do
        got_graphics = subject.available_gpus
        expect(got_graphics).to eql([])
      end
    end
    context 'when there is a vm list with each graphics device and graphics device are a mix of shared and direct' do
      before do
        allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
        allow(subject).to receive(:graphics_info).and_return(mix_graphics_info_with_vm)
        allow(mob).to receive(:vm).and_return(vm_list)
      end
      it 'returns empty graphics info list' do
        got_graphics = subject.available_gpus
        expect(got_graphics).to eql([])
      end
    end
    context 'when there is a vm list with each graphics device but one(direct mode) and graphics device are a mix of shared and direct' do
      before do
        allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
        allow(subject).to receive(:graphics_info).and_return(mix_graphics_info_with_only_one_available)
        allow(mob).to receive(:vm).and_return(vm_list)
      end
      it 'returns graphics info list with one available gpu' do
        got_graphics = subject.available_gpus
        expect(got_graphics.size).to be(1)
      end
    end
    context 'when graphics device are a mix of shared and direct and there is only one graphics device with empty vm list' do
      let(:vm_1) { instance_double('VimSdk::Vim::VirtualMachine') }
      let(:vm_2) { instance_double('VimSdk::Vim::VirtualMachine') }
      let(:device_1) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_1) }
      let(:device_2) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_2) }
      let(:device_3) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_3) }
      let(:vm_list) do
        [vm_1, vm_2]
      end
      context 'when host has vms that has one vm , which is attached to this available gpu ((according to graphics_info))' do
        let(:backing_1) do
          backing_1 = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo.new
          backing_1.device_id = '1021'
          backing_1.id = @graphic_devices.last.id
          backing_1.system_id = '1021'
          backing_1.vendor_id = 1021
          backing_1
        end
        let(:backing_2) do
          backing_2 = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo.new
          backing_2.device_id = '1021'
          backing_2.id = 'diff'
          backing_2.system_id = '1021'
          backing_2.vendor_id = 1021
          backing_2
        end
        let(:backing_3) do
          backing_3 = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::PipeBackingInfo.new
          backing_3.pipe_name = '1021'
          backing_3
        end
        before do
          allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
          allow(subject).to receive(:graphics_info).and_return(mix_graphics_info_with_only_one_available)
          allow(vm_1).to receive_message_chain(:config, :hardware, :device).and_return([device_1, device_2])
          allow(vm_2).to receive_message_chain(:config, :hardware, :device).and_return([device_3])
          allow(mob).to receive(:vm).and_return(vm_list)
        end
        it 'returns empty graphics info list' do
          got_graphics = subject.available_gpus
          expect(got_graphics.size).to be(0)
        end
      end
      context 'when host has vms that has no vm with gpu device' do
        let(:device_1) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_3) }
        let(:device_2) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_3) }
        let(:device_3) {instance_double('VimSdk::Vim::Vm::Device::VirtualDevice', :backing => backing_3) }
        let(:backing_3) do
          backing_3 = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::PipeBackingInfo.new
          backing_3.pipe_name = '1021'
          backing_3
        end
        before do
          allow(subject).to receive(:pci_devices).and_return(fake_pci_devices)
          allow(subject).to receive(:graphics_info).and_return(mix_graphics_info_with_only_one_available)
          allow(vm_1).to receive_message_chain(:config, :hardware, :device).and_return([device_1, device_2])
          allow(vm_2).to receive_message_chain(:config, :hardware, :device).and_return([device_3])
          allow(mob).to receive(:vm).and_return(vm_list)
        end
        it 'returns graphics info list with one gpu' do
          got_graphics = subject.available_gpus
          expect(got_graphics.size).to be(1)
        end
      end
    end
  end
end
