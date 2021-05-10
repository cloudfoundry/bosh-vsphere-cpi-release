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
                                        id: 'conjunction-some-vm-cid')

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
      let(:existing_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['existing-vm-external-id'])
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
        expect(group1.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id', 'some-vm-external-id'])])
        expect(group2.expression).to match_array([NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                                       member_type: 'VirtualMachine',
                                                                                       external_ids: ['existing-vm-external-id', 'some-vm-external-id'])])
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

    context 'when vm is already in group' do
      let(:existing_expression) {
        NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                             member_type: 'VirtualMachine',
                                             external_ids: ['some-vm-external-id'])
      }

      let(:group1) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: 'some-group-1')}
      let(:group2) { instance_double(NSXTPolicy::Group,
                                     expression: [existing_expression],
                                     id: 'some-group-2')}

      it 'only has it one time' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-1',
                 group1)
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 'some-group-2',
                 group2)
        nsxt_policy_provider.add_vm_to_groups(vm, groups)
        vm_expression = NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                              member_type: 'VirtualMachine',
                                                              external_ids: ['some-vm-external-id'])
        expect(group1.expression).to match_array([vm_expression])
        expect(group2.expression).to match_array([vm_expression])
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

    context 'when groups have several vms' do
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

    context 'when groups do not have vms' do
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

      it 'removes vm from groups with conjunction operator' do
        expect(policy_group_api).to receive(:update_group_for_domain).
            with(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN,
                 "some-group-1",
                 group1)
        expect(policy_group_api).to_not receive(:update_group_for_domain)
        nsxt_policy_provider.remove_vm_from_groups(vm)
        expect(group1.expression).to match_array([existing_expression])
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

  describe '#update_vm_metadata_on_segment_ports' do
    let(:metadata) { { 'id' => 'new-bosh-id', 'name' => 'new-bosh-name' } }
    let(:id_hex) { Digest::SHA1.hexdigest('new-bosh-id') }
    let(:vm) { instance_double(VSphereCloud::Resources::VM, get_nsxt_segment_vif_list: [['segment-name-1', 'attachment-1'], ['segment-name-2', 'attachment-2']]) }
    let(:search_result1) { instance_double(NSXTPolicy::SearchResponse, results: [id: 'segment-port-id-1', path: '/infra/segments/segment-name-1/ports/segment-port-id-1']) }
    let(:search_result2) { instance_double(NSXTPolicy::SearchResponse, results: [id: 'segment-port-id-2', path: '/infra/segments/segment-name-2/ports/segment-port-id-2']) }
    let(:segment_port1) { NSXTPolicy::SegmentPort.new(id: 'segment-port-id-1', tags: existing_tags) }
    let(:segment_port2) { NSXTPolicy::SegmentPort.new(id: 'segment-port-id-2', tags: existing_tags) }
    let(:existing_tags) { nil }

    before do
      allow(search_api).to receive(:query_search).with('attachment.id:attachment-1').and_return(search_result1)
      allow(search_api).to receive(:query_search).with('attachment.id:attachment-2').and_return(search_result2)
    end

    context 'when segment port is scoped under the tier-1 router' do
      before do
        allow(policy_segment_ports_api).to receive(:get_infra_segment_port).with('segment-name-1', 'segment-port-id-1').and_return(segment_port1)
        allow(policy_segment_ports_api).to receive(:get_infra_segment_port).with('segment-name-2', 'segment-port-id-2').and_return(segment_port2)
      end

      context 'when segment ports do not have any tags' do
        let(:new_tags) { [
          NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
          NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
        ] }

        it 'adds the id tag' do
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-2')
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
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-2')
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
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-1')
            expect(port_id).to eq('segment-port-id-1')
            expect(segment_port.tags).to eq(new_tags)
          end
          expect(policy_segment_ports_api).to receive(:patch_infra_segment_port).once.ordered do |segment_name, port_id, segment_port|
            expect(segment_name).to eq('segment-name-2')
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
      let(:search_result1) { instance_double(NSXTPolicy::SearchResponse, results: [id: 'segment-port-id-1', path: '/infra/tier-1s/tier-1-name-1/segments/segment-name-1/ports/segment-port-id-1']) }
      let(:search_result2) { instance_double(NSXTPolicy::SearchResponse, results: [id: 'segment-port-id-2', path: '/infra/tier-1s/tier-1-name-2/segments/segment-name-2/ports/segment-port-id-2']) }
      let(:new_tags) { [
        NSXTPolicy::Tag.new('scope' => 'bosh/id', 'tag' => id_hex),
        NSXTPolicy::Tag.new('scope' => 'bosh/name', 'tag' => 'new-bosh-name')
      ] }

      before do
        allow(policy_segment_ports_api).to receive(:get_tier1_segment_port_0).with('tier-1-name-1', 'segment-name-1', 'segment-port-id-1').and_return(segment_port1)
        allow(policy_segment_ports_api).to receive(:get_tier1_segment_port_0).with('tier-1-name-2', 'segment-name-2', 'segment-port-id-2').and_return(segment_port2)
      end

      it 'adds the id tag' do
        expect(policy_segment_ports_api).to receive(:patch_tier1_segment_port_0).once.ordered do |tier1_name, segment_name, port_id, segment_port|
          expect(tier1_name).to eq('tier-1-name-1')
          expect(segment_name).to eq('segment-name-1')
          expect(port_id).to eq('segment-port-id-1')
          expect(segment_port.tags).to eq(new_tags)
        end
        expect(policy_segment_ports_api).to receive(:patch_tier1_segment_port_0).once.ordered do |tier1_name, segment_name, port_id, segment_port|
          expect(tier1_name).to eq('tier-1-name-2')
          expect(segment_name).to eq('segment-name-2')
          expect(port_id).to eq('segment-port-id-2')
          expect(segment_port.tags).to eq(new_tags)
        end

        nsxt_policy_provider.update_vm_metadata_on_segment_ports(vm, metadata)
      end
    end
  end
end