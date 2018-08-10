require 'integration/spec_helper'

describe 'VM Groups' do
  let(:test_vm) {
    @cpi.create_vm(
    'agent-007',
    @stemcell_id,
    vm_type,
    get_network_spec,
    [],
    {}
  )}

  context 'when vm_group is defined' do
    before (:all) do
      @cpi = VSphereCloud::Cloud.new(cpi_options)
      @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    end
    let(:vm_group_name) { "BOSH-CPI-test-vm-group" }

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'vm_group' => vm_group_name
      }
    end

    context 'when vm_group exists' do
      # This will create vm, vm group and add the host_rule
      let(:test_vm) {
        @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [],
          {}
        )}
      before do
        @test_vm_resource = @cpi.vm_provider.find(test_vm)
        @cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
      end

      after do
        delete_vm(@cpi, test_vm)
      end

      it 'should add vm to the existing vm group' do
        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          vm_groups = @cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}

          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm).to include(@test_vm_resource.mob)
        end
      end
      context 'when vm is deleted' do
        it 'should not delete the vm_group because its not empty' do
          simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            vm_groups = @cluster.configuration_ex.group

            vm_group = vm_groups.find {|group| group.name == vm_group_name}
            expect(vm_group.vm).to include(vm.mob)
            expect(vm_group.vm).to include(@test_vm_resource.mob)
          end
          vm_groups = @cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          expect(vm_group.vm).to include(@test_vm_resource.mob)
        end
      end
    end

    context 'when vm_group does not exists' do
      it 'should add vm to the vm group' do
        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}

          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm.length).to eq(1)
        end
      end

      context 'when vm is deleted' do
        it 'should delete the vm_group' do
          cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
          simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            vm_groups = cluster.configuration_ex.group
            vm_group = vm_groups.find {|group| group.name == vm_group_name}
            expect(vm_group.vm).to include(vm.mob)
          end
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          expect(vm_group).to be_nil
        end
      end
    end
  end
end