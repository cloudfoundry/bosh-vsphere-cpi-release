require 'spec_helper'
require 'nsxt_policy_client/nsxt_policy_client'

describe VSphereCloud::NSXTPolicyProvider, fake_logger: true do
  let(:client) { instance_double(NSXTPolicy::ApiClient) }
  subject(:nsxt_policy_provider) do
    described_class.new(client)
  end

  let(:policy_group_api) { instance_double(NSXTPolicy::PolicyInventoryGroupsGroupsApi) }
  before do
    allow(nsxt_policy_provider).to receive(:policy_group_api).and_return(policy_group_api)
  end

  let(:policy_load_balancer_pools_api) { instance_double(NSXTPolicy::PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerPoolsApi) }
  before do
    allow(nsxt_policy_provider).to receive(:policy_load_balancer_pools_api).and_return(policy_load_balancer_pools_api)
  end

  let(:search_api) { instance_double(NSXTPolicy::SearchSearchAPIApi) }
  before do
    allow(nsxt_policy_provider).to receive(:search_api).and_return(search_api)
  end

  let(:policy_segment_ports_api) { instance_double(NSXTPolicy::PolicyNetworkingConnectivitySegmentsPortsApi) }
  before do
    allow(nsxt_policy_provider).to receive(:policy_segment_ports_api).and_return(policy_segment_ports_api)
  end

  let(:policy_infra_realized_state_api) { instance_double(NSXTPolicy::PolicyInfraRealizedStateApi) }
  before do
    allow(nsxt_policy_provider).to receive(:policy_infra_realized_state_api).and_return(policy_infra_realized_state_api)
    allow(policy_infra_realized_state_api).to receive(:list_virtual_machines_on_enforcement_point).and_return(
        instance_double(NSXTPolicy::SearchResponse, results: [{external_id: 'some-vm-external-id'}])
    )
  end

  let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: "some-vm-cid") }
  let(:group1) { instance_double(NSXTPolicy::Group,
                                 expression: [],
                                 id: 'some-group-1')}
  let(:group2) { instance_double(NSXTPolicy::Group,
                                 expression: [],
                                 id: 'some-group-2')}


  let(:conjunction_expression) {
    NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                        conjunction_operator: 'OR',
                                        id: 'conjunction-some-vm-cid-0')

  }

  describe '#add_vm_to_groups' do
    let(:groups) { ['some-group-1', 'some-group-2'] }
    before do
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-1").and_return(group1)
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-2").and_return(group2)
    end

    context 'when groups are empty' do
      it 'adds vm to groups' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-2',
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        expect(group1.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['some-vm-external-id'])])
        expect(group2.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['some-vm-external-id'])])
      end
    end

    context 'when groups are not empty' do
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     id: 'some-group-1',
                                     expression: [NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id'])],
                                     )}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     id: 'some-group-2',
                                     expression: [NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id'])],
                                     )}

      it 'adds vm to groups' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-2',
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        expect(group1.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id', 'some-vm-external-id'])])
        expect(group2.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id', 'some-vm-external-id'])])
      end
    end

    context 'when group has 500 vms' do
      let(:existing_external_ids) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-#{i}"
        end
        external_ids
      end
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     id: 'some-group-1',
                                     expression: [NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: existing_external_ids)],
                                     )}

      it 'makes a new criteria for external ids with conjunction operator' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        nsxt_policy_provider.add_vm_to_groups(vm, ['some-group-1'])
        expect(group1.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: existing_external_ids),
                                                  conjunction_expression,
                                                  NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['some-vm-external-id'])])
      end
    end

    context 'when one of the criterias in a group has 500 vms' do
      let(:existing_external_ids_500) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-#{i}"
        end
        external_ids
      end
      let(:existing_external_ids_200) do
        external_ids = []
        200.times do |i|
          external_ids << "some-external-id-#{i}"
        end
        external_ids
      end
      let(:existing_expression_500) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: existing_external_ids_500)
      end
      let(:group1) do
        instance_double(NSXTPolicy::Group,
                        id: 'some-group-1',
                        expression: [existing_expression_500,
                                     conjunction_expression,
                                     NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                          member_type: 'VirtualMachine',
                                                                          external_ids: existing_external_ids_200)],
        )
      end

      it 'adds vm to the expression with less than 500 vms' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        nsxt_policy_provider.add_vm_to_groups(vm, ['some-group-1'])
        expect(group1.expression).to match_array([existing_expression_500,
                                                  conjunction_expression,
                                                  NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                      member_type: 'VirtualMachine',
                                                                                      external_ids: existing_external_ids_200.append('some-vm-external-id'))])
      end
    end

    context 'when two of the criterias in a group has 500 vms' do
      let(:existing_external_ids_500_1) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-#{i}-1"
        end
        external_ids
      end
      let(:existing_external_ids_500_2) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-#{i}-2"
        end
        external_ids
      end

      let(:existing_expression_500_1) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: existing_external_ids_500_1)
      end
      let(:existing_expression_500_2) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: existing_external_ids_500_2)
      end
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_external_ids_500_1, conjunction_expression, existing_external_ids_500_2],
                                     id: 'some-group-1')}

      it 'generates unique conjunction expression' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        nsxt_policy_provider.add_vm_to_groups(vm, ['some-group-1'])
        expect(group1.expression).to match_array([existing_external_ids_500_1,
                                                  conjunction_expression,
                                                  existing_external_ids_500_2,
                                                  NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                                                                      conjunction_operator: 'OR',
                                                                                      id: 'conjunction-some-vm-cid-1'),
                                                  NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['some-vm-external-id'])])
      end
    end

    context 'when groups have other criterias' do
      let(:existing_expression) {
        NSXTPolicy::Condition.new(resource_type: 'Condition',
                                  key: 'Name',
                                  operator: 'EQUALS',
                                  member_type: 'VirtualMachine',
                                  value: 'existing-vm-criteria')
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: 'some-group-1')}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: 'some-group-2')}


      it 'adds vm to groups with conjunction operator' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-2',
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        new_expression = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                               member_type: 'VirtualMachine',
                                                               external_ids: ['some-vm-external-id'])
        expect(group1.expression).to match_array([existing_expression,
                                                  conjunction_expression,
                                                  new_expression,
                                                 ])
        expect(group2.expression).to match_array([existing_expression,
                                                  conjunction_expression,
                                                  new_expression,
                                                 ])
      end
    end

    context 'when vm is already in one of the criterias in a group' do
      let(:existing_expression_1) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-other-external-id'])
      }
      let(:existing_expression_2) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-vm-external-id'])
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression_1, conjunction_expression, existing_expression_2],
                                     id: 'some-group-1')}

      it 'does not add it' do
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.add_vm_to_groups(vm, ['some-group-1'])
      end
    end
  end

  describe '#remove_vm_from_groups' do
    before do
      groups_list_result = instance_double(NSXTPolicy::GroupListResult, results: [group1, group2], cursor: nil)
      allow(policy_group_api).to receive(:list_group_for_domain_0).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN).and_return(groups_list_result)
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-1").and_return(group1)
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-2").and_return(group2)
    end

    context 'when groups are empty' do
      it 'does not delete from groups' do
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.remove_vm_from_groups(vm)
      end
    end

    context 'when groups have vm' do
      let(:vm_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-vm-external-id'])
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [vm_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [vm_expression],
                                     id: "some-group-2")}

      it 'removes vm from groups' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
        nsxt_policy_provider.remove_vm_from_groups(vm)
        expect(group1.expression).to eq([])
        expect(group2.expression).to eq([])
      end
    end

    context 'when group has several vms' do
      let(:existing_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-vm-external-id', 'another-vm-external-id'])
      }
      let(:other_expression) {
        NSXTPolicy::Condition.new(resource_type: 'Condition',
                                  key: 'Name',
                                  operator: 'EQUALS',
                                  member_type: 'VirtualMachine',
                                  value: 'existing-vm-criteria')
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [other_expression,
                                                  conjunction_expression,
                                                  existing_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: "some-group-2")}

      it 'removes vm from groups with conjunction operator' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
        nsxt_policy_provider.remove_vm_from_groups(vm)
        expect(group1.expression).to eq([other_expression,
                                         conjunction_expression,
                                         NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                              member_type: 'VirtualMachine',
                                                                              external_ids: ['another-vm-external-id'])])
        expect(group2.expression).to eq([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                              member_type: 'VirtualMachine',
                                                                              external_ids: ['another-vm-external-id'])])
      end
    end

    context 'when group does not have vms' do
      let(:existing_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['another-vm-external-id'])
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [],
                                     id: "some-group-2")}

      it 'does not remove from groups' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.remove_vm_from_groups(vm)
        expect(group1.expression).to match_array([existing_expression])
      end
    end

    context 'when group has only 1 vm' do
      let(:existing_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-vm-external-id'])
      }
      let(:another_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['another-vm-external-id'])
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression, conjunction_expression, another_expression],
                                     id: "some-group-2")}

      it 'removes the whole expression with conjunction expression' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
        nsxt_policy_provider.remove_vm_from_groups(vm)
        expect(group1.expression).to match_array([])
        expect(group2.expression).to match_array([another_expression])
      end

      context "the first vm is removed before others in the same external id expression" do
        let(:conjunction_expression) {
          NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                              conjunction_operator: 'OR',
                                              id: 'conjunction-some-vm-not-matching-cid')
        }
        let(:group1) { instance_double(NSXTPolicy::Group,
                                       expression: [another_expression, conjunction_expression, existing_expression],
                                       id: "some-group-1")}
        it 'removes the whole expression with conjunction expression' do
          expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
          expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
          nsxt_policy_provider.remove_vm_from_groups(vm)
          expect(group1.expression).to match_array([another_expression])
          expect(group2.expression).to match_array([another_expression])
        end
      end
    end
  end

  describe '#add_vm_to_server_pools' do
    let(:server_pools) do
      [
        {
          'name' => 'some-server-pool-name',
          'port' => 80
        }
      ]
    end
    let(:original_nsxt_pool) do
      NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name")
    end
    let(:updated_nsxt_pool) do
      NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name", members: [NSXTPolicy::LBPoolMember.new(port: 80, ip_address: "9.8.7.6")])
    end

    before do
      allow(vm).to receive_message_chain(:mob, :guest, :ip_address).and_return("9.8.7.6")
      allow(policy_load_balancer_pools_api).to receive(:read_lb_pool_0).
        with("some-server-pool-id").and_return(original_nsxt_pool)
      allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).
        and_return([original_nsxt_pool])
    end

    context 'when pool is empty' do
      it 'adds vm to pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-server-pool-id", updated_nsxt_pool)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when pool has existing members' do
      let(:original_nsxt_pool) do
        NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name", members: [NSXTPolicy::LBPoolMember.new(ip_address: "5.6.4.3")])
      end
      let(:updated_nsxt_pool) do
        NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name", members: [NSXTPolicy::LBPoolMember.new(ip_address: "5.6.4.3"), NSXTPolicy::LBPoolMember.new(port: 80, ip_address: "9.8.7.6")])
      end

      it 'adds vm to the pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-server-pool-id", updated_nsxt_pool)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when there are many pools' do
      let(:server_pools) do
        [
          {
            'name' => 'some-server-pool-name',
            'port' => 80
          },
          {
            'name' => 'some-other-server-pool-name',
            'port' => 8080
          }
        ]
      end
      let(:second_updated_nsxt_pool) do
        NSXTPolicy::LBPool.new(id: "some-other-server-pool-id", display_name: "some-other-server-pool-name", members: [NSXTPolicy::LBPoolMember.new(port: 8080, ip_address: "9.8.7.6")])
      end
      let(:original_second_pool) do
        NSXTPolicy::LBPool.new(id: "some-other-server-pool-id", display_name: "some-other-server-pool-name")
      end

      before do
        allow(policy_load_balancer_pools_api).to receive(:read_lb_pool_0).
          with("some-other-server-pool-id").and_return(original_second_pool)
        allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).
            and_return([original_nsxt_pool, original_second_pool])
      end

      it 'adds vm to all pools' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-server-pool-id", updated_nsxt_pool)
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-other-server-pool-id", second_updated_nsxt_pool)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end

      context "some pools have identical display_names (duplicates)" do
        before do
          allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).
            and_return([original_nsxt_pool, original_second_pool, duplicate_named_nsxt_pool])
        end

        let(:duplicate_named_nsxt_pool) do
          NSXTPolicy::LBPool.new(id: "duplicate-named-server-pool-id", display_name: "some-server-pool-name")
        end

        let(:server_pools_no_duplicates) do
          [
            {
              'name' => 'some-other-server-pool-name',
              'port' => 8080
            }
          ]
        end

        it 'raises an error when attempting to add the VM to one of the identically-named pools' do
          expect { nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools) }.to raise_error(VSphereCloud::DuplicateLBPoolDisplayName)
        end

        it 'does not raise an error when it tries to add the VM to a uniquely-named pool' do
          expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
            with("some-other-server-pool-id", original_second_pool)

          expect { nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools_no_duplicates) }.to_not raise_error
        end
      end
    end

    context 'when there is a conflict' do
      it 'retries' do
        conflict_response = NSXTPolicy::ApiCallError.new(code: 409, response_body: 'The object was modified by somebody else')
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args).and_raise(conflict_response).twice
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when there is a precondition that failed' do
      it 'retries' do
        conflict_response = NSXTPolicy::ApiCallError.new(code: 412, response_body: 'PreconditionFailed')
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args).and_raise(conflict_response).twice
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when the pool does not exist' do
      let(:non_existent_server_pools) do
        [
          {
            'name' => 'does-not-exist',
            'port' => 80
          }
        ]
        end
      it 'returns an error' do
        expect { nsxt_policy_provider.add_vm_to_server_pools(vm, non_existent_server_pools) }.to raise_error(VSphereCloud::ServerPoolsNotFound)
      end
    end
  end

  describe '#remove_vm_from_server_pools' do
    let(:vm_ip_address) { '192.168.111.5' }
    let(:pool_member) { NSXTPolicy::LBPoolMember.new(port: 80, ip_address: vm_ip_address) }
    let(:server_pool_1) do
      NSXTPolicy::LBPool.new(id: 'some-server-pool-id', display_name: 'some-server-pool-name',  members: [pool_member])
    end
    let(:server_pool_2) do
      NSXTPolicy::LBPool.new(id: 'some-other-server-pool-id', display_name: 'some-other-server-pool-name', )
    end

    before do
      allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).and_return([server_pool_1, server_pool_2])
    end

    it 'removes VM from all server pools' do
      expected_server_pool = NSXTPolicy::LBPool.new(id: 'some-server-pool-id', display_name: 'some-server-pool-name', members: [])
      expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with('some-server-pool-id', expected_server_pool).once
      nsxt_policy_provider.remove_vm_from_server_pools(vm_ip_address)
    end
  end

  describe '#update_vm_metadata_on_segment_ports' do
    let(:metadata) { { 'id' => 'new-bosh-id', 'name' => 'new-bosh-name' } }
    let(:id_hex) { Digest::SHA1.hexdigest('new-bosh-id') }
    let(:vm) { instance_double(VSphereCloud::Resources::VM, get_nsxt_segment_vif_list: [['segment-name-1', 'attachment-1'], ['segment-name-2', 'attachment-2']]) }
    let(:search_result1) do
      instance_double(
        NSXTPolicy::SearchResponse,
        results: [id: 'segment-port-id-1',
                  path: '/infra/segments/segment-id-1/ports/segment-port-id-1',
                  parent_path: '/infra/segments/segment-id-1']
      )
    end
    let(:search_result2) do
      instance_double(
        NSXTPolicy::SearchResponse,
        results: [id: 'segment-port-id-2',
                  path: '/infra/segments/segment-id-2/ports/segment-port-id-2',
                  parent_path: '/infra/segments/segment-id-2']
      )
    end
    let(:segment_port1) { NSXTPolicy::SegmentPort.new(id: 'segment-port-id-1', tags: existing_tags) }
    let(:segment_port2) { NSXTPolicy::SegmentPort.new(id: 'segment-port-id-2', tags: existing_tags) }
    let(:existing_tags) { nil }

    before do
      allow(search_api).to receive(:query_search).with('attachment.id:attachment-1').and_return(search_result1)
      allow(search_api).to receive(:query_search).with('attachment.id:attachment-2').and_return(search_result2)
    end

    context 'when segment port is scoped under the tier-1 router' do
      before do
        allow(policy_segment_ports_api).to receive(:get_infra_segment_port).with('segment-id-1', 'segment-port-id-1').and_return(segment_port1)
        allow(policy_segment_ports_api).to receive(:get_infra_segment_port).with('segment-id-2', 'segment-port-id-2').and_return(segment_port2)
      end

      context 'when segment ports do not have any tags' do
        let(:new_tags) { [
          NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
          NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
        ] }

        it 'adds the id tag' do
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-2')
            expect(port_id).to eq('segment-port-id-2')
            expect(segment_port.tags).to eq(new_tags)
          end

          nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
        end
      end

      context 'when logical ports have non id tags' do
        let(:non_id_tag) { NSXTPolicy::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data') }
        let(:existing_tags) { [non_id_tag] }
        let(:new_tags) { [
          non_id_tag,
          NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
          NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
        ] }

        it 'sets the id tag' do
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-2')
            expect(port_id).to eq('segment-port-id-2')
            expect(segment_port.tags).to eq(new_tags)
          end

          nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
        end
      end

      context 'when segment ports have one id tag' do
        let(:old_vm_id_tag) { NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('old-bosh-id')) }
        let(:non_id_tag) { NSXTPolicy::Tag.new('scope' => 'bosh/fake', 'tag' => 'fake-data') }
        let(:existing_tags) { [non_id_tag, old_vm_id_tag] }
        let(:new_tags) { [
          non_id_tag,
          NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
          NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
        ] }

        it 'consolidates the existing id tags and sets it' do
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_id, port_id, segment_port|
            expect(segment_id).to eq('segment-id-2')
            expect(port_id).to eq('segment-port-id-2')
            expect(segment_port.tags).to eq(new_tags)
          end

          nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
        end
      end

      context 'when segment ports more than one id tag' do
        let(:old_vm_id_tag) { NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest('old-bosh-id')) }
        let(:existing_tags) { [NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex), old_vm_id_tag] }

        it 'raises an error' do
          expect do
            nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
          end.to raise_error(VSphereCloud::InvalidSegmentPortError)
        end
      end

      context 'when metadata does not have an id' do
        it 'does not raise an error' do
          expect do
            nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, {})
          end.to_not raise_error
        end
      end

      context 'when metadata is nil' do
        it 'does not raise an error' do
          expect do
            nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, nil)
          end.to_not raise_error
        end
      end
    end

    context 'when segment port is not scoped under the tier-1 router' do
      let(:search_result1) do
        instance_double(
          NSXTPolicy::SearchResponse,
          results: [id: 'segment-port-id-1',
                    path: '/infra/tier-1s/tier-1-name-1/segments/segment-id-1/ports/segment-port-id-1',
                    parent_path: '/infra/tier-1s/tier-1-name-1/segments/segment-id-1']
        )
      end
      let(:search_result2) do
        instance_double(
          NSXTPolicy::SearchResponse,
          results: [id: 'segment-port-id-2',
                    path: '/infra/tier-1s/tier-1-name-2/segments/segment-id-2/ports/segment-port-id-2',
                    parent_path: '/infra/tier-1s/tier-1-name-2/segments/segment-id-2']
        )
      end

      let(:new_tags) { [
        NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
        NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
      ] }

      before do
        allow(policy_segment_ports_api).to receive(:get_tier1_segment_port_0).with('tier-1-name-1', 'segment-id-1', 'segment-port-id-1').and_return(segment_port1)
        allow(policy_segment_ports_api).to receive(:get_tier1_segment_port_0).with('tier-1-name-2', 'segment-id-2', 'segment-port-id-2').and_return(segment_port2)
      end

      it 'adds the id tag' do
        expect(policy_segment_ports_api).to receive(:patch_tier1_segment_port_0).once.ordered do |tier1_name, segment_id, port_id, segment_port|
          expect(tier1_name).to eq('tier-1-name-1')
          expect(segment_id).to eq('segment-id-1')
          expect(port_id).to eq('segment-port-id-1')
          expect(segment_port.tags).to eq(new_tags)
        end
        expect(policy_segment_ports_api).to receive(:patch_tier1_segment_port_0).once.ordered do |tier1_name, segment_id, port_id, segment_port|
          expect(tier1_name).to eq('tier-1-name-2')
          expect(segment_id).to eq('segment-id-2')
          expect(port_id).to eq('segment-port-id-2')
          expect(segment_port.tags).to eq(new_tags)
        end

        nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
      end
    end
  end
end