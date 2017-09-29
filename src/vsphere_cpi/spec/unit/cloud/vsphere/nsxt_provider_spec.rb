require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTProvider do
  let(:client) { instance_double(NSXT::Client) }
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
    NSXT::VIF.new('fake-vif-id', 'fake-lport-attachment-id')
  end
  let(:vif_without_lport_attachment) do
    NSXT::VIF.new
  end
  let(:logical_port_1) do
    NSXT::LogicalPort.new(client, 'fake-logical-port-id', nil, { 'attachment_type' => 'VIF', 'id' => vif.id })
  end
  let(:logical_port_2) do
    NSXT::LogicalPort.new(client, 'fake-logical-port-id-2')
  end
  let(:simple_expression_1) do
    NSXT::NSGroup::SimpleExpression.from_resource(logical_port_1, 'id')
  end
  let(:simple_expression_2) do
    NSXT::NSGroup::SimpleExpression.from_resource(logical_port_2, 'id')
  end
  let(:logger) { Logger.new('/dev/null') }

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
      expect(logical_port_1).to receive(:update).with(
        'attachment' => logical_port_1.attachment.merge({ 'context' => {
          'resource_type': 'VifAttachmentContext', 'vif_type': 'PARENT',
        }})
      ).and_return(success_response)
      nsxt_provider.set_vif_type(vm, 'vif_type' => 'PARENT')
    end

    context 'when default_vif_type is set and vif_type is nil' do
      before do
        nsxt_provider.instance_variable_set('@default_vif_type', 'CHILD')
      end

      it 'sets all VIF attachments on the VM to the default_vif_type' do
        expect(logical_port_1).to receive(:update).with(
          'attachment' => logical_port_1.attachment.merge({ 'context' => {
            'resource_type': 'VifAttachmentContext', 'vif_type': 'CHILD',
          }})
        ).and_return(success_response)
        nsxt_provider.set_vif_type(vm, nil)
      end
    end

    context 'when an update fails due to a revision mismatch error' do
      let(:failure_response) do
        HTTP::Message.new_response('{
          "error_code": 206,
          "error_message": "The object LogicalPort/...",
          "httpStatus": "PRECONDITION_FAILED",
          "module_name": "common-services"
        }').tap { |r| r.status = 412 }
      end

      before do
        expect(logical_port_1).to receive(:update).with(
          'attachment' => logical_port_1.attachment.merge({ 'context' => {
            'resource_type': 'VifAttachmentContext', 'vif_type': 'PARENT',
          }})
        ).and_return(failure_response, success_response)
        expect(logical_port_1).to receive(:reload!)
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
        NSXT::NSGroup.new(client, 'id-1', 'test-nsgroup-1')
      end
      let(:nsgroup_2) do
        NSXT::NSGroup.new(client, 'id-2', 'test-nsgroup-2')
      end

      before do
        allow(client).to receive(:nsgroups).and_return([nsgroup_1, nsgroup_2])
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
          expect(nsgroup_1).to receive(:add_members).with(simple_expression_1, simple_expression_2)
          expect(nsgroup_2).to receive(:add_members).with(simple_expression_1, simple_expression_2)

          nsxt_provider.add_vm_to_nsgroups(vm, vm_type_nsxt)
        end
      end
    end
  end

  describe '#remove_vm_from_nsgroups' do
    let(:simple_member) do
      NSXT::NSGroup::SimpleExpression.new('EQUALS', 'LogicalPort', 'id', logical_port_1.id)
      end
    let(:tag_member) do
      NSXT::NSGroup::TagExpression.new('Tenant', 'EQUALS', 'my-tag', 'EQUALS', 'LogicalPort')
    end
    let(:nsgroup_1) do
      NSXT::NSGroup.new(client, 'id-1', 'test-nsgroup-1', [simple_member, tag_member])
    end
    let(:nsgroup_2) do
      NSXT::NSGroup.new(client, 'id-2', 'test-nsgroup-2', [simple_member])
    end
    let(:nsgroup_3) do
      NSXT::NSGroup.new(client, 'id-2', 'test-nsgroup-2', [])
    end

    before do
      allow(nsxt_provider).to receive(:logical_ports).with(vm)
        .and_return([logical_port_1, logical_port_2])
      allow(client).to receive(:nsgroups).and_return([nsgroup_1, nsgroup_2, nsgroup_3])
    end

    it "removes VM's logical ports from all NSGroups" do
      expect(nsgroup_1).to receive(:remove_members).with(simple_expression_1, simple_expression_2)
      expect(nsgroup_2).to receive(:remove_members).with(simple_expression_1, simple_expression_2)

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
    let(:old_vm_id_tag) { { 'scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('old-bosh-id') } }
    let(:new_vm_id_tag) { { 'scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('new-bosh-id') } }
    let(:new_data) do
      { 'tags' => [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }, new_vm_id_tag] }
    end
    let(:existing_tags) { [] }
    let(:success_response) { HTTP::Message.new_response('') }

    context 'with bosh id' do
      before do
        expect(logical_port_1).to receive(:tags).and_return(existing_tags)
        allow(logical_port_2).to receive(:tags).and_return(existing_tags)
        expect(nsxt_provider).to receive(:logical_ports).with(vm)
          .and_return([logical_port_1, logical_port_2])
      end

      context 'when logical ports do not have any tags' do
        let(:existing_tags) { nil }
        let(:new_data) { { 'tags' => [new_vm_id_tag] } }
        it 'adds the id tag' do
          expect(logical_port_1).to receive(:update).with(new_data).and_return(success_response)
          expect(logical_port_2).to receive(:update).with(new_data).and_return(success_response)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when logical ports do not have the id tag' do
        let(:existing_tags) { [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }] }

        it 'adds the id tag' do
          expect(logical_port_1).to receive(:update).with(new_data).and_return(success_response)
          expect(logical_port_2).to receive(:update).with(new_data).and_return(success_response)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when logical ports have one id tag' do
        let(:existing_tags) do
          [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }, old_vm_id_tag]
        end

        it 'sets the existing id tag' do
          expect(logical_port_1).to receive(:update).with(new_data).and_return(success_response)
          expect(logical_port_2).to receive(:update).with(new_data).and_return(success_response)
          nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
        end
      end

      context 'when a logical port has more than one relevant tag' do
        context 'when the relevant tags have the same value' do
          let(:existing_tags) do
            [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }, old_vm_id_tag, old_vm_id_tag]
          end

          it 'consolidates the existing id tags and sets it' do
            expect(logical_port_1).to receive(:update).with(new_data).and_return(success_response)
            expect(logical_port_2).to receive(:update).with(new_data).and_return(success_response)
            nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata)
          end
        end

        context 'when the relevant tags have different values' do
          let(:existing_tags) do
            [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }, old_vm_id_tag, new_vm_id_tag]
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
      let(:existing_tags) { [{ 'scope' => 'bosh/fake', 'tag' => 'fake-data' }] }
      let(:failure_response) do
        HTTP::Message.new_response('{
          "error_code": 206,
          "error_message": "The object LogicalPort/...",
          "httpStatus": "PRECONDITION_FAILED",
          "module_name": "common-services"
        }').tap { |r| r.status = 412 }
      end

      before do
        expect(logical_port).to receive(:tags).at_least(:once).and_return(existing_tags)
        expect(nsxt_provider).to receive(:logical_ports).with(vm).and_return([logical_port])
        expect(logical_port).to receive(:reload!)
        expect(logical_port).to receive(:update).with(new_data).and_return(failure_response, success_response)
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

        expect(client).to receive(:virtual_machines).with(display_name: vm.cid).once
          .and_return([])
        expect(client).to receive(:virtual_machines).with(display_name: vm.cid).exactly(3).times
          .and_return([virtual_machine])

        expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id).once
          .and_return([vif_without_lport_attachment])
        expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id).twice
          .and_return([vif, vif_without_lport_attachment])

        expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id).once
          .and_return([])
        expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id).once
          .and_return([logical_port_1])
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
          expect(client).to receive(:virtual_machines).with(display_name: vm.cid)
            .and_return([])
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::VirtualMachineNotFound)
        end
      end

      context 'when multiple virtual machines are found with same cid' do
        before do
          expect(client).to receive(:virtual_machines).with(display_name: vm.cid)
            .and_return([virtual_machine, virtual_machine])
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::MultipleVirtualMachinesFound)
        end
      end

      context 'when no VIF with logical port attachment can be found' do
        before do
          expect(client).to receive(:virtual_machines).with(display_name: vm.cid)
            .and_return([virtual_machine])
          expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id)
            .and_return([vif_without_lport_attachment])
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::VIFNotFound)
        end
      end

      context 'when no logical ports can be found' do
        before do
          expect(client).to receive(:virtual_machines).with(display_name: vm.cid)
            .and_return([virtual_machine])
          expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id)
            .and_return([vif])
          expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id)
            .and_return([])
        end

        it 'raises an error' do
          expect do
            nsxt_provider.send(:logical_ports, vm)
          end.to raise_error(VSphereCloud::LogicalPortNotFound)
        end
      end
    end

    it 'returns array of logical ports' do
      expect(client).to receive(:virtual_machines).with(display_name: vm.cid)
        .and_return([virtual_machine])
      expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id)
        .and_return([vif, vif_without_lport_attachment])
      expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id)
        .and_return([logical_port_1])

      expect(nsxt_provider.send(:logical_ports, vm)).to eq([logical_port_1])
    end
  end
end
