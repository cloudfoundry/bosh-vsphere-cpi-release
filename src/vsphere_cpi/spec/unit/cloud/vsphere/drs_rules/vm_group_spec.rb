require 'spec_helper'

describe VSphereCloud::VmGroup, fake_logger: true do
  subject(:vm_group) do
    described_class.new(
      client,
      datacenter_cluster,
    )
  end
  let(:datacenter_cluster) { instance_double('VimSdk::Vim::ClusterComputeResource') }
  let(:client) { instance_double('VSphereCloud::VCenterClient') }
  let(:service_content) { instance_double('VimSdk::Vim::ServiceInstanceContent') }
  let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
  let(:task) { double(:task) }
  let(:drs_lock) { instance_double('VSphereCloud::DrsLock') }
  let(:vm_1) { instance_double('VimSdk::Vim::VirtualMachine', name: 'vm-1') }
  let(:vms) { [vm_1] }
  let(:vm_group_name) {'vm-group'}
  let(:vm_groups) { [ VimSdk::Vim::Cluster::VmGroup.new(name: vm_group_name, vm: vms) ] }
  let(:configuration_ex) { double(:configuration_ex, group: vm_groups) }

  before do
    allow(client).to receive(:wait_for_task) do |*args, &block|
      expect(block.call).to eq(task)
    end
    allow(client).to receive(:service_content).and_return(service_content)
    allow(service_content).to receive(:custom_fields_manager).and_return(custom_fields_manager)
    allow(VSphereCloud::DrsLock).to receive(:new).and_return(drs_lock)
  end

  def with_lock
    expect(drs_lock).to receive(:with_drs_lock).and_yield.ordered

    yield
  end

  describe '#add_vm_to_vm_group' do
    let(:vm_2) { instance_double('VimSdk::Vim::VirtualMachine', name: 'vm-2') }

    before do
      allow(datacenter_cluster).to receive(:configuration_ex).and_return(configuration_ex)
      allow(datacenter_cluster).to receive(:reconfigure_ex).and_return(task)
    end

    context 'when vm_group exists' do
      it 'adds vm to the existing vm_group with DRS lock' do
        with_lock do
          expect(datacenter_cluster).to receive(:reconfigure_ex) do |config|
            group_spec = config.group_spec.first
            expect(group_spec.operation).to eq(VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT)
            group_info = group_spec.info
            expect(group_info).to be_an_instance_of(VimSdk::Vim::Cluster::VmGroup)
            expect(group_info.vm).to eq([vm_1, vm_2])
            expect(group_info.name).to eq(vm_group_name)

          end.ordered.and_return(task)
        end
        vm_group.add_vm_to_vm_group(vm_2, vm_group_name)
      end
    end
    context 'when vm_group does not exists' do
      let(:vm_groups) { []}
      it 'creates vm_group and adds vm to it with DRS lock' do
        with_lock do
          expect(datacenter_cluster).to receive(:reconfigure_ex) do |config|
            group_spec = config.group_spec.first
            expect(group_spec.operation).to eq(VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD)
            group_info = group_spec.info
            expect(group_info).to be_an_instance_of(VimSdk::Vim::Cluster::VmGroup)
            expect(group_info.vm).to eq([vm_1])
            expect(group_info.name).to eq(vm_group_name)

          end.ordered.and_return(task)
        end
        vm_group.add_vm_to_vm_group(vm_1, vm_group_name)
      end
    end
  end
  describe '#delete_vm_groups' do
    before do
      allow(datacenter_cluster).to receive(:configuration_ex).and_return(configuration_ex)
    end

    context 'when vm_group is not empty' do
      it 'should not delete the vm group' do
        with_lock do
          expect(datacenter_cluster).to_not receive(:reconfigure_ex)
        end
        vm_group.delete_vm_groups([vm_group_name])
      end
    end

    context 'when vm_group is empty' do
      let(:vms) { [] }
      it 'should delete the vm group' do
        with_lock do
          expect(datacenter_cluster).to receive(:reconfigure_ex) do |config|
            group_spec = config.group_spec.first
            expect(group_spec.operation).to eq(VimSdk::Vim::Option::ArrayUpdateSpec::Operation::REMOVE)
            group_info = group_spec.info
            expect(group_info).to be_an_instance_of(VimSdk::Vim::Cluster::VmGroup)
            expect(group_info.name).to eq(vm_group_name)

          end.ordered.and_return(task)
        end
        vm_group.delete_vm_groups([vm_group_name])
      end
    end
  end
end
