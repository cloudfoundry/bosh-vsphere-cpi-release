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
end