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

  let(:policy_group_members_api) { instance_double(NSXTPolicy::PolicyInventoryGroupsGroupMembersApi) }
  before do
    allow(nsxt_policy_provider).to receive(:policy_group_members_api).and_return(policy_group_members_api)
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
  let(:group1ref) { instance_double(NSXTPolicy::PolicyResourceReferenceForEP,
                                    target_id: '/something/some-domain/groups/some-group-1', path: '/something/some-domain/groups/some-group-1')}
  let(:group2ref) { instance_double(NSXTPolicy::PolicyResourceReferenceForEP,
                                    target_id: '/something/some-domain/groups/some-group-2', path: '/something/some-domain/groups/some-group-2')}


  let(:conjunction_expression) {
    NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                        conjunction_operator: 'OR',
                                        id: 'conjunction-some-vm-cid-0')

  }

  describe '#add_vm_to_groups' do
    let(:group_1) { double(NSXTPolicy::Group, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1", expression: []) }
    let(:group_2) { double(NSXTPolicy::Group, id: 'fake-nsgroup-2-id', display_name: "fake nsgroup 2", expression: []) }
    let(:groups) { [group_1, group_2] }

    context 'when groups do not have any existing members' do
      it 'adds vm to groups' do
        expected_expression = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['some-vm-external-id'])
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([expected_expression])
          end

        expect(policy_group_api).to receive(:update_group_for_domain).
          with( VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_2.id, group_2) do |domain, group_id, group|
            expect(group.expression).to eq([expected_expression])
          end

        nsxt_policy_provider.add_vm_to_groups(vm, groups)
      end
    end

    context 'when groups have existing members expressed as an ExternalIDExpression' do
      before do
        allow(group_1).to receive(:expression).and_return([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['existing-vm-external-id'])])
        #this expression must be a diff obj than above, as the above gets mutated in the test to include the vm id.
        allow(group_2).to receive(:expression).and_return([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['existing-vm-external-id'])])
      end

      it 'adds vm to existing members' do
        expected_expression = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['existing-vm-external-id', 'some-vm-external-id'])
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([expected_expression])
          end

        expect(policy_group_api).to receive(:update_group_for_domain).
          with( VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_2.id, group_2) do |domain, group_id, group|
            expect(group.expression).to eq([expected_expression])
          end

        nsxt_policy_provider.add_vm_to_groups(vm, groups)
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
      let(:first_500_vms) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids)
      end

      before do
        allow(group_1).to receive(:expression).and_return([first_500_vms])
      end

      it 'makes a new criteria for the ids of additional VMs past 500 external ids with conjunction operator' do
        additional_vm = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['some-vm-external-id'])
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([first_500_vms, conjunction_expression, additional_vm])
          end
        nsxt_policy_provider.add_vm_to_groups(vm, [group_1])
      end
    end

    context 'when there are criterias w/ 500 and 200 vms respectively' do
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
          external_ids << "some-external-id-two-#{i}"
        end
        external_ids
      end
      let(:first_500_vms) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids_500)
      end
      let(:next_200_vms) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids_200)
      end

      before do
        allow(group_1).to receive(:expression).and_return([first_500_vms, conjunction_expression, next_200_vms])
      end

      it 'adds vm to the expression with less than 500 vms' do
        next_201_vms = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids_200.dup.append('some-vm-external-id'))
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([first_500_vms, conjunction_expression, next_201_vms])
          end
        nsxt_policy_provider.add_vm_to_groups(vm, [group_1])
      end
    end

    context 'when two of the criterias in a group has 500 vms' do
      let(:existing_external_ids_500_1) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-#{i}"
        end
        external_ids
      end
      let(:existing_external_ids_500_2) do
        external_ids = []
        500.times do |i|
          external_ids << "some-external-id-two-#{i}"
        end
        external_ids
      end

      let(:first_500_vms) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids_500_1)
      end
      let(:next_500_vms) do
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: existing_external_ids_500_2)
      end

      before do
        allow(group_1).to receive(:expression).and_return([first_500_vms, conjunction_expression, next_500_vms])
      end

      it 'generates unique conjunction expression and places vm in third expression group' do
        conjunction_with_vm = NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator', conjunction_operator: 'OR', id: 'conjunction-some-vm-cid-1')
        new_vm_member =  NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression', member_type: 'VirtualMachine', external_ids: ['some-vm-external-id'])
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([first_500_vms, conjunction_expression, next_500_vms, conjunction_with_vm, new_vm_member])
          end
        nsxt_policy_provider.add_vm_to_groups(vm, [group_1])
      end
    end

    context 'when existing expressions are not of type ExternalIDExpression' do
      let(:existing_expression) {
        NSXTPolicy::Condition.new(resource_type: 'Condition',
                                  key: 'Name',
                                  operator: 'EQUALS',
                                  member_type: 'VirtualMachine',
                                  value: 'existing-vm-criteria')
      }

      before do
        allow(group_1).to receive(:expression).and_return([existing_expression])
      end


      it 'adds vm to groups with conjunction operator' do
        new_vm_expression = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                               member_type: 'VirtualMachine',
                                                               external_ids: ['some-vm-external-id'])
        expect(policy_group_api).to receive(:update_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_1.id, group_1) do |domain, group_id, group|
            expect(group.expression).to eq([existing_expression, conjunction_expression, new_vm_expression])
          end
        nsxt_policy_provider.add_vm_to_groups(vm, [group_1])

      end
    end

    context 'when vm is already in one of the existing ExternalIDExpressions in a group' do
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

      before do
        allow(group_1).to receive(:expression).and_return([existing_expression_1, conjunction_expression, existing_expression_2])
      end

      it 'does not add it' do
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.add_vm_to_groups(vm, [group_1])
      end
    end
  end

  describe '#remove_vm_from_groups' do
    let(:groups_result) { instance_double(NSXTPolicy::PolicyResourceReferenceForEPListResult, results: [group1ref, group2ref], cursor: nil) }
    before do
      allow(policy_group_members_api).to receive(:get_groups_for_vm).and_return(groups_result)
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-1").and_return(group1)
      allow(policy_group_api).to receive(:read_group_for_domain).
          with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, "some-group-2").and_return(group2)
    end

    context 'when groups are empty' do
      let(:groups_result) { instance_double(NSXTPolicy::PolicyResourceReferenceForEPListResult, results: [], cursor: nil) }
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

    context 'when group does not have vm condition even though it is a group member somehow' do
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
       [server_pool_1, 80]
      ]
    end

    let(:server_pool_1) {
      NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name")
    }

    before do
      allow(vm).to receive_message_chain(:mob, :guest, :ip_address).and_return("9.8.7.6")
    end

    context 'when pool is empty' do
      it 'adds vm to pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0) do |server_pool_id, server_pool|
          expect(server_pool_id).to eq(server_pool_1.id)
          expect(server_pool.members).to contain_exactly(an_object_having_attributes(ip_address: "9.8.7.6", port: 80, display_name: "some-vm-cid"))
        end
        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when pool has existing members' do
      let(:server_pool_1) do
        NSXTPolicy::LBPool.new(id: "some-server-pool-id", display_name: "some-server-pool-name", members: [NSXTPolicy::LBPoolMember.new(ip_address: "5.6.4.3")])
      end

      it 'adds vm to the pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0) do |server_pool_id, server_pool|
          expect(server_pool_id).to eq(server_pool_1.id)
          expect(server_pool.members).to contain_exactly(
            an_object_having_attributes(ip_address: "9.8.7.6", port: 80, display_name: "some-vm-cid"),
            an_object_having_attributes(ip_address:"5.6.4.3")
          )
        end

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when there are many pools' do
    let(:server_pools) do
      [
       [server_pool_1, 80],
       [server_pool_2, 8080]
      ]
    end
      let(:server_pool_2) {
        NSXTPolicy::LBPool.new(id: "some-server-pool-id-2", display_name: "some-server-pool-name-2")
      }

      it 'adds vm to all pools' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0) do |server_pool_id, server_pool|
          expect(server_pool_id).to eq(server_pool_1.id)
          expect(server_pool.members).to contain_exactly(
            an_object_having_attributes(ip_address: "9.8.7.6", port: 80, display_name: "some-vm-cid"),
          )
        end
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0) do |server_pool_id, server_pool|
          expect(server_pool_id).to eq(server_pool_2.id)
          expect(server_pool.members).to contain_exactly(
            an_object_having_attributes(ip_address: "9.8.7.6", port: 8080, display_name: "some-vm-cid"),
          )
        end

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
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
      it 'the request is retried' do
        conflict_response = NSXTPolicy::ApiCallError.new(code: 412, response_body: 'PreconditionFailed')
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args).and_raise(conflict_response).twice
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

  end

  describe '#remove_vm_from_server_pools' do
    let(:vm_ip_address) { '192.168.111.5' }
    let(:vm_cid) { 'some-vm-cid' }
    let(:unmanaged_vm_cid) { 'some-unmanaged-vm-cid' }
    let(:pool_member) { NSXTPolicy::LBPoolMember.new(port: 80, ip_address: vm_ip_address, display_name: vm_cid) }
    let(:unmanaged_pool_member) { NSXTPolicy::LBPoolMember.new(port: 80, ip_address: vm_ip_address, display_name: unmanaged_vm_cid) }
    let(:server_pool_1) do
      NSXTPolicy::LBPool.new(id: 'some-server-pool-id', display_name: 'some-server-pool-name',  members: [pool_member])
    end
    let(:server_pool_2) do
      NSXTPolicy::LBPool.new(id: 'some-other-server-pool-id', display_name: 'some-other-server-pool-name', )
    end
    let(:server_pool_3) do
      NSXTPolicy::LBPool.new(id: 'some-bosh-unmanaged-server-pool-id', display_name: 'some-other-bosh-unmanaged-server-pool-name', members: [unmanaged_pool_member])
    end

    before do
      allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).and_return([server_pool_1, server_pool_2, server_pool_3])
    end

    it 'removes VM from all server pools' do
      expected_server_pool = NSXTPolicy::LBPool.new(id: 'some-server-pool-id', display_name: 'some-server-pool-name', members: [])
      second_expected_server_pool = NSXTPolicy::LBPool.new(id: 'some-bosh-unmanaged-server-pool-id', display_name: 'some-other-bosh-unmanaged-server-pool-name', members: [])
      expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with('some-server-pool-id', expected_server_pool).once
      expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with('some-bosh-unmanaged-server-pool-id', second_expected_server_pool).once
      nsxt_policy_provider.remove_vm_from_server_pools(vm_ip_address, vm_cid, 0)
    end

    it 'removes VM from all the bosh managed server pools if metadata is greater than 0' do
      expected_server_pool = NSXTPolicy::LBPool.new(id: 'some-server-pool-id', display_name: 'some-server-pool-name', members: [])
      expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with('some-server-pool-id', expected_server_pool).once
      nsxt_policy_provider.remove_vm_from_server_pools(vm_ip_address, vm_cid,  1)
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

  describe 'retrieve_server_pools' do
    let(:server_pool_1) do
      NSXTPolicy::LBPool.new(id: 'id-1', display_name: 'test-static-serverpool', member_group: nil)
    end
    let(:server_pool_2) do
      NSXTPolicy::LBPool.new(id: 'id-2', display_name: 'test-static-serverpool', member_group: nil)
    end
    let(:server_pool_3) do
      NSXTPolicy::LBPool.new(id: 'id-3', display_name: 'test-dynamic-serverpool', member_group: double(NSXTPolicy::LBPoolMemberGroup))
    end
    let(:server_pool_4) do
      NSXTPolicy::LBPool.new(id: 'id-4', display_name: 'test-dynamic-serverpool', member_group: double(NSXTPolicy::LBPoolMemberGroup))
    end

    let(:server_pools) { [server_pool_1, server_pool_2, server_pool_3, server_pool_4] }
    let(:server_pools_to_find) do
      [
        {
          'name' => 'test-static-serverpool',
          'port' => 80
        },
        {
          'name' => 'test-dynamic-serverpool',
          'port' => 443
        }
      ]
    end
    before do
      allow(policy_load_balancer_pools_api).to receive(:list_lb_pools).and_return(double(results: server_pools))
    end

    it 'does nothing when server pools to find is empty' do
      nsxt_policy_provider.retrieve_server_pools([])
      nsxt_policy_provider.retrieve_server_pools(nil)
    end

    it 'returns list of all matching static and dynamic server pools' do
      static_server_pools, dynamic_server_pools = nsxt_policy_provider.retrieve_server_pools(server_pools_to_find)
      expect(static_server_pools).to include([server_pool_1, 80])
      expect(static_server_pools).to include([server_pool_2, 80])
      expect(dynamic_server_pools).to contain_exactly(server_pool_3, server_pool_4)
    end

    context "when a dynamic and static server pool have the same display name" do
      let(:server_pool_5) do
        NSXTPolicy::LBPool.new(id: 'id-5', display_name: 'test-static-serverpool', member_group: double(NSXTPolicy::LBPoolMemberGroup))
      end
      let(:server_pools) { [server_pool_1, server_pool_2, server_pool_3, server_pool_4, server_pool_5] }

      it "should still properly organize them into static/dynamic groups" do
        static_server_pools, dynamic_server_pools = nsxt_policy_provider.retrieve_server_pools(server_pools_to_find)
        expect(static_server_pools).to include([server_pool_1, 80])
        expect(static_server_pools).to include([server_pool_2, 80])
        expect(dynamic_server_pools).to contain_exactly(server_pool_3, server_pool_4, server_pool_5)
      end
    end

    context "when not all server_pools_to_find can be found" do
      let(:server_pools) { [server_pool_1] }
      it 'raises an error with missing server pools when any server pool cannot be found' do
        expect do
          nsxt_policy_provider.retrieve_server_pools(server_pools_to_find)
        end.to raise_error(VSphereCloud::ServerPoolsNotFound)
      end

      it 'does not raise an error around missing server pools if "true" is passed as the second argument' do
        expect(logger).to receive(:info).with("Not all server pools found, missing test-dynamic-serverpool. The VM will still be added to found server pools.")
        static_pools, dynamic_pools = nsxt_policy_provider.retrieve_server_pools(server_pools_to_find, true)
        expect(static_pools).to contain_exactly([server_pool_1, 80])
        expect(dynamic_pools).to eq([])
      end
    end

  end

  describe "#retrieve_groups_by_name" do
    let(:group_1_attributes) { { id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1", expression: [] } }
    let(:group_2_attributes) { { id: 'fake-nsgroup-2-id', display_name: "fake nsgroup 2", expression: [] } }
    let(:group_1) { NSXTPolicy::Group.new(group_1_attributes) }
    let(:group_2) { NSXTPolicy::Group.new(group_2_attributes) }

    before do
        allow(search_api).to receive(:query_search).with("resource_type:Group AND display_name:(fake nsgroup 1 OR fake nsgroup 2)").
          and_return(double(NSXTPolicy::SearchResponse, results: results) )
    end

    context "when all groups are found" do
      let(:results) { [group_1_attributes, group_2_attributes] }
      it "returns all groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_name([group_1.display_name, group_2.display_name])).to contain_exactly(group_1, group_2)
      end
    end
    context "when some groups are found" do
      let(:results) { [group_1_attributes] }
      it "returns found groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_name([group_1.display_name, group_2.display_name])).to contain_exactly(group_1)
      end
    end
    context "when no groups are found" do
      let(:results) { [] }
      it "returns found groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_name([group_1.display_name, group_2.display_name])).to eq([])
      end
    end

  end

  describe "#retrieve_groups_by_id" do
    let(:group_1_attributes) { { id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1", expression: [] } }
    let(:group_2_attributes) { { id: 'fake-nsgroup-2-id', display_name: "fake nsgroup 2", expression: [] } }
    let(:group_1) { NSXTPolicy::Group.new(group_1_attributes) }
    let(:group_2) { NSXTPolicy::Group.new(group_2_attributes) }

    before do
        allow(search_api).to receive(:query_search).with("resource_type:Group AND id:(fake-nsgroup-1-id OR fake-nsgroup-2-id)").
          and_return(double(NSXTPolicy::SearchResponse, results: results) )
    end

    context "when all groups are found" do
      let(:results) { [group_1_attributes, group_2_attributes] }
      it "returns all groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_id([group_1.id, group_2.id])).to contain_exactly(group_1, group_2)
      end
    end
    context "when some groups are found" do
      let(:results) { [group_1_attributes] }
      it "returns found groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_id([group_1.id, group_2.id])).to contain_exactly(group_1)
      end
    end
    context "when no groups are found" do
      let(:results) { [] }
      it "returns found groups" do
        expect(nsxt_policy_provider.retrieve_groups_by_id([group_1.id, group_2.id])).to eq([])
      end
    end

  end

end
