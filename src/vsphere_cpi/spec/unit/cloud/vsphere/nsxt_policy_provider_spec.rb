require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTPolicyProvider, fake_logger: true do
  let(:client) { instance_double(NSXTPolicyClient::ApiClient) }
  let(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-password') }
  let(:opaque_nsxt) do
    instance_double(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard,
        device_info: instance_double(
            VimSdk::Vim::Description,
            summary: 'nsx.LogicalSwitch: nsx-t-network-id'
        ),
        backing: VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new.tap do |backing|
          backing.opaque_network_type = 'nsx.LogicalSwitch'
        end
    )
  end
  let(:opaque_non_nsxt) do
    instance_double(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard,
        device_info: instance_double(
            VimSdk::Vim::Description,
            summary: 'non-nsx-t'
        ),
        backing: VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new.tap do |backing|
          backing.opaque_network_type = 'nsx.LogicalRouter'
        end
    )
  end
  let(:network_backing) do
    instance_double(
        VimSdk::Vim::Vm::Device::VirtualEthernetCard,
        device_info: instance_double(
            VimSdk::Vim::Description,
            summary: 'network'
        ),
        backing: VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new.tap do |backing|
          backing.device_name = 'network-name'
        end
    )
  end
  let(:nics) { [opaque_non_nsxt, network_backing, opaque_nsxt] }
  let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: 'fake-vm-id', nics: nics) }
  let(:virtual_machine) do
    NSXT::VirtualMachine.new(external_id: 'fake-external-id')
  end
  let(:vif) do
    NSXT::VirtualNetworkInterface.new(:lport_attachment_id => 'fake-lport-attachment-id')
  end
  let(:vif_without_lport_attachment) do
    NSXT::VirtualNetworkInterface.new
  end
  let(:logical_port_1) do
    NSXT::LogicalPort.new(:id => 'fake-logical-port-id', :tags => nil,
                          :attachment => NSXT::LogicalPortAttachment.new(:attachment_type => 'VIF', :id => 'fake-id'))
  end
  let(:logical_port_2) do
    NSXT::LogicalPort.new(:id => 'fake-logical-port-id-2')
  end

  let(:grouping_obj_svc) do
    NSXT::GroupingObjectsApi.new(client)
  end

  let(:logical_switching_svc) do
    NSXT::LogicalSwitchingApi.new(client)
  end

  let(:fabric_svc) do
    NSXT::FabricApi.new(client)
  end

  let(:services_svc) do
    NSXT::ServicesApi.new(client)
  end

  let(:default_vif_type) { 'PARENT' }

  let(:nsxt_manager) {instance_double(VSphereCloud::NSXTProvider) }

  subject(:nsxt_policy_provider) do
    described_class.new(client, nsxt_manager).tap do |provider|
      provider.instance_variable_set('@client', client)
    end
  end

  describe '#retrieve_all_groups' do
    context 'when cursor is nil' do
      before do
        expect { |b| subject.send(:retrieve_all_with_pagination, {object_type: 'dummy'}, &b) }.to yield_with_args(nil)
        expect(nsxt_policy_provider).to receive(:policy_api).once
      end
      it 'fetches all groups' do
        subject.send :retrieve_all_groups
      end
    end
  end

  describe '#retrieve_all_with_pagination' do
    let(:result_list) { double(Object, results: ['obj_1, obj_2'], cursor: nil) }
    context 'when there is only one page' do
      it 'retrieves the objects successfully' do
        block = Proc.new do |cursor=nil|
          result_list
        end
        kwargs = {object_type: 'dummy_obj'}
        result = subject.send :retrieve_all_with_pagination, **kwargs, &block
        expect(result).to eq(result_list.results)
      end
    end
    context 'when there are multiple pages' do
      let(:result_list_0) { double(Object, results: ['obj_1, obj_2'], cursor: 1) }
      let(:result_list_1) { double(Object, results: ['obj_3, obj_4'], cursor: 2) }
      let(:result_list_2) { double(Object, results: ['obj_5, obj_6'], cursor: nil) }
      it 'retrieves the objects successfully' do
        block = Proc.new do |cursor=nil|
          case cursor
          when nil
            result_list_0
          when 1
            result_list_1
          when 2
            result_list_2
          end
        end
        kwargs = {object_type: 'dummy_obj'}
        result = subject.send :retrieve_all_with_pagination, **kwargs, &block
        expect(result).to eq(result_list_0.results+\
                             result_list_1.results+\
                             result_list_2.results\
                            )
      end
    end
  end
end