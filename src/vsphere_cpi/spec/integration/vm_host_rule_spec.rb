require 'integration/spec_helper'

describe 'Host Groups in Cluster and VM Host Rules' do
  context 'when host groups are defined in AZ' do
    before(:all) do
      @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
      @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
      @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
      @datastore_shared_pattern = fetch_property('BOSH_VSPHERE_CPI_SHARED_DATASTORE')
      @first_cluster_datastore=fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
      @first_host_group = fetch_property('BOSH_VSPHERE_CPI_FIRST_CLUSTER_FIRST_HOST_GROUP')
      @second_host_group = fetch_property('BOSH_VSPHERE_CPI_FIRST_CLUSTER_SECOND_HOST_GROUP')
      @third_host_group = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_FIRST_HOST_GROUP')
      @second_cluster_resource_pool_name = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL', @second_cluster_name)
    end

    let(:options) do
      cpi_options(
        datacenters: [{
          clusters: [
            {
              @cluster_name => {
                host_group:  @first_host_group,
              }
            }
          ]
        }]
      )
    end
    let(:cpi) do
      VSphereCloud::Cloud.new(options)
    end
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end
    let(:cluster_mob) do
      cpi.client.cloud_searcher.get_managed_object(
        VimSdk::Vim::ClusterComputeResource, name: @cluster_name)
    end
    let(:second_cluster_mob) do
      cpi.client.cloud_searcher.get_managed_object(
        VimSdk::Vim::ClusterComputeResource, name: @second_cluster_name)
    end
    let(:first_host_vm_group_name) { @first_host_group+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX }
    let(:second_host_vm_group_name) { @second_host_group+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX }
    let(:third_host_vm_group_name) { @third_host_group+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX }
    let(:first_host_group_mob) { find_host_group_mob(@first_host_group) }
    let(:second_host_group_mob) { find_host_group_mob(@second_host_group) }
    let(:third_host_group_mob) { find_host_group_mob(@third_host_group, second_cluster_mob) }
    let(:hosts_in_first_host_group) { first_host_group_mob.host.map(&:name) }
    let(:hosts_in_second_host_group) { second_host_group_mob.host.map(&:name) }
    let(:hosts_in_third_host_group) { third_host_group_mob.host.map(&:name) }

    context 'when there is only one vSphere cluster in an AZ' do
      context 'and one host_group is specified in the cluster' do
        it 'creates one VM on one of the hosts in the host groups' do
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            expect(hosts_in_first_host_group).to include(vm.mob.runtime.host.name)
            expect(vm.cluster).to eq(@cluster_name)
            expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(1)
            expect(find_vm_group_mob(@first_host_group).vm).to include(vm.mob)
            vm_host_rule = get_vm_host_affinity_rule(cluster_mob)
            expect(vm_host_rule.vm_group_name).to eq(first_host_vm_group_name)
            expect(vm_host_rule.affine_host_group_name).to eq(@first_host_group)
          end
          expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
        end
        it 'creates multiple VMs (3) one after another on one of the hosts in the host groups' do
          vm_list = []
          begin
            3.times do
              vm_id = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id).to_not be_nil
              vm_list << vm_id
              vm = cpi.vm_provider.find(vm_id)
              expect(vm).to_not be_nil
              expect(hosts_in_first_host_group).to include(vm.mob.runtime.host.name)
              expect(vm.cluster).to eq(@cluster_name)
              expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(1)
              expect(find_vm_group_mob(@first_host_group).vm).to include(vm.mob)
              vm_host_rule = get_vm_host_affinity_rule(cluster_mob)
              expect(vm_host_rule.vm_group_name).to eq(first_host_vm_group_name)
              expect(vm_host_rule.affine_host_group_name).to eq(@first_host_group)
            end
          ensure
            vm_list.each do |vm_id|
              delete_vm(cpi, vm_id)
            end
            expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
          end
        end
        it 'creates and deletes multiple VMs (5) in parallel' do
          thread_list = []
          5.times do
            thread_list << Thread.new do
              simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
                vm = cpi.vm_provider.find(vm_id)
                expect(hosts_in_first_host_group).to include(vm.mob.runtime.host.name)
                expect(vm.cluster).to eq(@cluster_name)
                expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(1)
                expect(find_vm_group_mob(@first_host_group).vm).to include(vm.mob)
                vm_host_rule = get_vm_host_affinity_rule(cluster_mob)
                expect(vm_host_rule.vm_group_name).to eq(first_host_vm_group_name)
                expect(vm_host_rule.affine_host_group_name).to eq(@first_host_group)
              end
            end
          end
          thread_list.each {|thread| thread.join}
          expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
        end
        context 'and both host in the host group cannot access ephemeral datastore' do
          let(:options) do
            cpi_options(
              datacenters: [{
                'datastore_pattern' => 'isc-cl2-ds-0'
              }]
            )
          end
          let(:cpi) do
            VSphereCloud::Cloud.new(options)
          end
          it 'raises error for no placement found' do
            expect do
              cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {}
              )
            end.to raise_error(/No valid placement found/)
            expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
          end
        end
      end
      context 'and multiple host groups are specified in same vSphere cluster' do
        let(:cpi) do
          VSphereCloud::Cloud.new(cpi_options)
        end
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [
                {
                  @cluster_name => {
                    'host_group' =>  @second_host_group,
                  },
                },
                {
                  @cluster_name => {
                    'host_group' =>  @first_host_group,
                  }
                },
              ]
            }]
          }
        end
        it 'creates VM and attach vm group host affinity rule' do
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster_name)
            # We expect VM to be created on first host group
            # because first host group has two hosts and more memory.
            expect(hosts_in_first_host_group).to include(vm.mob.runtime.host.name)
            expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(1)
            expect(find_vm_group_mob(@first_host_group).vm).to include(vm.mob)
            vm_host_rule = get_vm_host_affinity_rule(cluster_mob)
            expect(vm_host_rule.vm_group_name).to eq(first_host_vm_group_name)
            expect(vm_host_rule.affine_host_group_name).to eq(@first_host_group)
          end
          expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
        end
      end
    end

    context 'when there are  multiple vSphere cluster in an AZ' do
      context 'and one host_group is specified in each cluster' do
        let(:options) do
          cpi_options(
            datacenters: [{
              datastore_pattern: @datastore_shared_pattern,
              persistent_datastore_pattern: @datastore_shared_pattern,
              clusters: [
                { @cluster_name => { host_group: @first_host_group } },
                { @second_cluster_name => { host_group: @third_host_group } },
              ]
            }]
          )
        end
        let(:cpi) do
          VSphereCloud::Cloud.new(options)
        end
        it 'creates one VM on one of the hosts in the host groups of any cluster' do
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            expected_host_group_mob = if vm.cluster == @cluster_name
              first_host_group_mob
            else
              third_host_group_mob
            end
            vm_host = vm.mob.runtime.host.name
            expect(expected_host_group_mob.host.map(&:name)).to include(vm_host)
            vm_cluster_mob = vm.cluster == @cluster_name ? cluster_mob : second_cluster_mob
            expect(get_count_vm_host_affinity_rules(vm_cluster_mob)).to eq(1)
            expect(find_vm_group_mob(expected_host_group_mob.name, vm_cluster_mob).vm).to include(vm.mob)
            vm_host_rule = get_vm_host_affinity_rule(vm_cluster_mob)
            expect(vm_host_rule.vm_group_name).to eq(expected_host_group_mob.name+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX)
            expect(vm_host_rule.affine_host_group_name).to eq(expected_host_group_mob.name)
          end
          expect(get_count_vm_host_affinity_rules(cluster_mob) +
            get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(0)
        end
        it 'creates multiple VMs (3) one after another on one of the hosts in the host groups' do
          vm_list = []
          begin
            3.times do
              vm_id = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id).to_not be_nil
              vm_list << vm_id
              vm = cpi.vm_provider.find(vm_id)
              expect(vm).to_not be_nil
              expected_host_group_mob = if vm.cluster == @cluster_name
                first_host_group_mob
              else
                third_host_group_mob
              end
              vm_host = vm.mob.runtime.host.name
              expect(expected_host_group_mob.host.map(&:name)).to include(vm_host)
              vm_cluster_mob = vm.cluster == @cluster_name ? cluster_mob : second_cluster_mob
              expect(get_count_vm_host_affinity_rules(vm_cluster_mob)).to eq(1)
              expect(find_vm_group_mob(expected_host_group_mob.name, vm_cluster_mob).vm).to include(vm.mob)
              vm_host_rule = get_vm_host_affinity_rule(vm_cluster_mob)
              expect(vm_host_rule.vm_group_name).to eq(expected_host_group_mob.name+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX)
              expect(vm_host_rule.affine_host_group_name).to eq(expected_host_group_mob.name)
            end
          ensure
            vm_list.each do |vm_id|
              delete_vm(cpi, vm_id)
            end
            expect(get_count_vm_host_affinity_rules(cluster_mob) +
              get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(0)
          end
        end
        it 'creates and deletes multiple VMs (5) in parallel' do
          thread_list = []
          5.times do
            thread_list << Thread.new do
              simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
                vm = cpi.vm_provider.find(vm_id)
                expected_host_group_mob = if vm.cluster == @cluster_name
                  first_host_group_mob
                else
                  third_host_group_mob
                end
                vm_host = vm.mob.runtime.host.name
                expect(expected_host_group_mob.host.map(&:name)).to include(vm_host)
                vm_cluster_mob = vm.cluster == @cluster_name ? cluster_mob : second_cluster_mob
                expect(get_count_vm_host_affinity_rules(vm_cluster_mob)).to eq(1)
                expect(find_vm_group_mob(expected_host_group_mob.name, vm_cluster_mob).vm).to include(vm.mob)
                vm_host_rule = get_vm_host_affinity_rule(vm_cluster_mob)
                expect(vm_host_rule.vm_group_name).to eq(expected_host_group_mob.name+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX)
                expect(vm_host_rule.affine_host_group_name).to eq(expected_host_group_mob.name)
              end
            end
          end
          thread_list.each {|thread| thread.join}
          expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
        end
        context 'and all hosts in first cluster host group are in maintenance mode' do
          before do
            turn_maintenance_on_for_hosts(cpi, first_host_group_mob.host)
          end
          after do
            turn_maintenance_off_for_hosts(cpi, first_host_group_mob.host)
          end
          it 'creates one VM on one of the hosts in the host groups of second cluster' do
            simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_host = vm.mob.runtime.host.name
              expect(third_host_group_mob.host.map(&:name)).to include(vm_host)
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(1)
              expect(find_vm_group_mob(@third_host_group, second_cluster_mob).vm).to include(vm.mob)
              vm_host_rule = get_vm_host_affinity_rule(second_cluster_mob)
              expect(vm_host_rule.vm_group_name).to eq(third_host_vm_group_name)
              expect(vm_host_rule.affine_host_group_name).to eq(@third_host_group)
            end
            expect(get_count_vm_host_affinity_rules(cluster_mob) +
              get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(0)
          end
          it 'creates and deletes multiple VMs (5) in parallel' do
            thread_list = []
            5.times do
              thread_list << Thread.new do
                simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
                  vm = cpi.vm_provider.find(vm_id)
                  vm_host = vm.mob.runtime.host.name
                  expect(third_host_group_mob.host.map(&:name)).to include(vm_host)
                  expect(vm.cluster).to eq(@second_cluster_name)
                  vm_cluster_mob = second_cluster_mob
                  expect(get_count_vm_host_affinity_rules(vm_cluster_mob)).to eq(1)
                  expect(find_vm_group_mob(@third_host_group, vm_cluster_mob).vm).to include(vm.mob)
                  vm_host_rule = get_vm_host_affinity_rule(vm_cluster_mob)
                  expect(vm_host_rule.vm_group_name).to eq(third_host_vm_group_name)
                  expect(vm_host_rule.affine_host_group_name).to eq(@third_host_group)
                end
              end
            end
            thread_list.each {|thread| thread.join}
            expect(get_count_vm_host_affinity_rules(cluster_mob)).to eq(0)
          end
        end
      end
      context 'and one of the cluster has host group and other has resource pool' do
        let(:options) do
          cpi_options(
            datacenters: [{
              'datastore_pattern' => @datastore_shared_pattern,
              'persistent_datastore_pattern' => @datastore_shared_pattern,
              clusters: [
                { @cluster_name => { host_group: @second_host_group, } },
                { @second_cluster_name => { resource_pool: @second_cluster_resource_pool_name, } },
              ]
            }]
          )
        end
        let(:cpi) do
          VSphereCloud::Cloud.new(options)
        end
        it 'creates one VM on the second cluster without host group\
            (as resource pool has more memory available than host group)' do
          simple_vm_lifecycle(cpi, '', vm_type, get_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@second_cluster_name)
          end
          expect(get_count_vm_host_affinity_rules(cluster_mob) +
            get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(0)
        end
        it 'creates multiple VMs (3) one after another on the second cluster\'s resource pool' do
          vm_list = []
          begin
            3.times do
              vm_id = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id).to_not be_nil
              vm_list << vm_id
              vm = cpi.vm_provider.find(vm_id)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@second_cluster_name)
            end
          ensure
            vm_list.each do |vm_id|
              delete_vm(cpi, vm_id)
            end
            expect(get_count_vm_host_affinity_rules(cluster_mob) +
              get_count_vm_host_affinity_rules(second_cluster_mob)).to eq(0)
          end
        end
      end
    end
  end

  private

  def find_vm_group_mob(host_group_name, clustermob=cluster_mob)
    clustermob.configuration_ex.group.find do |group|
      group.name == (host_group_name+VSphereCloud::Resources::Cluster::CLUSTER_VM_GROUP_SUFFIX)
    end
  end

  def find_host_group_mob(host_group_name, clustermob=cluster_mob)
    clustermob.configuration_ex.group.find do |group|
      group.name == host_group_name && group.is_a?(VimSdk::Vim::Cluster::HostGroup)
    end
  end

  def get_vm_host_affinity_rule(cluster_mob)
    # return ing the first as we do not expect more rules to be present while
    # this test is in progress.
    cluster_mob.configuration_ex.rule.select do |rule_info|
      rule_info.is_a?(VimSdk::Vim::Cluster::VmHostRuleInfo)
    end.first
  end
end