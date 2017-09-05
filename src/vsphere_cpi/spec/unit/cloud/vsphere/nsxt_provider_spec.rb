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
    NSXT::VIF.new(lport_attachment_id: 'fake-lport-attachment-id')
  end
  let(:vif_without_lport_attachment) do
    NSXT::VIF.new
  end
  let(:logical_port_1) do
    NSXT::LogicalPort.new('fake-logical-port-id')
  end
  let(:logical_port_2) do
    NSXT::LogicalPort.new('fake-logical-port-id-2')
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

  describe '#add_vm_to_nsgroups' do
    it 'does nothing when vm_type_nsxt is absent or empty' do
      # No call to client should be made
      nsxt_provider.add_vm_to_nsgroups(vm, nil)
      nsxt_provider.add_vm_to_nsgroups(vm, {})
      nsxt_provider.add_vm_to_nsgroups(vm, { 'nsgroups' => [] })
    end

    context 'when nsgroups are specified in vm_type_nsxt' do
      let(:vm_type_nsxt) do
        { 'nsgroups' => %w(test-nsgroup-1 test-nsgroup-2) }
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
          { 'nsgroups' => %w(other-nsgroup-1 other-nsgroup-2) }
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

  describe '#logical_ports' do
    context 'fails' do
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
          end.to raise_error(/Multiple NSX-T virtual machines found/)
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
