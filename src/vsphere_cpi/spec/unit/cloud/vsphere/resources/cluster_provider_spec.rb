require 'digest'
require 'spec_helper'
module VSphereCloud::Resources
  describe ClusterProvider, fake_logger: true do
    subject(:cluster_provider) do
      described_class.new(
        client: client,
        datacenter_name: datacenter_name,
      )
    end
    let(:client) { instance_double('VSphereCloud::VCenterClient') }
    let(:datacenter_name) { 'fancy-datacenter' }

    before do
      allow(client).to receive(:service_content).and_return(service_content)
      allow(client).to receive(:wait_for_task) do |*args, &block|
        expect(block.call).to eq(task)
      end
    end

    let(:service_content) { instance_double('VimSdk::Vim::ServiceInstanceContent') }
    before do
      allow(service_content).to receive(:custom_fields_manager).and_return(custom_fields_manager)
    end

    let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
    let(:task) { double(:task) }
    let(:datacenter_cluster) { instance_double('VimSdk::Vim::ClusterComputeResource') }
    let(:lock_key) { 42 }

    let(:vm_attribute_manager) { instance_double('VSphereCloud::VMAttributeManager') }
    before do
      allow(VSphereCloud::VMAttributeManager).to receive(:new).and_return(vm_attribute_manager)
    end

    let(:drs_lock) { instance_double('VSphereCloud::DrsLock') }
    before { allow(VSphereCloud::DrsLock).to receive(:new).and_return(drs_lock) }

    def with_lock
      expect(drs_lock).to receive(:with_drs_lock).and_yield.ordered

      yield
    end

    describe '#delete_vm_groups' do
      let(:vm_1) { double('VimSdk::Vim::VirtualMachine') }
      let(:vm_group_name) {'vm-group'}
      let(:vms) { [vm_1] }
      let(:vm_groups) { [ VimSdk::Vim::Cluster::VmGroup.new(name: vm_group_name, vm: vms) ] }
      let(:configuration_ex) { double(:configuration_ex, group: vm_groups) }
      before do
        allow(datacenter_cluster).to receive(:configuration_ex).and_return(configuration_ex)
      end

      context 'when vm_group is not empty' do
        it 'should not delete the vm group' do
          with_lock do
            expect(datacenter_cluster).to_not receive(:reconfigure_ex)
          end
          cluster_provider.delete_vm_groups(datacenter_cluster, [vm_group_name])
        end
      end

      context 'when vm_group is empty' do
        let(:vms) { [] }
        it 'should delete the vm group' do
          with_lock do
            expect(datacenter_cluster).to receive(:reconfigure_ex) do |config|
              group_spec = config.group_spec.first
              expect(group_spec.operation).to eq('remove')
              group_info = group_spec.info
              expect(group_info).to be_an_instance_of(VimSdk::Vim::Cluster::VmGroup)
              expect(group_info.name).to eq(vm_group_name)

            end.ordered.and_return(task)
          end
          cluster_provider.delete_vm_groups(datacenter_cluster, [vm_group_name])
        end
      end
    end
  end
end