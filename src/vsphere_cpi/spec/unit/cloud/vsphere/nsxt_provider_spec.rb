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
    NSXT::LogicalPort.new(:id => 'fake-logical-port-id', :tags => nil,
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

  let(:services_svc) do
    NSXT::ServicesApi.new(client)
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
        NSXT::ApiCallError.new(:code => 412)
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
    it 'does nothing when ns_groups is absent or empty' do
      # No call to client should be made
      nsxt_provider.add_vm_to_nsgroups(vm, [])
      nsxt_provider.add_vm_to_nsgroups(vm, nil)
    end

    context 'when nsgroups are specified' do
      let(:ns_groups) { %w(test-nsgroup-1 test-nsgroup-2) }
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
          nsxt_provider.add_vm_to_nsgroups(vm, ns_groups)
        end
      end

      context 'if any of the nsgroups cannot be found in NSXT' do
        let(:ns_groups) { %w(other-nsgroup-1 other-nsgroup-2) }

        it 'should raise a NSGroupsNotFound error' do
          expect(grouping_obj_svc).to receive_message_chain(:list_ns_groups, :results).and_return([nsgroup_1, nsgroup_2])
          expect do
            nsxt_provider.add_vm_to_nsgroups(vm, ns_groups)
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
          nsxt_provider.add_vm_to_nsgroups(vm, ns_groups)
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
      let(:existing_tags) { [NSXT::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data')] }
      let(:failure_response) do
        NSXT::ApiCallError.new(:code => 412)
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
                                .and_return(NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif_without_lport_attachment]),
                                            NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif, vif_without_lport_attachment]),
                                            NSXT::VirtualNetworkInterfaceListResult.new(:results => [vif, vif_without_lport_attachment]))

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
                                             .and_return(NSXT::LogicalPortListResult.new(:results => []))
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

  describe 'add_vm_to_server_pools' do
    let(:serverpool_1) do
      NSXT::LbPool.new(:id => 'id-1', :display_name => 'test-static-serverpool-1')
    end
    let(:ip_address) { '192.168.111.1' }
    let(:port_no) { 443 }
    let(:server_pools) { [[serverpool_1, port_no]] }
    let(:failure_response) do
      NSXT::ApiCallError.new(:code => 412)
    end
    before do
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:services_svc).and_return(services_svc)
    end

    context "when vm's primary ip is present" do
      before do
        allow(vm).to receive_message_chain(:mob, :guest, :ip_address).and_return(ip_address)
      end
      it 'does nothing if server_pools is not present' do
        nsxt_provider.add_vm_to_server_pools(vm, [])
        nsxt_provider.add_vm_to_server_pools(vm, nil)
      end
      it 'adds vm to server_pools with given port' do
        expect(NSXT::PoolMemberSetting).to receive(:new).with(ip_address: ip_address, port: port_no)
        expect(services_svc).to receive(:perform_pool_member_action).with(serverpool_1.id, an_instance_of(NSXT::PoolMemberSettingList), 'ADD_MEMBERS')
        nsxt_provider.add_vm_to_server_pools(vm, server_pools)
      end
      it 'should raise an error if there is error adding vm to the server pool' do
        expect(services_svc).to receive(:perform_pool_member_action).with(serverpool_1.id, anything, anything).and_raise(failure_response)
        expect do
          nsxt_provider.add_vm_to_server_pools(vm, server_pools)
        end.to raise_error(NSXT::ApiCallError)
      end
    end
    context "when vm's primary ip is missing" do
      before do
        allow(vm).to receive_message_chain(:mob, :guest, :ip_address).and_return(nil)
      end
      it "raises an error" do
        expect do
          nsxt_provider.add_vm_to_server_pools(vm, server_pools)
        end.to raise_error(VSphereCloud::VirtualMachineIpNotFound)
      end
    end
  end

  describe 'retrieve_server_pools' do
    before do
      allow_any_instance_of(VSphereCloud::NSXTProvider).to receive(:services_svc).and_return(services_svc)
    end
    it 'does nothing when there are no pools' do
      nsxt_provider.retrieve_server_pools([])
      nsxt_provider.retrieve_server_pools(nil)
    end
    context 'when server_pools are present' do
      let(:server_pool_1) do
        NSXT::LbPool.new(id: 'id-1', display_name: 'test-static-serverpool')
      end
      let(:server_pool_2) do
        NSXT::LbPool.new(id: 'id-2', display_name: 'test-static-serverpool')
      end
      let(:server_pool_3) do
        NSXT::LbPool.new(id: 'id-2', display_name: 'test-dynamic-serverpool')
      end
      let(:server_pool_4) do
        NSXT::LbPool.new(id: 'id-2', display_name: 'test-dynamic-serverpool')
      end

      let(:server_pools) do
        [
          {
            'name' => 'test-static-serverpool',
            'port' => 80
          },
          {
            'name' => 'test-dynamic-serverpool',
            'port' => 443
          }
        ]
      end
      it 'raises an error when any server pool cannot be found' do
        expect(services_svc).to receive_message_chain(:list_load_balancer_pools, :results).and_return([server_pool_1])
        expect do
          nsxt_provider.retrieve_server_pools(server_pools)
        end.to raise_error(VSphereCloud::ServerPoolsNotFound)
      end
      it 'returns list of all matching static and dynamic server pools back' do
        allow(server_pool_3).to receive(:member_group).and_return('test-nsgroup1')
        allow(server_pool_4).to receive(:member_group).and_return('test-nsgroup2')
        expect(services_svc).to receive_message_chain(:list_load_balancer_pools, :results).and_return([server_pool_1, server_pool_2, server_pool_3, server_pool_4])
        static_server_pools, dynamic_server_pools = nsxt_provider.retrieve_server_pools(server_pools)
        expect(static_server_pools).to include([server_pool_1, 80])
        expect(static_server_pools).to include([server_pool_2, 80])
        expect(dynamic_server_pools).to eq([server_pool_3, server_pool_4])
      end
    end
  end
end
