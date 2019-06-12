require 'digest'
require 'securerandom'
require 'integration/spec_helper'

describe 'CPI', nsx_transformers_policy: true do

  let(:global_policy_enabled) { false }
  let(:vm_type_policy_enabled) { nil }
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
        host: @nsxt_host,
        username: @nsxt_username,
        password: @nsxt_password,
        policy_api: policy_enabled,
    }))
  end
  let(:group_1) { NSXT_GROUP_ONE }
  let(:group_2) { NSXT_GROUP_TWO }
  let(:group_empty) { NSXT_GROUP_THREE }
  let(:base_vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'nsxt' => {'policy_api'=> vm_type_policy_enabled}
    }
  end
  let(:bosh_id) { SecureRandom.uuid }
  let(:network_spec) do
   {
     'static' => {
       'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
       'netmask' => '255.255.254.0',
       'cloud_properties' => { 'name' => NSXT_SEGMENT_ONE },
       'default' => ['dns', 'gateway'],
       'dns' => ['169.254.1.2'],
       'gateway' => '169.254.1.3'
     },
    }
  end

  before(:all) do
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    @nsxt_username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    @nsxt_password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')
    @nsxt_ca_cert = ENV['BOSH_VSPHERE_CPI_NSXT_CA_CERT']

    if @nsxt_ca_cert
      @ca_cert_file = Tempfile.new('bosh-cpi-ca-cert')
      @ca_cert_file.write(@nsxt_ca_cert)
      @ca_cert_file.close
      ENV['BOSH_NSXT_CA_CERT_FILE'] = @ca_cert_file.path
    end

    @nsxt_opaque_vlan_1 = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
    @nsxt_opaque_vlan_2 = fetch_property('BOSH_VSPHERE_SECOND_OPAQUE_VLAN')

    create_nsxt_test_infra
    # Give time for segments to appear in vCenter
    puts "Sleeping 20 Seconds to allow infra to come up"
    sleep(20)
  end

  after(:all) do
    if @nsxt_ca_cert
      ENV.delete('BOSH_NSXT_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
    delete_nsxt_test_infra
  end

  context 'when global policy api is enabled and no vm_type property is set' do
    let(:policy_enabled) { true }
    describe 'vm_lifecycle' do
      # static segment ports are created by cpi in contrast to
      # dynamic ports created by ESXi on segment/switch.
      # static ports are created as policy ports while ESXi
      # creates ports on Manager's Logical Switch representation of segment.
      it 'creates a vm on statically created segment ports, adds metadata to its segment ports,'\
         'vmotions it and deletes it with its segment ports' do
        lports=nil
        simple_vm_lifecycle(cpi, '', base_vm_type, network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          nsxt_manager_provider = cpi.instance_variable_get(:@nsxt_provider)
          lports = nsxt_manager_provider.logical_ports(vm)
          verify_ports(vm, nsxt_manager_provider)
          relocate_vm(vm)
          verify_ports(vm, nsxt_manager_provider)
          cpi.set_vm_metadata(vm_id, {'id' => bosh_id})
          verify_port_tags(vm, bosh_id, nsxt_manager_provider)
        end
        verify_lport_deleted(lports)
      end

      context 'when Groups are specified' do
        let(:groups) {[NSXT_GROUP_ONE, NSXT_GROUP_TWO]}
        let(:vm_type) { base_vm_type.merge({'nsxt' => {'ns_groups' => groups, 'policy_api' => vm_type_policy_enabled}}) }
        context 'but at least one of the Groups does NOT exists' do
          let(:groups) {['vcpi-sg-3000']}
          it 'raises error for Group not found' do
            expect do
              simple_vm_lifecycle(cpi, '', vm_type, network_spec)
            end.to raise_error(/vcpi-sg-3000 could not be found/)
          end
        end
        context 'and all the Groups exist' do
          lports=nil
          it 'adds and deletes all the segment ports of the VM to all given Groups' do
            simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              nsxt_manager_provider = cpi.instance_variable_get(:@nsxt_provider)
              verify_ports(vm, nsxt_manager_provider)
              # Verify Ports are added to both the groups
              lports = nsxt_manager_provider.logical_ports(vm)
              verify_port_in_group(lports, groups)
              # Verify ports not added to third empty group
            end
            verify_lport_deleted(lports)
            verify_lports_not_in_group(lports, groups)
            verify_group_member_zero(groups)
            #
            # Verify ports are gone
            # Verify ports are not there in groups anymore
            # wait for changes to take effect or check marked_for_delete flag
          end
          context "but none of VM's networks are NSX-T Opaque Network (nsx.LogicalSwitch)" do
            it 'does NOT add VM to Groups' do
              simple_vm_lifecycle(cpi, @vlan, vm_type) do |vm_id|
                verify_group_member_zero(groups)
              end
              verify_group_member_zero(groups)
            end
          end
        end
      end
    end
  end

  context 'when global policy api is disabled and vm_type policy_api property is set' do
    let(:policy_enabled) { false }
    let(:vm_type_policy_enabled) { true }
    describe 'vm_lifecycle' do
      # static segment ports are created by cpi in contrast to
      # dynamic ports created by ESXi on segment/switch.
      # static ports are created as policy ports while ESXi
      # creates ports on Manager's Logical Switch representation of segment.
      it 'creates a vm on statically created segment ports, adds metadata to its segment ports,'\
         'vmotions it and deletes it with its segment ports' do
        lports=nil
        simple_vm_lifecycle(cpi, '', base_vm_type, network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          nsxt_manager_provider = cpi.instance_variable_get(:@nsxt_provider)
          lports = nsxt_manager_provider.logical_ports(vm)
          verify_ports(vm, nsxt_manager_provider)
          relocate_vm(vm)
          verify_ports(vm, nsxt_manager_provider)
          cpi.set_vm_metadata(vm_id, {'id' => bosh_id})
          verify_port_tags(vm, bosh_id, nsxt_manager_provider)
        end
        verify_lport_deleted(lports)
      end

      context 'when Groups are specified' do
        let(:groups) {[NSXT_GROUP_ONE, NSXT_GROUP_TWO]}
        let(:vm_type) { base_vm_type.merge({'nsxt' => {'ns_groups' => groups, 'policy_api' => vm_type_policy_enabled}}) }
        context 'but at least one of the Groups does NOT exists' do
          let(:groups) {['vcpi-sg-3000']}
          it 'raises error for Group not found' do
            expect do
              simple_vm_lifecycle(cpi, '', vm_type, network_spec)
            end.to raise_error(/vcpi-sg-3000 could not be found/)
          end
        end
        context 'and all the Groups exist' do
          lports=nil
          it 'adds and deletes all the segment ports of the VM to all given Groups' do
            simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              nsxt_manager_provider = cpi.instance_variable_get(:@nsxt_provider)
              verify_ports(vm, nsxt_manager_provider)
              # Verify Ports are added to both the groups
              lports = nsxt_manager_provider.logical_ports(vm)
              verify_port_in_group(lports, groups)
              # Verify ports not added to third empty group
            end
            verify_lport_deleted(lports)
            verify_lports_not_in_group(lports, groups)
            verify_group_member_zero(groups)
            #
            # Verify ports are gone
            # Verify ports are not there in groups anymore
            # wait for changes to take effect or check marked_for_delete flag
          end
          context "but none of VM's networks are NSX-T Opaque Network (nsx.LogicalSwitch)" do
            it 'does NOT add VM to Groups' do
              simple_vm_lifecycle(cpi, @vlan, vm_type) do |vm_id|
                verify_group_member_zero(groups)
              end
              verify_group_member_zero(groups)
            end
          end
        end
      end
    end
  end

  private

  NSXT_SEGMENT_ONE  = 'vcpi-seg-1'
  NSXT_SEGMENT_TWO  = 'vcpi-seg-2'
  NSXT_GROUP_ONE    = 'vcpi-sg-1'
  NSXT_GROUP_TWO    = 'vcpi-sg-2'
  NSXT_GROUP_THREE  = 'vcpi-sg-empty'

  def verify_group_member_zero(group)
    grp_objs = group.inject([]) do |grp_objs, grp|
      grp_objs << policy_group_api.read_group_for_domain('default', grp)
    end
    grp_objs.each do |grp|
      next if grp.expression.nil?
      zero = grp.expression.all? do |expr|
        expr.empty?
      end
      expect(zero).to eq(true)
    end
  end

  def verify_port_in_group(lports, group)
    grp_objs = group.inject([]) do |grp_objs, grp|
      grp_objs << policy_group_api.read_group_for_domain('default', grp)
    end
    lport_display_names = lports.map(&:display_name)
    grp_objs.each do |grp|
      exists = grp.expression.any? do |expr|
        expr.is_a?(NSXTPolicyClient::PathExpression) && !expr.paths.nil? && !expr.paths.include?(lport_display_names)
      end
      expect(exists).to eq(true)
    end
  end

  def verify_lports_not_in_group(lports, group)
    grp_objs = group.inject([]) do |grp_objs, grp|
      grp_objs << policy_group_api.read_group_for_domain('default', grp)
    end
    lport_display_names = lports.map(&:display_name)
    grp_objs.each do |grp|
      exists = grp.expression.any? do |expr|
        expr.is_a?(NSXTPolicyClient::PathExpression) && !expr.paths.nil? && !expr.paths.include?(lport_display_names)
      end
      expect(exists).to eq(false)
    end
  end

  def relocate_vm(vm_res)
    vm_host = vm_res.mob.runtime.host
    vm_cluster = vm_host.parent
    diff_host = (vm_cluster.host - [vm_host]).sample
    puts("Relocating #{vm_res.cid} from host: #{vm_host.name} to host: #{diff_host.name}")
    cpi.instance_variable_get(:@client).wait_for_task do
      vm_res.mob.relocate(VimSdk::Vim::Vm::RelocateSpec.new(host: diff_host))
    end
  end

  def create_nsxt_test_infra
    puts("\n **** Creating test infra on NSX-T ****")
    create_segment(name: NSXT_SEGMENT_ONE)
    create_segment(name: NSXT_SEGMENT_TWO)
    create_group(name: NSXT_GROUP_ONE)
    create_group(name: NSXT_GROUP_TWO)
    create_group(name: NSXT_GROUP_THREE)
  end

  def delete_nsxt_test_infra
    puts("\n **** Deleting test infra on NSX-T ****")
    delete_segment(name: NSXT_SEGMENT_ONE)
    delete_segment(name: NSXT_SEGMENT_TWO)
    delete_group(name: NSXT_GROUP_ONE)
    delete_group(name: NSXT_GROUP_TWO)
    delete_group(name: NSXT_GROUP_THREE)
  end

  def create_group(name:)
    grp = NSXTPolicyClient::Group.new(id: name)
    # No need to rescue any errors here since it is test file and inputs
    # are tightly controlled.
    grp = policy_group_api.update_group_for_domain('default', name, grp)
    poll_until_realized(intent_path: grp.path)
  end

  def delete_group(name:)
    policy_group_api.delete_group('default', name)
  end

  def create_segment(name:)
    tz_path = transport_zone_api.list_transport_zones_for_enforcement_point('default', 'default').results.detect do |tz|
      tz.display_name == 'tz-overlay'
    end.path
    seg = NSXTPolicyClient::Segment.new(id: name, list_transport_zones_for_enforcement_point: tz_path)
    seg = policy_segment_api.create_or_replace_infra_segment(seg.id, seg)
    poll_until_realized(intent_path: seg.path)
  end

  def delete_segment(name:)
    policy_segment_api.delete_infra_segment(name)
  end

  def policy_group_api
    @policy_group_api ||= NSXTPolicyClient::PolicyApi.new(nsxt_client)
  end

  def policy_realization_api
    @policy_realization_api ||= NSXTPolicyClient::PolicyRealizationApi.new(nsxt_client)
  end

  def policy_segment_api
    @policy_segment_api ||= NSXTPolicyClient::PolicyConnectivitySegmentsApi.new(nsxt_client)
  end

  def policy_port_api
    @policy_port_api ||= NSXTPolicyClient::PolicyConnectivitySegmentsPortsApi.new(nsxt_client)
  end

  def transport_zone_api
    @transport_zone_api ||= NSXTPolicyClient::PolicyInfraEnforcementPointsTransportZoneApi.new(nsxt_client)
  end

  def poll_until_realized(intent_path:)
    Bosh::Retryable.new(
        tries: 20,
        sleep: ->(try_count, retry_exception) { 1 },
        on: [VSphereCloud::UnrealizedResource]
    ).retryer do |i|
      puts("Polling (try:##{i}) to check if Entity with path: #{intent_path} is realized or not")
      result = policy_realization_api.list_realized_entities(intent_path)
      # In case policy API has not started realizing an entity. the results should be nil then as count is 0
      raise VSphereCloud::UnrealizedResource.new(intent_path) if result.result_count == 0
      # A single policy resource might need multiple manager realizations to happen
      # before it could be use. Here we are checking that all the
      # GenericPolicyRealizedResource objects (the results) have been realized
      # and raise an error if any of the realization object is in ERROR state.
      realized = result.results.all? do |res|
        if res.state == 'ERROR'
          raise VSphereCloud::ErrorRealizingResource.new("Error realizing entity #{res} for intent path: #{intent_path}")
        end
        res.state == 'REALIZED'
      end
      # If none has been realized yet, raise error
      raise VSphereCloud::UnrealizedResource.new(intent_path) unless realized
      puts("Entity: #{intent_path} realized.")
      realized
    end
  end

  def verify_ports(vm_res, nsxt_mgr_pvdr)
    nsxt_mgr_pvdr.logical_ports(vm_res).each do |lport|
      expect(lport.display_name).to start_with(vm_res.cid)
      segment_name = lport.display_name.split('_')[-2]
      expect(verify_segment_port(seg: segment_name, port: lport.display_name)).to_not be_nil
    end
  end

  def verify_port_tags(vm_res, bosh_id, nsxt_mgr_pvdr)
    nsxt_mgr_pvdr.logical_ports(vm_res).each do |lport|
      segment_port = policy_port_api.get_infra_segment_port(retrieve_segment_name(lport.display_name),
                                                            lport.display_name)
      tag = segment_port.tags.detect {|tag| tag.scope == 'bosh/id'}
      expect(tag.tag).to eq((Digest::SHA1.hexdigest(bosh_id)))
    end
  end

  def retrieve_segment_name(port_id)
    port_id.split('_')[-2]
  end

  def verify_segment_port(seg:, port:)
    policy_port_api.get_infra_segment_port(seg, port)
  end

  def verify_lport_deleted(lports)
    lport_names = lports.map(&:display_name)
    segment_name = lport_names.map do |name|
      retrieve_segment_name(name)
    end
    segment_name.each do |seg|
      ports = policy_port_api.list_infra_segment_ports(seg).results.map(&:display_name)
      expect(ports).to_not include(lport_names)
    end
  end

  def nsxt_client
    return @nsxt_client if @nsxt_client

    configuration = NSXTPolicyClient::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = @nsxt_username
    configuration.password = @nsxt_password
    configuration.client_side_validation = false
    if ENV['BOSH_NSXT_CA_CERT_FILE']
      configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
    end
    if ENV['NSXT_SKIP_SSL_VERIFY']
      configuration.verify_ssl = false
      configuration.verify_ssl_host = false
    end
    @nsxt_client = NSXTPolicyClient::ApiClient.new(configuration)
  end
end
