require 'spec_helper'

describe VSphereCloud::Resources::Nic do
  describe '#create_nic_config_spec' do
    let(:cloud_searcher) { instance_double(VSphereCloud::CloudSearcher) }
    let(:network) do
      instance_double(VSphereCloud::Resources::Network, network_id: network_id, nic_backing: nil)
    end
    let(:network_id) { :fake }

    let(:dvs_index) { {} }
    let(:create_vnic_args) do
      [cloud_searcher, 'fake-v-network-name', network, 'fake_controller_key', dvs_index]
    end

    it 'sets the correct operation in the device config spec' do
      vnic = described_class.create_virtual_nic(*create_vnic_args)
      device_config_spec = VSphereCloud::Resources::VM.create_add_device_spec(vnic)

      expect(device_config_spec.operation).to eq(
        VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
      expect(dvs_index).to eq(network_id => 'fake-v-network-name')
    end

    context 'when the network id is nil' do
      let(:network_id) { nil }

      it "doesn't populate dvs index" do
        expect do
          described_class.create_virtual_nic(*create_vnic_args)
        end.to_not change { dvs_index }
      end
    end

    context 'when the network is nil' do
      let(:network) { nil }

      it 'raises an invalid network error' do
        expect do
          described_class.create_virtual_nic(*create_vnic_args)
        end.to raise_error /Invalid network/
      end
    end
  end
end
