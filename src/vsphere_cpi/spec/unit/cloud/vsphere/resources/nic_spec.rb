require 'spec_helper'

module VSphereCloud::Resources
  describe Nic do
    describe '#create_nic_config_spec' do
      subject(:vsphere_cloud) { Cloud.new(config) }

      let(:config) { { fake: 'config' } }
      let(:dvs_index) { {} }
      let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
      context 'using a distributed switch' do
        let(:v_network_name) { 'fake_network1' }
        let(:network) { instance_double('VimSdk::Vim::Dvs::DistributedVirtualPortgroup', class: VimSdk::Vim::Dvs::DistributedVirtualPortgroup) }
        let(:dvs_index) { {} }
        let(:switch) { double() }
        let(:portgroup_properties) { { 'config.distributedVirtualSwitch' => switch, 'config.key' => 'fake_portgroup_key' } }

        before do
          allow(cloud_searcher).to receive(:get_properties).with(network, VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
              ['config.key', 'config.distributedVirtualSwitch'],
              ensure_all: true).and_return(portgroup_properties)

          allow(cloud_searcher).to receive(:get_property).with(switch, VimSdk::Vim::DistributedVirtualSwitch,
              'uuid', ensure_all: true).and_return('fake_switch_uuid')
        end

        it 'sets correct port in device config spec' do
          virtual_nic =  Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          port = device_config_spec.device.backing.port
          expect(port.switch_uuid).to eq('fake_switch_uuid')
          expect(port.portgroup_key).to eq('fake_portgroup_key')
        end

        it 'sets correct backing in device config spec' do
          virtual_nic =  Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          backing = device_config_spec.device.backing
          expect(backing).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo)
        end

        it 'adds record to dvs_index for portgroup_key' do
          Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)

          expect(dvs_index['fake_portgroup_key']).to eq('fake_network1')
        end

        it 'sets correct device in device config spec' do
          virtual_nic =  Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          device = device_config_spec.device
          expect(device.key).to eq(-1)
          expect(device.controller_key).to eq('fake_controller_key')
        end

        it 'sets correct operation in device config spec' do
          virtual_nic = Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          expect(device_config_spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
        end
      end

      context 'using a standard switch' do
        let(:v_network_name) { 'fake_network1' }
        let(:network) { double(name: v_network_name) }
        let(:dvs_index) { {} }

        it 'sets correct backing in device config spec' do
          virtual_nic = Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)
          backing = device_config_spec.device.backing
          expect(backing).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo)
          expect(backing.device_name).to eq(v_network_name)
        end

        it 'sets correct device in device config spec' do
          virtual_nic = Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)
          device = device_config_spec.device
          expect(device.key).to eq(-1)
          expect(device.controller_key).to eq('fake_controller_key')
        end

        it 'sets correct operation in device config spec' do
          virtual_nic = Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          expect(device_config_spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
        end
      end
    end
  end
end
