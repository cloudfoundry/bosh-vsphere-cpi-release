require 'spec_helper'

describe VSphereCloud::NSXTProvider do
  let(:client) { instance_double(VSphereCloud::NSXT::Client) }
  let(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-password') }
  let(:vm_id) { 'fake-vm-id' }
  let(:virtual_machine) do
    VSphereCloud::NSXT::VirtualMachine.new(external_id: 'fake-external-id')
  end
  let(:vif) do
    VSphereCloud::NSXT::VIF.new(lport_attachment_id: 'fake-lport-attachment-id')
  end
  let(:logical_port) do
    VSphereCloud::NSXT::LogicalPort.new(id: 'fake-logical-port-id')
  end
  subject(:nsxt_provider) do
    described_class.new(nsxt_config).tap do |provider|
      provider.instance_variable_set('@client', client)
    end
  end

  describe '#add_vm_to_nsgroups' do
    it 'does nothing when vm_type_nsxt is absent or empty' do
      # No call to client should be made
      nsxt_provider.add_vm_to_nsgroups(vm_id, nil)
      nsxt_provider.add_vm_to_nsgroups(vm_id, {})
      nsxt_provider.add_vm_to_nsgroups(vm_id, { 'nsgroups' => [] })
    end

    context 'when nsgroups are specified in vm_type_nsxt' do
      let(:vm_type_nsxt) do
        { 'nsgroups' => %w(test-nsgroup-1 test-nsgroup-2) }
      end
      let(:nsgroup_1) do
        VSphereCloud::NSXT::NSGroup.new(client, id: 'id-1', display_name: 'test-nsgroup-1')
      end
      let(:nsgroup_2) do
        VSphereCloud::NSXT::NSGroup.new(client, id: 'id-2', display_name: 'test-nsgroup-2')
      end

      before do
        expect(client).to receive(:nsgroups).and_return([nsgroup_1, nsgroup_2])
      end

      context 'if any of the nsgroups cannot be found in NSXT' do
        let(:vm_type_nsxt) do
          { 'nsgroups' => %w(other-nsgroup-1 other-nsgroup-2) }
        end

        it 'should raise a NSGroupsNotFound error' do
          expect do
            nsxt_provider.add_vm_to_nsgroups(vm_id, vm_type_nsxt)
          end.to raise_error(VSphereCloud::NSGroupsNotFound)
        end
      end

      context 'when logical port is found' do
        before do
          expect(nsxt_provider).to receive(:logical_port).with(vm_id).and_return(logical_port)
        end

        it 'adds the logical port to each NSGroup' do
          expect(nsgroup_1).to receive(:add_member).with(logical_port)
          expect(nsgroup_2).to receive(:add_member).with(logical_port)

          nsxt_provider.add_vm_to_nsgroups(vm_id, vm_type_nsxt)
        end
      end
    end
  end

  describe '#remove_vm_from_nsgroups' do
    let(:membership) do
      VSphereCloud::NSXT::NSGroup::SimpleExpression.new(target_type: 'LogicalPort', target_property: 'id', op: 'EQUALS', value: logical_port.id)
    end
    let(:nsgroup_1) do
      VSphereCloud::NSXT::NSGroup.new(client, id: 'id-1', display_name: 'test-nsgroup-1', members: [membership])
    end
    let(:nsgroup_2) do
      VSphereCloud::NSXT::NSGroup.new(client, id: 'id-2', display_name: 'test-nsgroup-2', members: [membership])
    end

    before do
      expect(client).to receive(:nsgroups).and_return([nsgroup_1, nsgroup_2])
      expect(nsxt_provider).to receive(:logical_port).with(vm_id).and_return(logical_port)
    end

    it "removes VM's logical port from all NSGroups" do
      expect(nsgroup_1).to receive(:remove_member).with(logical_port)
      expect(nsgroup_2).to receive(:remove_member).with(logical_port)

      nsxt_provider.remove_vm_from_nsgroups(vm_id)
    end
  end

  describe '#logical_port' do
    context 'when the virtual machine cannot be found in NSXT' do
      before do
        expect(client).to receive(:virtual_machines).with(display_name: vm_id).and_return([])
      end

      it 'should raise a VirtualMachineNotFound error' do
        expect do
          nsxt_provider.send(:logical_port, vm_id)
        end.to raise_error(VSphereCloud::VirtualMachineNotFound)
      end
    end

    context 'when a VIF cannot be found' do
      before do
        expect(client).to receive(:virtual_machines).with(display_name: vm_id).and_return([virtual_machine])
        expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id).and_return([])
      end

      it 'should raise a VIFNotFound error' do
        expect do
          nsxt_provider.send(:logical_port, vm_id)
        end.to raise_error(VSphereCloud::VIFNotFound)
      end
    end

    context 'when a logical port cannot be found' do
      before do
        expect(client).to receive(:virtual_machines).with(display_name: vm_id).and_return([virtual_machine])
        expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id).and_return([vif])
        expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id).and_return([])
      end

      it 'should raise a LogicalPortNotFound error' do
        expect do
          nsxt_provider.send(:logical_port, vm_id)
        end.to raise_error(VSphereCloud::LogicalPortNotFound)
      end
    end

    context 'when logical port can be found' do
      before do
        expect(client).to receive(:virtual_machines).with(display_name: vm_id).and_return([virtual_machine])
        expect(client).to receive(:vifs).with(owner_vm_id: virtual_machine.external_id).and_return([vif])
        expect(client).to receive(:logical_ports).with(attachment_id: vif.lport_attachment_id).and_return([logical_port])
      end

      it 'returns logical port' do
        expect(nsxt_provider.send(:logical_port, vm_id)).to eq(logical_port)
      end
    end
  end
end
