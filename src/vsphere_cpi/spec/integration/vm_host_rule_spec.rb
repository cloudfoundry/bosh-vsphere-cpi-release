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
    end
    let(:vm_group_name) { "BOSH-CPI-test-vm-group" }  #can make it random, keeping it constant for test setup

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'gpu' => {'vm_group' => vm_group_name, 'host_group' => @host_group_name, 'vm_host_affinity_rule_name' => rule_name}
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
        # There should be no need to delete the rule as delete_vm should take care of this in 1 of the following ways
        # find rules for the vm (cluster.find_rules_for_vm) & corresponding vm_group, delete vm_group if it has only this vm
        # OR find vm.cluster.groups and collect vm_groups this vm is part of, delete_vm and then refetch cluster.groups
        # delete the vm_groups(retrieved in previous call) if they are empty
        #  delete_vm_host_rule(@cpi, @cluster_name, rule_name)
      end

      it 'should add vm to the existing vm group and does not create a new rule' do
        cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
        rules = cluster.configuration_ex.rule
        expect(rules).not_to be_empty
        matching_rules = rules.select { |rule| rule.name == rule_name}
        expect(matching_rules.count).to eq(1)
        matching_rule = matching_rules.first
        expect(matching_rule.vm_group_name).to eq(vm_group_name)
        expect(matching_rule.affine_host_group_name).to eq(@host_group_name)

        simple_vm_lifecycle(@cpi, '', vm_type, get_network_spec) do |vm_id|
          vm = @cpi.vm_provider.find(vm_id)
          test_vm_resource = @cpi.vm_provider.find(vm_id)
          vm_groups = cluster.configuration_ex.group
          vm_group = vm_groups.find {|group| group.name == vm_group_name}
          expect(vm_group).to_not be_nil
          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm).to include(test_vm_resource.mob)
          rules = cluster.configuration_ex.rule
          expect(rules).not_to be_empty
          matching_rules = rules.select { |rule| rule.name == rule_name}
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
          expect(vm_group).to_not be_nil
          expect(vm_group.vm).to include(vm.mob)
          expect(vm_group.vm.length).to eq(1)

          rules = cluster.configuration_ex.rule
          expect(rules).not_to be_empty
          rule = rules.find { |rule| rule.name == rule_name}
          expect(rule.vm_group_name).to eq(vm_group_name)
          expect(rule.affine_host_group_name).to eq(@host_group_name)
        end
      end
    end
  end

  private

  def random_drs_rule_name
    "drs-rule-#{(0...6).map { (97 + rand(26)).chr }.join}"
  end

end