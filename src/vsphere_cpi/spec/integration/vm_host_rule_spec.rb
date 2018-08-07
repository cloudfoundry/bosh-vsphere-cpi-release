require 'integration/spec_helper'
require 'pry-byebug'

describe 'VM Host Rules' do
  let(:rule_name) { random_drs_rule_name }
  let(:test_vm) {
    @cpi.create_vm(
    'agent-007',
    @stemcell_id,
    vm_type,
    get_network_spec,
    [],
    {}
  )}

  context 'when vm_group, host_group is defined' do
    before (:all) do
      @cpi = VSphereCloud::Cloud.new(cpi_options)
      @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
      @host_group_name = 'BOSH-CPI-test-host-group'  #can make it random, keeping it constant for test setup
      update_host_group(@cpi, @cluster_name, @host_group_name, 'add')
    end
    after(:all) do
      update_host_group(@cpi, @cluster_name, @host_group_name, 'remove')
      # delete_vm_host_rule(@cpi, @cluster_name, rule_name)
    end
    let(:vm_group_name) { "BOSH-CPI-test-vm-group" }  #can make it random, keeping it constant for test setup

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'gpu' => {'host_group' => @host_group_name, 'vm_host_affinity_rule_name' => rule_name},
        'vm_group' => vm_group_name
      }
    end
    context 'when vm_group and vm_host_rule exists' do
      # This will create vm, vm group and add the host_rule
      let!(:test_vm) {
        @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [],
          {}
        )}
      after do
        delete_vm(@cpi, test_vm)
      end

      it 'should add vm to the existing vm group and does not create a new rule' do
        cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
        rules = cluster.configuration_ex.rule
        matching_rules = rules.select { |rule| rule.name == rule_name}
        #check that rule already exists
        expect(matching_rules.count).to eq(1)
        matching_rule = matching_rules.first
        expect(matching_rule.vm_group_name).to eq(vm_group_name)
        expect(matching_rule.affine_host_group_name).to eq(@host_group_name)
        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          test_vm_resource = @cpi.vm_provider.find(test_vm)
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          rules = cluster.configuration_ex.rule
          matching_rules = rules.select { |rule| rule.name == rule_name}

          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm).to include(test_vm_resource.mob)
          expect(matching_rules.count).to eq(1)
        end
      end
    end
    context 'when vm_group, vm_host_rule does not exists' do
      it 'should add vm to the vm group and create vm host affinity rule' do
        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          rules = cluster.configuration_ex.rule
          rule = rules.find { |rule| rule.name == rule_name}

          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm.length).to eq(1)
          expect(rule.vm_group_name).to eq(vm_group_name)
          expect(rule.affine_host_group_name).to eq(@host_group_name)
        end
      end
    end

    context 'when vm is deleted' do
      it 'should delete the empty vm_group, vm was part of' do
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

      #create another context with test_vm
      it 'should not delete the vm_group if its not empty' do
        cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          expect(vm_group.vm).to include(vm.mob)
        end
        vm_groups = cluster.configuration_ex.group
        vm_group = vm_groups.find {|group| group.name == vm_group_name}
        expect(vm_group.vm).to_not be_empty
      end
    end
  end

  private

  def random_drs_rule_name
    "drs-rule-#{(0...6).map { (97 + rand(26)).chr }.join}"
  end
end