require 'spec_helper'

describe VSphereCloud::NSXTPolicyProvider, fake_logger: true do
  let(:client) { instance_double(NSXT::ApiClient) }
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

  let(:vm_expression) {
    NSXTPolicy::Condition.new(resource_type: 'Condition',
                              key: 'Name',
                              operator: 'EQUALS',
                              member_type: 'VirtualMachine',
                              value: "some-vm-cid")
  }
  let(:existing_expression) {
    NSXTPolicy::Condition.new(resource_type: 'Condition',
                              key: 'Name',
                              operator: 'EQUALS',
                              member_type: 'VirtualMachine',
                              value: "existing-vm-cid")
  }
  let(:conjunction_expression) {
    NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                        conjunction_operator: 'OR',
                                        id: "conjunction-some-vm-cid")

  }
  let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: "some-vm-cid") }
  let(:group1) { instance_double(NSXTPolicy::Group,
                                 expression: [],
                                 id: "some-group-1")}
  let(:group2) { instance_double(NSXTPolicy::Group,
                                 expression: [],
                                 id: "some-group-2")}

  describe '#add_vm_to_groups' do
    let(:groups) { ["some-group-1", "some-group-2"] }
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
                 "some-group-1",
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        expect(group1.expression).to match_array([vm_expression])
        expect(group2.expression).to match_array([vm_expression])
      end
    end

    context 'when groups are not empty' do
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: "some-group-2")}

      it 'adds vm to groups with conjunction operator' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-2",
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        expect(group1.expression).to match_array([existing_expression,
                                                  conjunction_expression,
                                                  vm_expression,
                                                 ])
        expect(group2.expression).to match_array([existing_expression,
                                                  conjunction_expression,
                                                  vm_expression,
                                                 ])
      end
    end

    context 'when vm is already in group' do
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [vm_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [vm_expression],
                                     id: "some-group-2")}

      it 'does not add vm to groups' do
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
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
        expect(group1.expression).to match_array([])
        expect(group2.expression).to match_array([])
      end
    end

    context 'when groups have several vms' do
      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression,
                                                  conjunction_expression,
                                                  vm_expression],
                                     id: "some-group-1")}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression,
                                                  conjunction_expression,
                                                  vm_expression],
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
        expect(group1.expression).to match_array([existing_expression])
        expect(group2.expression).to match_array([existing_expression])
      end
    end
  end

  describe '#add_vm_to_server_pools' do
    let(:server_pools) do
      [
        {
          'name' => 'some-serverpool',
          'port' => 80
        }
      ]
    end
    let(:original_pool) do
      NSXTPolicy::LBPool.new
    end
    let(:pool_with_updates) do
      NSXTPolicy::LBPool.new(members: [NSXTPolicy::LBPoolMember.new(port: 80, ip_address: "9.8.7.6")])
    end

    before do
      allow(vm).to receive_message_chain(:mob, :guest, :ip_address).and_return("9.8.7.6")
      allow(policy_load_balancer_pools_api).to receive(:read_lb_pool_0).
        with("some-serverpool").and_return(original_pool)
    end

    context 'when pool is empty' do
      it 'adds vm to pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-serverpool", pool_with_updates)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when pool has existing members' do
      let(:original_pool) do
        NSXTPolicy::LBPool.new(members: [NSXTPolicy::LBPoolMember.new(ip_address: "5.6.4.3")])
      end
      let(:pool_with_updates) do
        NSXTPolicy::LBPool.new(members: [NSXTPolicy::LBPoolMember.new(ip_address: "5.6.4.3"), NSXTPolicy::LBPoolMember.new(port: 80, ip_address: "9.8.7.6")])
      end

      it 'adds vm to the pool' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-serverpool", pool_with_updates)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end

    context 'when there are many pools' do
      let(:server_pools) do
        [
          {
            'name' => 'some-serverpool',
            'port' => 80
          },
          {
            'name' => 'some-other-serverpool',
            'port' => 8080
          }
        ]
      end
      let(:second_pool_with_updates) do
        NSXTPolicy::LBPool.new(members: [NSXTPolicy::LBPoolMember.new(port: 8080, ip_address: "9.8.7.6")])
      end
      let(:original_second_pool) do
        NSXTPolicy::LBPool.new
      end

      before do
        allow(policy_load_balancer_pools_api).to receive(:read_lb_pool_0).
          with("some-other-serverpool").and_return(original_second_pool)
      end

      it 'adds vm to all pools' do
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-serverpool", pool_with_updates)
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).
          with("some-other-serverpool", second_pool_with_updates)

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
      it 'retries' do
        conflict_response = NSXTPolicy::ApiCallError.new(code: 412, response_body: 'PreconditionFailed')
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args).and_raise(conflict_response).twice
        expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with(any_args)

        nsxt_policy_provider.add_vm_to_server_pools(vm, server_pools)
      end
    end
  end

  describe '#remove_vm_from_server_pools' do
    let(:vm_ip_address) { '192.168.111.5' }
    let(:pool_member) { NSXTPolicy::LBPoolMember.new(port: 80, ip_address: vm_ip_address) }
    let(:server_pool_1) do
      NSXTPolicy::LBPool.new(id: 'some-serverpool',  members: [pool_member])
    end
    let(:server_pool_2) do
      NSXTPolicy::LBPool.new(id: 'some-other-serverpool')
    end

    before do
      allow(policy_load_balancer_pools_api).to receive_message_chain(:list_lb_pools, :results).and_return([server_pool_1, server_pool_2])
    end

    it 'removes VM from all server pools' do
      expected_server_pool = NSXTPolicy::LBPool.new(id: 'some-serverpool', members: [])
      expect(policy_load_balancer_pools_api).to receive(:update_lb_pool_0).with('some-serverpool', expected_server_pool).once
      nsxt_policy_provider.remove_vm_from_server_pools(vm_ip_address)
    end
  end
end