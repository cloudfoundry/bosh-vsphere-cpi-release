require 'spec_helper'

describe VSphereCloud::Resources::PCIPassthrough do
  describe '#create_pci_passthrough' do
    let(:device_id) { 'some-device' }
    let(:vendor_id) { 'some-vendor' }
    it 'creates a PCI Passthrough device' do
      spec = described_class.create_pci_passthrough(vendor_id:, device_id:)
      expect(spec.backing.allowed_device.length).to eq(1)
      expect(spec.backing.allowed_device.first.device_id).to eq('some-device')
      expect(spec.backing.allowed_device.first.vendor_id).to eq('some-vendor')
    end
  end
  describe '#create_vgpu' do
    let(:vgpu) { 'fake-vgpu-name' }
    it 'creates a vgpu' do
      spec = described_class.create_vgpu(vgpu)
      expect(spec.backing.vgpu).to eq(vgpu)
      expect(spec.key).to eq(-1)
    end
    context 'with multiple vgpus' do
      it 'should create a unique key for each vgpu' do
        used_keys = []
        (0..15).each do |i|
          spec = described_class.create_vgpu(vgpu)
          expect(spec.backing.vgpu).to eq(vgpu)
          expect(used_keys.size).to eq(i)
          expect(used_keys.include?(spec.key)).to be_falsey
          used_keys << spec.key
        end
      end
    end
  end

  describe '#create_device_group_vgpus' do
    let(:device_group_name) { 'Nvidia:2@nvidia_h100l-94c%NVLink' }
    let(:group_instance_key) { 0 }
    let(:host) { instance_double('VimSdk::Vim::HostSystem') }
    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
    let(:assignable_hw_manager) { double('AssignableHardwareManager') }

    before do
      allow(cloud_searcher).to receive(:get_properties).with(
        host,
        VimSdk::Vim::HostSystem,
        ['configManager.assignableHardwareManager'],
        ensure_all: true
      ).and_return('configManager.assignableHardwareManager' => assignable_hw_manager)
    end

    context 'when successfully creating vGPU devices' do
      let(:vgpu_profile1) { 'grid_h100-80c' }
      let(:vgpu_profile2) { 'grid_h100-80c' }
      let(:device1_backing) do
        backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo.new
        backing.vgpu = vgpu_profile1
        backing
      end
      let(:device1) do
        device = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        device.backing = device1_backing
        device
      end
      let(:device2_backing) do
        backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo.new
        backing.vgpu = vgpu_profile2
        backing
      end
      let(:device2) do
        device = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        device.backing = device2_backing
        device
      end
      let(:component_device1) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('nvidiaVgpu')
        allow(comp).to receive(:device).and_return(device1)
        comp
      end
      let(:component_device2) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('nvidiaVgpu')
        allow(comp).to receive(:device).and_return(device2)
        comp
      end
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([component_device1, component_device2])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
      end

      it 'creates vGPU devices with correct deviceGroupInfo' do
        devices = described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)

        expect(devices.length).to eq(2)
        devices.each_with_index do |device, index|
          expect(device).to be_a(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough)
          expect(device.backing).to be_a(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo)
          expect(device.backing.vgpu).to eq('grid_h100-80c')
          expect(device.device_group_info).to be_a(VimSdk::Vim::Vm::Device::VirtualDevice::DeviceGroupInfo)
          expect(device.device_group_info.group_instance_key).to eq(group_instance_key)
          expect(device.device_group_info.sequence_id).to eq(index)
          expect(device.key).to be < 0
        end
      end

      it 'creates unique keys for each device' do
        devices = described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)

        keys = devices.map(&:key)
        expect(keys.uniq.length).to eq(keys.length)
      end
    end

    context 'when AssignableHardwareManager is not found' do
      before do
        allow(cloud_searcher).to receive(:get_properties).and_return('configManager.assignableHardwareManager' => nil)
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Failed to get AssignableHardwareManager from host")
      end
    end

    context 'when device group information retrieval fails with SoapError' do
      before do
        error = NameError.new('SoapError: something went wrong')
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_raise(error)
      end

      it 'raises a descriptive error about vSphere version' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Device groups require vSphere 8.0+. The vCenter version may not support device groups, or the SDK version is incompatible.")
      end
    end

    context 'when device group information retrieval fails with MethodNotFound' do
      before do
        error = StandardError.new('MethodNotFound: retrieve_vendor_device_group_info')
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_raise(error)
      end

      it 'raises a descriptive error about vSphere version' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error(/Device groups require vSphere 8.0\+. The method 'retrieve_vendor_device_group_info' is not available/)
      end
    end

    context 'when device group information is nil' do
      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return(nil)
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Failed to retrieve device group information from host")
      end
    end

    context 'when device group is not found on host' do
      let(:other_device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return('Other:1@other-device%Other')
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([other_device_group_info])
      end

      it 'raises an error with device group name' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Device group '#{device_group_name}' not found on host")
      end
    end

    context 'when device group has no component devices' do
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error(/Device group '#{device_group_name}' has no component devices.*configuration issue/)
      end
    end

    context 'when device group has no nvidiaVgpu devices' do
      let(:non_vgpu_component) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('otherType')
        comp
      end
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([non_vgpu_component])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error(/Device group '#{device_group_name}' has no nvidiaVgpu component devices \(found: otherType\).*configuration issue/)
      end
    end

    context 'when component device does not have backing information' do
      let(:invalid_device) { double('InvalidDevice') }
      let(:component_device) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('nvidiaVgpu')
        allow(comp).to receive(:device).and_return(invalid_device)
        comp
      end
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([component_device])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
        allow(invalid_device).to receive(:is_a?).with(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough).and_return(false)
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Component device does not have backing information")
      end
    end

    context 'when component device does not have VmiopBackingInfo' do
      let(:wrong_backing) { double('WrongBacking') }
      let(:device) do
        device = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        device.backing = wrong_backing
        device
      end
      let(:component_device) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('nvidiaVgpu')
        allow(comp).to receive(:device).and_return(device)
        comp
      end
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([component_device])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
        allow(device).to receive(:is_a?).with(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough).and_return(true)
        allow(wrong_backing).to receive(:is_a?).with(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo).and_return(false)
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Component device does not have VmiopBackingInfo")
      end
    end

    context 'when component device does not have vGPU profile' do
      let(:backing) do
        backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo.new
        backing.vgpu = nil
        backing
      end
      let(:device) do
        device = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        device.backing = backing
        device
      end
      let(:component_device) do
        comp = double('ComponentDeviceInfo')
        allow(comp).to receive(:type).and_return('nvidiaVgpu')
        allow(comp).to receive(:device).and_return(device)
        comp
      end
      let(:device_group_info) do
        info = double('VendorDeviceGroupInfo')
        allow(info).to receive(:device_group_name).and_return(device_group_name)
        allow(info).to receive(:component_device_info).and_return([component_device])
        info
      end

      before do
        allow(assignable_hw_manager).to receive(:retrieve_vendor_device_group_info).and_return([device_group_info])
        allow(device).to receive(:is_a?).with(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough).and_return(true)
        allow(backing).to receive(:is_a?).with(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo).and_return(true)
      end

      it 'raises an error' do
        expect {
          described_class.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        }.to raise_error("Component device does not have vGPU profile")
      end
    end
  end
end
