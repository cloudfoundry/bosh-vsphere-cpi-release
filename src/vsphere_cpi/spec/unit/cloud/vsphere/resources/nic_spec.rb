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
        let(:network) { instance_double(VSphereCloud::Resources::Network, nic_backing: 'fake-backing') }

        it 'sets correct operation in device config spec' do
          virtual_nic = Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
          device_config_spec = VM.create_add_device_spec(virtual_nic)

          expect(device_config_spec.operation).to eq(VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD)
        end

        context 'when Passed network is nil' do
          let(:network) { nil }
          it 'raises Invalid network error' do
            expect do
              Nic.create_virtual_nic(cloud_searcher, v_network_name, network, 'fake_controller_key', dvs_index)
              end.to raise_error StandardError, /Invalid network/
          end
        end
      end
    end
  end
end
