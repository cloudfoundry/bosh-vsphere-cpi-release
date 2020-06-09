require 'spec_helper'
require 'rspec/its'

describe VSphereCloud::Resources::Network do
  subject do
    described_class.new('foo_net', mob, client, )
  end

  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:dvs_index) { {} }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:vim_network_name) { 'fake-network' }
  let(:mob) do
    instance_double('VimSdk::Vim::Network', to_s: 'mob_as_string', name: vim_network_name)
  end

  describe '#vim_name' do
    it 'should return network with vim name as fake-network' do
      expect(subject.vim_name).to eq(vim_network_name)
    end
  end

  describe '#nic_backing' do
    it 'returns backing of type plain NetworkBackingInfo ' do
      backing_info = subject.nic_backing(dvs_index)
      expect(backing_info).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo)
      expect(backing_info.device_name).to be(vim_network_name)
    end
  end

  describe '#self.make_network_resource' do
    before(:each) do
      allow(mob).to receive(:name).and_return(vim_network_name)
    end
    let(:mob) do
      VimSdk::Vim::Network.new(name: vim_network_name)
    end

    it 'returns standard network instance if mob is a standard network' do
      network = VSphereCloud::Resources::Network.make_network_resource('foo_net', mob, client)
      expect(network).to be_a(VSphereCloud::Resources::Network)
    end

    context 'when network mob is of opaque network type' do
      let(:mob) do
        VimSdk::Vim::OpaqueNetwork.new(name: vim_network_name)
      end

      it 'returns opaque network instance if mob is a opaque network' do
        network = VSphereCloud::Resources::Network.make_network_resource('foo_net', mob, client)
        expect(network).to be_a(VSphereCloud::Resources::OpaqueNetwork)
      end
    end

    context 'when network mob is of DVPG type' do
      before(:each) do
        allow(mob).to receive(:config).and_return(mob_config)
      end
      let(:mob) do
        VimSdk::Vim::Dvs::DistributedVirtualPortgroup.new(name: vim_network_name, config: mob_config)
      end
      let(:mob_config) do
        double(:mob_config,
               backing_type: backing_type,
               logical_switch_uuid: 'fake-ls-uuid')
      end

      context 'when DVPG is standard type' do
        let(:backing_type) { 'standard' }

        it 'returns standard DVPG instance if mob is a standard network' do
          network = VSphereCloud::Resources::Network.make_network_resource('foo_net', mob, client)
          expect(network).to be_a(VSphereCloud::Resources::DistributedVirtualPortGroupNetwork)
        end
      end

      context 'when DVPG is standard type and does not respond to backing type' do
        let(:mob_config) { double(:mob_config) }

        it 'returns standard DVPG instance if mob is a standard network' do
          network = VSphereCloud::Resources::Network.make_network_resource('foo_net', mob, client)
          expect(network).to be_a(VSphereCloud::Resources::DistributedVirtualPortGroupNetwork)
        end
      end

      context 'when DVPG is NSXT type' do
        let(:backing_type) { 'nsx' }

        it 'returns standard network instance if mob is a standard network' do
          network = VSphereCloud::Resources::Network.make_network_resource('foo_net', mob, client)
          expect(network).to be_a(VSphereCloud::Resources::DistributedVirtualPortGroupNSXTNetwork)
        end
      end
    end
  end
end


describe VSphereCloud::Resources::OpaqueNetwork do
  subject do
    described_class.new('foo_net', mob, client, )
  end

  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:dvs_index) { {} }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:vim_network_name) { 'fake-network' }
  let(:mob) do
    instance_double('VimSdk::Vim::OpaqueNetwork', to_s: 'mob_as_string', name: vim_network_name, summary: mob_summary)
  end
  let(:mob_summary) do
    instance_double('VimSdk::Vim::OpaqueNetwork::Summary', opaque_network_id: 'fake-id', opaque_network_type: 'fake-opaque-type')
  end

  describe '#nic_backing' do
    it 'returns backing of type OpaqueNetworkBackingInfo ' do
      backing_info = subject.nic_backing(dvs_index)
      expect(backing_info).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
      expect(backing_info.opaque_network_id).to eq(mob_summary.opaque_network_id)
      expect(dvs_index[backing_info.opaque_network_id]).to eq('foo_net')
    end
  end
end


describe VSphereCloud::Resources::DistributedVirtualPortGroupNetwork do
  subject do
    described_class.new('foo_net', mob, client, )
  end

  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:dvs_index) { {} }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:vim_network_name) { 'fake-network' }
  let(:mob) do
    instance_double('VimSdk::Vim::Dvs::DistributedVirtualPortgroup',
                    to_s: 'mob_as_string',
                    name: vim_network_name,
                    config: mob_config)
  end
  let(:mob_config) { nil }

  describe '#nic_backing' do
    context 'when network is of type standard dvpg' do
      let(:mob_config) do
        double(:mob_config, backing_type: 'standard')
      end
      let(:dvpg_key) { 'fake-dvpg-key' }
      let(:dvpg_dvs) { 'fake-dvpg-dvs' }
      let(:dvpg_dvs_uuid) { 'fake-dvpg-dvs-uuid' }

      it 'returns backing of type DVPG' do
        expect(cloud_searcher).to receive(:get_properties).with(mob, any_args).and_return({
            'config.key' => dvpg_key,
            'config.distributedVirtualSwitch' => dvpg_dvs,
        }).once
        expect(cloud_searcher).to receive(:get_property)
          .with(dvpg_dvs, any_args).and_return(dvpg_dvs_uuid).once
        backing_info = subject.nic_backing(dvs_index)
        expect(backing_info).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo)
        expect(backing_info.port.switch_uuid).to eq(dvpg_dvs_uuid)
        expect(backing_info.port.portgroup_key).to eq(dvpg_key)
        expect(dvs_index[backing_info.port.portgroup_key]).to eq('foo_net')
      end
    end
  end
end


describe VSphereCloud::Resources::DistributedVirtualPortGroupNSXTNetwork do
  subject do
    described_class.new('foo_net', mob, client, )
  end

  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:dvs_index) { {} }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:vim_network_name) { 'fake-network' }
  let(:mob) do
    instance_double('VimSdk::Vim::Dvs::DistributedVirtualPortgroup',
                    to_s: 'mob_as_string',
                    name: vim_network_name,
                    config: mob_config)
  end
  let(:mob_config) do
    double(:mob_config,
           backing_type: 'nsx',
           logical_switch_uuid: 'fake-ls-uuid')
  end

  it 'returns backing of type OpaqueNetwork' do
    backing_info = subject.nic_backing(dvs_index)
    expect(backing_info).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
    expect(backing_info.opaque_network_id).to eq(mob_config.logical_switch_uuid)
    expect(dvs_index[backing_info.opaque_network_id]).to eq('foo_net')
  end
end