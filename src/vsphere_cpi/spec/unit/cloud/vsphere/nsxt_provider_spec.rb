require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTProvider do
  let(:client) { instance_double(NSXT::ApiClient) }
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
    NSXT::LogicalPort.new(:id =>'fake-logical-port-id', :tags => nil,
      :attachment => NSXT::LogicalPortAttachment.new(:attachment_type => 'VIF', :id => 'fake-id'))
  end
  let(:logical_port_2) do
    NSXT::LogicalPort.new(:id => 'fake-logical-port-id-2')
  end
  let(:simple_expression_1) do
    NSXT::NSGroupSimpleExpression.new(:op => 'EQUALS', :resource_type => 'NSXT::LogicalPort',
                                      :target_property => 'id', :value => logical_port_1.id)
  end
  let(:simple_expression_2) do
    NSXT::NSGroupSimpleExpression.new(:op => 'EQUALS', :resource_type => 'NSXT::LogicalPort',
      :target_property => 'id', :value => logical_port_2.id)
  end
  let(:logger) { Logger.new('/dev/null') }

  let(:grouping_obj_svc) do
    NSXT::GroupingObjectsApi.new(client)
  end

  let(:logical_switching_svc) do
    NSXT::LogicalSwitchingApi.new(client)
  end

  let(:fabric_svc) do
    NSXT::FabricApi.new(client)
  end


  subject(:nsxt_provider) do
    described_class.new(nsxt_config, logger).tap do |provider|
      provider.instance_variable_set('@client', client)
    end
  end

  describe '#set_vif_type' do
    let(:success_response) { HTTP::Message.new_response('') }

    before do
      allow(nsxt_provider).to receive(:logical_ports).with(vm).and_return([logical_port_1])
    end

    it 'does nothing when both default_vif_type and vif_type are nil' do
      # No call to client should be made
      nsxt_provider.set_vif_type(vm, nil)
    end

    it "sets all of the VM's VIF attachments to the vif_type in vm_type" do
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
      expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
      nsxt_provider.set_vif_type(vm, 'vif_type' => 'PARENT')
    end

    context 'when default_vif_type is set and vif_type is nil' do
      before do
        nsxt_provider.instance_variable_set('@default_vif_type', 'CHILD')
      end

      it 'sets all VIF attachments on the VM to the default_vif_type' do
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
        expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
        nsxt_provider.set_vif_type(vm, nil)
      end
    end

    context 'when an update fails due to a revision mismatch error' do
      let(:failure_response) do
        NSXT::ApiCallError.new(:code => 412 )
      end

      before do
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
        expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_raise(failure_response)
        expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
        expect(logical_switching_svc).to receive(:get_logical_port).with(any_args).and_return(logical_port_1)
      end

      it 'retries' do
        nsxt_provider.set_vif_type(vm, 'vif_type' => 'PARENT')
      end
    end
  end

  describe '#add_vm_to_nsgroups' do
    it 'does nothing when vm_type_nsxt is absent or empty' do
      # No call to client should be made
      nsxt_provider.add_vm_to_nsgroups(vm, nil)
      nsxt_provider.add_vm_to_nsgroups(vm, {})
      nsxt_provider.add_vm_to_nsgroups(vm, { 'ns_groups' => [] })
    end

    context 'when nsgroups are specified in vm_type_nsxt' do
      let(:vm_type_nsxt) do
        { 'ns_groups' => %w(test-nsgroup-1 test-nsgroup-2) }
      end
      let(:nsgroup_1) do
        NSXT::NSGroup.new(:id => 'id-1', :display_name => 'test-nsgroup-1')
      end
      let(:nsgroup_2) do
        NSXT::NSGroup.new(:id => 'id-2', :display_name => 'test-nsgroup-2')
      end

      before do
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:grouping_obj_svc).and_return(grouping_obj_svc)
        allow(grouping_obj_svc).to receive_message_chain(:list_ns_groups, :results).and_return([nsgroup_1, nsgroup_2])
      end

      context 'but VM does NOT have any NSX-T opaque network' do
        let(:nics) { [opaque_non_nsxt, network_backing] }

        it 'should no-op' do
          # No call to client should be made
          nsxt_provider.add_vm_to_nsgroups(vm, vm_type_nsxt)
        end
      end

      context 'if any of the nsgroups cannot be found in NSXT' do
        let(:vm_type_nsxt) do
          { 'ns_groups' => %w(other-nsgroup-1 other-nsgroup-2) }
        end

        it 'should raise a NSGroupsNotFound error' do
          expect(grouping_obj_svc).to receive_message_chain(:list_ns_groups, :results).and_return([nsgroup_1, nsgroup_2])
          expect do
            nsxt_provider.add_vm_to_nsgroups(vm, vm_type_nsxt)
          end.to raise_error(VSphereCloud::NSGroupsNotFound)
        end
      end

      context 'when logical ports are found' do
        before do
          expect(nsxt_provider).to receive(:logical_ports).with(vm)
            .and_return([logical_port_1, logical_port_2])
        end

        it 'adds simple expressions containing the logical ports to each NSGroup' do
          expect(grouping_obj_svc).to receive(:add_or_remove_ns_group_expression).with(any_args).twice
          nsxt_provider.add_vm_to_nsgroups(vm, vm_type_nsxt)
        end
      end
    end
  end

  describe '#remove_vm_from_nsgroups' do
    let(:simple_member) do
      NSXT::NSGroupSimpleExpression.new(:op => 'EQUALS', :target_type => 'LogicalPort', :target_property => 'id', :value => logical_port_1.id)
      end
    let(:tag_member) do
      NSXT::NSGroupTagExpression.new(:scope => 'Tenant', :scope_op => 'EQUALS', :tag => 'my-tag', :tag_op => 'EQUALS', :target_type => 'LogicalPort')
    end
    let(:nsgroup_1) do
      NSXT::NSGroup.new(:id => 'id-1', :display_name => 'test-nsgroup-1', :members => [simple_member, tag_member])
    end
    let(:nsgroup_2) do
      NSXT::NSGroup.new(:id => 'id-2', :display_name => 'test-nsgroup-2', :members => [simple_member])
    end
    let(:nsgroup_3) do
      NSXT::NSGroup.new(:is => 'id-2', :display_name => 'test-nsgroup-2', :members => [])
    end

    before do
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:grouping_obj_svc).and_return(grouping_obj_svc)
      allow(grouping_obj_svc).to receive_message_chain(:list_ns_groups, :results).and_return([nsgroup_1, nsgroup_2])
      allow(nsxt_provider).to receive(:logical_ports).with(vm)
        .and_return([logical_port_1, logical_port_2])
    end

    it "removes VM's logical ports from all NSGroups" do
      expect(grouping_obj_svc).to receive(:add_or_remove_ns_group_expression).with(any_args).twice
      nsxt_provider.remove_vm_from_nsgroups(vm)
    end

    context 'but VM does NOT have any NSX-T Opaque Network' do
      let(:nics) { [opaque_non_nsxt, network_backing] }

      it 'should no-op' do
        # No call to client should be made
        nsxt_provider.remove_vm_from_nsgroups(vm)
      end
    end
  end

  describe '#update_vm_metadata_on_logical_ports' do
    let(:metadata) { { 'id' => 'new-bosh-id' } }
    let(:old_vm_id_tag) {
      NSXT::Tag.new('scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('old-bosh-id'))
    }
    let(:new_vm_id_tag) {
      NSXT::Tag.new('scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('new-bosh-id'))
    }
    let(:new_data) do
      { 'tags' => [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data'), new_vm_id_tag] }
    end
    let(:existing_tags) { [] }
    let(:success_response) { HTTP::Message.new_response('') }

    context 'with bosh id' do
      before do
        expect(logical_port_1).to receive(:tags).and_return(existing_tags)
        allow(logical_port_2).to receive(:tags).and_return(existing_tags)
        expect(nsxt_provider).to receive(:logical_ports).with(vm)
          .and_return([logical_port_1, logical_port_2])
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
      end

      context 'when logical ports do not have any tags' do
        let(:existing_tags) { nil }
        let(:new_data) { { 'tags' => [new_vm_id_tag] } }
        it 'adds the id tag' do
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_2)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when logical ports do not have the id tag' do
        let(:existing_tags) {
          [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data')]
        }
        it 'adds the id tag' do
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_2)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when logical ports have one id tag' do
        let(:existing_tags) do
          [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data'), old_vm_id_tag]
        end

        it 'sets the existing id tag' do
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
          expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_2)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when a logical port has more than one relevant tag' do
        context 'when the relevant tags have the same value' do
          let(:existing_tags) do
            [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data'), old_vm_id_tag, old_vm_id_tag]
          end

          it 'consolidates the existing id tags and sets it' do
            expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
            expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_2)
            nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
          end
        end

        context 'when the relevant tags have different values' do
          let(:existing_tags) do
            [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data'), old_vm_id_tag, new_vm_id_tag]
          end

          it 'raises an error' do
            expect do
              nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
            end.to raise_error(VSphereCloud::InvalidLogicalPortError)
          end
        end
      end
    end

    context 'when an update fails due to a revision mismatch error' do
      let(:logical_port) { logical_port_1 }
      let(:existing_tags) { [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data' )] }
      let(:failure_response) do
        NSXT::ApiCallError.new(:code => 412 )
      end

      before do
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
        expect(logical_port).to receive(:tags).at_least(:once).and_return(existing_tags)
        expect(nsxt_provider).to receive(:logical_ports).with(vm).and_return([logical_port])
        expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_raise(failure_response)
        expect(logical_switching_svc).to receive(:update_logical_port_with_http_info).with(any_args).and_return(logical_port_1)
        expect(logical_switching_svc).to receive(:get_logical_port).with(any_args).and_return(logical_port_1)
      end

      it 'retries' do
        nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
      end
    end

    context 'without bosh id' do
      let(:metadata) { { 'index' => 1 } }

      it 'should do nothing' do
        nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
      end
    end

    context 'when there are no NSX-T nics attached to VM' do
      let(:nics) { [opaque_non_nsxt, network_backing] }

      it 'should do nothing' do
        nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
      end
    end
  end

  describe '#logical_ports' do
    context 'retries when' do
      before do
        nsxt_provider.instance_variable_set('@max_tries', 4)
        nsxt_provider.instance_variable_set('@sleep_time', 0.0)
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
        allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
        expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
          .and_return(NSXT::VirtualMachineListResult.new(:results => []),
                      NSXT::VirtualMachineListResult.new(:results => [virtual_machine]),
                      NSXT::VirtualMachineListResult.new(:results => [virtual_machine]),
                      NSXT::VirtualMachineListResult.new(:results => [virtual_machine]))

        expect(fabric_svc).to receive(:list_vifs).with(owner_vm_id: virtual_machine.external_id)
          .and_return(NSXT::VirtualNetworkInterfaceListResult.new(:results =>[vif_without_lport_attachment]),
                      NSXT::VirtualNetworkInterfaceListResult.new(:results =>[vif, vif_without_lport_attachment]),
                      NSXT::VirtualNetworkInterfaceListResult.new(:results =>[vif, vif_without_lport_attachment]))

        expect(logical_switching_svc).to receive(:list_logical_ports).with(attachment_id: vif.lport_attachment_id).once
          .and_return(NSXT::LogicalPortListResult.new(:results => []))
        expect(logical_switching_svc).to receive(:list_logical_ports).with(attachment_id: vif.lport_attachment_id).once
          .and_return(NSXT::LogicalPortListResult.new(:results => [logical_port_1]))
      end

      it 'VirtualMachineNotFound, VIFNotFound or LogicalPortNotFound exception is raised' do
        expect(nsxt_provider.send(:logical_ports, vm)).to eq([logical_port_1])
      end
    end

    context 'fails' do
      before do
        nsxt_provider.instance_variable_set('@max_tries', 0)
        nsxt_provider.instance_variable_set('@sleep_time', 0.0)
      end

      context 'when the virtual machine cannot be found in NSX-T' do
        before do
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
          expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
            .and_return(NSXT::VirtualMachineListResult.new(:results => []))
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::VirtualMachineNotFound)
        end
      end

      context 'when multiple virtual machines are found with same cid' do
        before do
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
          expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
            .and_return(NSXT::VirtualMachineListResult.new(:results => [virtual_machine, virtual_machine]))
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::MultipleVirtualMachinesFound)
        end
      end

      context 'when no VIF with logical port attachment can be found' do
        before do
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
          expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
            .and_return(NSXT::VirtualMachineListResult.new(:results => [virtual_machine]))
          expect(fabric_svc).to receive(:list_vifs).with(owner_vm_id: virtual_machine.external_id)
            .and_return(NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif_without_lport_attachment]))

        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::VIFNotFound)
        end
      end

      context 'when no logical ports can be found' do
        before do
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
          allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
          expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
            .and_return(NSXT::VirtualMachineListResult.new(:results => [virtual_machine]))
          expect(fabric_svc).to receive(:list_vifs).with(owner_vm_id: virtual_machine.external_id)
            .and_return(NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif]))
          expect(logical_switching_svc).to receive(:list_logical_ports).with(attachment_id: vif.lport_attachment_id)
            .and_return(NSXT::LogicalPortListResult.new(:results =>[]))
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::LogicalPortNotFound)
        end
      end
    end

    it 'returns array of logical ports' do
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:fabric_svc).and_return(fabric_svc)
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:logical_switching_svc).and_return(logical_switching_svc)
      expect(fabric_svc).to receive(:list_virtual_machines).with(display_name: vm.cid)
        .and_return(NSXT::VirtualMachineListResult.new(:results => [virtual_machine]))
      expect(fabric_svc).to receive(:list_vifs).with(owner_vm_id: virtual_machine.external_id)
        .and_return(NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif, vif_without_lport_attachment]))
      expect(logical_switching_svc).to receive(:list_logical_ports).with(attachment_id: vif.lport_attachment_id)
        .and_return(NSXT::LogicalPortListResult.new(:results => [logical_port_1]))

      expect(nsxt_provider.send(:logical_ports, vm)).to eq([logical_port_1])
    end
  end

  describe '#create_t1_router' do
    let(:router_name) { 'bosh_t1_ngo28f' }
    let(:t1_router) { instance_double(NSXT::LogicalRouter,
                                            id: 't1-router-id',
                                      display_name: router_name ) }
    let(:router_api) { instance_double(NSXT::LogicalRoutingAndServicesApi) }

    before do
      allow(nsxt_provider).to receive(:router_api).and_return(router_api)
    end
    context 'when all params are correct' do
      it 'creates t1 logical router with given name' do
        expect(router_api).to receive(:create_logical_router)
          .with( { :edge_cluster_id => 'c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28',
                   :router_type => 'TIER1',
                   :display_name => 'bosh_t1_ngo28f' } )
          .and_return(t1_router)
        result = nsxt_provider.create_t1_router('c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28', router_name)
        expect(result).not_to be_nil
        expect(result.id).not_to be_nil
        expect(result.display_name).to eq('bosh_t1_ngo28f')
      end
    end

    context 'when display_name is empty' do
      let(:router_name) { nil }
      let(:random_name) { 'very random' }
      before do
        allow(SecureRandom).to receive(:base64).with(8).and_return(random_name)
      end
      it 'randomly generates name' do
        expect(router_api).to receive(:create_logical_router)
          .with( { :edge_cluster_id => 'c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28',
                   :router_type => 'TIER1',
                   :display_name => random_name } )
          .and_return(t1_router)
        result = nsxt_provider.create_t1_router('c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28', router_name)
        expect(result).not_to be_nil
      end
    end

    context 'when edge_cluster_id is nil' do
      it 'throws an error' do
        expect { nsxt_provider.create_t1_router(nil) }.to raise_error(/edge_cluster_id param can not be nil/)
      end
    end

    context 'when api call is failing' do
      it 'propogates an error' do
        expect(router_api).to receive(:create_logical_router)
          .with(any_args)
          .and_raise('NSXT API error')
        expect {
          nsxt_provider.create_t1_router('c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28')
        }.to raise_error('NSXT API error')
      end
    end
  end

  describe '#attach_t1_to_t0' do
    let(:router_api) { instance_double(NSXT::LogicalRoutingAndServicesApi) }
    let(:t0_router_port) {
      instance_double(NSXT::LogicalRouterLinkPortOnTIER0,
                      :id => 't0_port_id').as_null_object
    }
    before do
      allow(nsxt_provider).to receive(:router_api).and_return(router_api)
    end

    context 'when T0 router exists' do
      let(:t1_router_port) { instance_double(NSXT::LogicalRouterLinkPortOnTIER1) }
      let(:t0_reference) { instance_double(NSXT::ResourceReference) }

      context 'when T1 router exists' do
        it 'creates T1 logical router port and attaches it to T0' do
          expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
            .with({:logical_router_id => 't0_router_id',
                   :resource_type => 'LogicalRouterLinkPortOnTIER0'})
            .and_return(t0_router_port)
          expect(router_api).to receive(:create_logical_router_port)
            .with(t0_router_port).and_return(t0_router_port)

          expect(NSXT::ResourceReference).to receive(:new)
            .with({ :target_id => 't0_port_id',
                    :target_type => 'LogicalRouterLinkPortOnTIER0',
                    :is_valid => true })
            .and_return(t0_reference)
          expect(NSXT::LogicalRouterLinkPortOnTIER1).to receive(:new)
            .with({:logical_router_id => 't1_router_id',
                   :linked_logical_router_port_id => t0_reference,
                   :resource_type => 'LogicalRouterLinkPortOnTIER1'})
            .and_return(t1_router_port)
          expect(router_api).to receive(:create_logical_router_port)
            .with(t1_router_port)
          nsxt_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
        end
      end

      context 'when failing to create T1 port' do
        it 'throws error with T0 router port id and T1 router id' do
          expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
            .with({:logical_router_id => 't0_router_id',
                   :resource_type => 'LogicalRouterLinkPortOnTIER0'})
            .and_return(t0_router_port)
          expect(router_api).to receive(:create_logical_router_port)
            .with(t0_router_port).and_return(t0_router_port)

          expect(NSXT::LogicalRouterLinkPortOnTIER1).to receive(:new)
            .with(any_args).and_return(t1_router_port)

          expect(router_api).to receive(:create_logical_router_port)
            .with(t1_router_port).and_raise('CPI error without router id')
          expect {
            nsxt_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
          }.to raise_error { |error|
            expect(error.to_s).to match /t0_port_id/
            expect(error.to_s).to match /t1_router_id/
          }
        end
      end
    end

    context 'when failing to create T0 router port' do
      it 'raises an error with T0 id' do
        expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
          .with({:logical_router_id => 't0_router_id',
                 :resource_type => 'LogicalRouterLinkPortOnTIER0'})
          .and_return(t0_router_port)
        expect(router_api).to receive(:create_logical_router_port)
          .with(t0_router_port).and_raise('CPI error without router id')

        expect {
          nsxt_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
        }.to raise_error { |error|
          expect(error.to_s).to match /t0_router_id/
        }
      end
    end

    context 'when T0 id is nil' do
      it 'raises an error' do
        expect {
          nsxt_provider.attach_t1_to_t0(nil, 't1_router_id')
        }.to raise_error /T0 router id can not be nil/
      end
    end
    context 'when T1 id is nil' do
      it 'raises an error' do
        expect {
          nsxt_provider.attach_t1_to_t0('t0_router_id', nil)
        }.to raise_error /T1 router id can not be nil/
      end
    end
  end

  describe '#create_logical_switch' do
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi) }
    let(:logical_switch) { instance_double(NSXT::LogicalSwitch) }
    before do
      allow(nsxt_provider).to receive(:switch_api).and_return(switch_api)
    end
    context 'when transport zone id is provided' do
      it 'creates switch' do
        expect(NSXT::LogicalSwitch).to receive(:new)
          .with({ :admin_state => 'UP',
                  :transport_zone_id => 'zone_id',
                  :replication_mode => 'MTEP',
                  :display_name => 'Switch name'})
          .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
          .with(logical_switch)
        nsxt_provider.create_logical_switch('zone_id', 'Switch name')
      end
    end
    context 'when transport zone id is nil' do
      it 'raises an error' do
        expect { nsxt_provider.create_logical_switch(nil, 'name') }
            .to raise_error(/Transport zone id can not be nil/)
      end
    end
    context 'when switch name is empty' do
      it 'Does not fail' do
        expect(NSXT::LogicalSwitch).to receive(:new)
           .with({ :admin_state => 'UP',
                   :transport_zone_id => 'zone_id',
                   :replication_mode => 'MTEP',
                   :display_name => nil})
           .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
            .with(logical_switch)
        nsxt_provider.create_logical_switch('zone_id')
      end
    end
  end

  describe '#attach_switch_to_t1' do
    let(:router_api) { instance_double(NSXT::LogicalRoutingAndServicesApi) }
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi)}
    before do
      allow(nsxt_provider).to receive(:router_api).and_return(router_api)
      allow(nsxt_provider).to receive(:switch_api).and_return(switch_api)
    end
    let(:subnet) { instance_double(NSXT::IPSubnet) }
    let(:logical_port) { instance_double(NSXT::LogicalPort, :id => 'logical-port-id') }

    context 'when T1 router exists' do
      let(:switch_port_ref) { instance_double(NSXT::ResourceReference) }

      it 'creates logical switch port attached to router' do
        expect(NSXT::LogicalPort).to receive(:new)
          .with({ :admin_state => 'UP',
                  :logical_switch_id => 'switch-id' }).and_return(logical_port)
        expect(switch_api).to receive(:create_logical_port)
          .with(logical_port).and_return(logical_port)

        expect(NSXT::ResourceReference).to receive(:new)
          .with({:target_id => 'logical-port-id',
                 :target_type => 'LogicalPort',
                 :is_valid => true})
           .and_return(switch_port_ref)
        expect(NSXT::LogicalRouterDownLinkPort).to receive(:new)
          .with({ :logical_router_id => 't1-router-id',
                  :linked_logical_switch_port_id => switch_port_ref,
                  :resource_type => 'LogicalRouterDownLinkPort',
                  :subnets => [subnet]
                }).and_return(logical_port)
        expect(router_api).to receive(:create_logical_router_port)
          .with(logical_port)

        nsxt_provider.attach_switch_to_t1('switch-id', 't1-router-id', subnet)
      end
    end

    context 'when fails to create logical port' do
      it 'raises an error with switch id' do
        expect(switch_api).to receive(:create_logical_port)
          .with(any_args).and_raise('Some IAAS exception')
        expect {
          nsxt_provider.attach_switch_to_t1('switch-id', 't1-router-id', subnet)
        }.to raise_error{ |error|
          expect(error.to_s).to match(/switch-id/)
        }
      end
    end

    context 'when fails to create logical router port' do
      it 'raises an error with switch and router ids' do
        expect(switch_api).to receive(:create_logical_port)
          .with(any_args).and_return(logical_port)

        expect(router_api).to receive(:create_logical_router_port)
          .with(any_args).and_raise('Some IAAS exception')

        expect {
          nsxt_provider.attach_switch_to_t1('switch-id', 't1-router-id', subnet)
        }.to raise_error{ |error|
          expect(error.to_s).to match(/switch-id/)
          expect(error.to_s).to match(/t1-router-id/)
        }
      end
    end

    context 'when switch id is empty' do
      it 'raises an error' do
        expect {
          nsxt_provider.attach_switch_to_t1(nil, 't1-router-id', subnet)
        }.to raise_error(/Switch id can not be nil/)
      end
    end

    context 'when t1 router id is empty' do
      it 'raises an error' do
        expect {
          nsxt_provider.attach_switch_to_t1('switch-id', nil, subnet)
        }.to raise_error(/Router id can not be nil/)
      end
    end

    context 'when subnet is null' do
      it 'raises an error' do
        expect {
          nsxt_provider.attach_switch_to_t1('switch-id', 't1-router-id', nil)
        }.to raise_error(/Subnet can not be nil/)
      end
    end
  end
end