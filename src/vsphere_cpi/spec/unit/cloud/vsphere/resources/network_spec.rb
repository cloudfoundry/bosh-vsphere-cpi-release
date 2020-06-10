require 'spec_helper'
require 'rspec/its'

shared_context 'network resource example context', network_resource: true do
  subject { described_class.new(mob, client) }

  let(:client) do
    instance_double(VSphereCloud::VCenterClient, cloud_searcher: cloud_searcher)
  end
  let(:cloud_searcher) { instance_double(VSphereCloud::CloudSearcher) }
  let(:vim_network_name) { 'fake-network' }
end

describe VSphereCloud::Resources::Network, network_resource: true do
  let(:mob) { instance_double(VimSdk::Vim::Network, name: vim_network_name) }

  describe '.make_network_resource' do
    subject { described_class.make_network_resource(mob, client) }
    shared_examples 'a subtype of Network' do |type|
      it("returns a #{type}") { expect(subject).to be_an_instance_of(type) }
    end

    context 'with a standard network' do
      let(:mob) do
        mob = VimSdk::Vim::Network.new(name: vim_network_name)
        allow(mob).to receive(:name).and_return(vim_network_name)
        mob
      end
      include_examples 'a subtype of Network', VSphereCloud::Resources::Network
    end

    context 'with an opaque network' do
      let(:mob) { VimSdk::Vim::OpaqueNetwork.new(name: vim_network_name) }
      include_examples 'a subtype of Network', VSphereCloud::Resources::OpaqueNetwork
    end

    context 'with a DVPG' do
      let(:mob) do
        mob = VimSdk::Vim::Dvs::DistributedVirtualPortgroup.new(
          name: vim_network_name, config: mob_config)
        allow(mob).to receive(:config).and_return(mob_config)
        mob
      end
      let(:mob_config) { double(:config) }

      context "when the DVPG's backing type is 'standard'" do
        before { allow(mob_config).to receive(:backing_type).and_return('standard') }
        include_examples 'a subtype of Network', VSphereCloud::Resources::DistributedVirtualPortGroupNetwork
      end

      context "when the DVPG's config doesn't respond to #backing_type" do
        include_examples 'a subtype of Network', VSphereCloud::Resources::DistributedVirtualPortGroupNetwork
      end

      context "when the DVPG's backing type is 'nsx'" do
        before { allow(mob_config).to receive(:backing_type).and_return('nsx') }
        include_examples 'a subtype of Network', VSphereCloud::Resources::DistributedVirtualPortGroupNSXTNetwork
      end
    end
  end

  describe '#nic_backing' do
    it 'returns a backing info of type NetworkBackingInfo' do
      backing_info = subject.nic_backing
      expect(backing_info).to be_an_instance_of(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo)
      expect(backing_info.device_name).to be(vim_network_name)
    end
  end

  its(:network_id) { is_expected.to be_nil }
end

describe VSphereCloud::Resources::OpaqueNetwork, network_resource: true do
  let(:mob) do
    summary = instance_double(VimSdk::Vim::OpaqueNetwork::Summary,
                              opaque_network_type: 'nsx',
                              opaque_network_id: opaque_network_id)
    instance_double(
      VimSdk::Vim::OpaqueNetwork, name: vim_network_name, summary: summary)
  end
  let(:opaque_network_id) { 'fake-id' }

  describe '#nic_backing' do
    it 'returns a backing info of type OpaqueNetworkBackingInfo ' do
      backing_info = subject.nic_backing
      expect(backing_info).to be_an_instance_of(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
      expect(backing_info.opaque_network_id).to eq(opaque_network_id)
    end
  end

  its(:network_id) { is_expected.to eq(opaque_network_id) }
end


describe VSphereCloud::Resources::DistributedVirtualPortGroupNetwork,
    network_resource: true do
  let(:mob) do
    instance_double(
      VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
      name: vim_network_name,
      config: double(backing_type: 'standard', key: dvpg_key),
    )
  end
  let(:dvpg_key) { 'fake-dvpg-key' }

  describe '#nic_backing' do
    it 'returns a backing info of type DistributedVirtualPortBackingInfo' do
      expect(cloud_searcher).to receive(:get_properties).with(mob, any_args).and_return(
        'config.key' => dvpg_key,
        'config.distributedVirtualSwitch' => 'fake-dvpg-dvs',
      )
      expect(cloud_searcher).to receive(:get_property)
        .with('fake-dvpg-dvs', any_args).and_return('fake-dvpg-dvs-uuid')

      backing_info = subject.nic_backing
      expect(backing_info).to be_an_instance_of(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo)
      expect(backing_info.port.portgroup_key).to eq(dvpg_key)
      expect(backing_info.port.switch_uuid).to eq('fake-dvpg-dvs-uuid')
    end
  end

  its(:network_id) { is_expected.to eq(dvpg_key) }
end


describe VSphereCloud::Resources::DistributedVirtualPortGroupNSXTNetwork,
    network_resource: true do
  let(:mob) do
    instance_double(
      VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
      name: vim_network_name,
      config: double(backing_type: 'nsx', logical_switch_uuid: switch_id),
    )
  end
  let(:switch_id) { 'fake-logical-switch-uuid' }

  it 'returns a backing info of type OpaqueNetworkBackingInfo' do
    backing_info = subject.nic_backing
    expect(backing_info).to be_an_instance_of(
      VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
    expect(backing_info.opaque_network_id).to eq(switch_id)
  end

  its(:network_id) { is_expected.to eq(switch_id) }
end
