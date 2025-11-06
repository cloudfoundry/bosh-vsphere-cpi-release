require 'digest'
require 'securerandom'
require 'integration/spec_helper'
require 'nsxt_manager_client/nsxt_manager_client'
require 'nsxt_policy_client/nsxt_policy_client'

describe 'CPI', nsxt_all: true do

  before(:all) do
    # Read basic info about env
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    @nsxt_username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    @nsxt_password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')
    @nsxt_opaque_vlan_1 = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
    @nsxt_opaque_vlan_2 = fetch_property('BOSH_VSPHERE_SECOND_OPAQUE_VLAN')

    # Configure a user/pass client to add cert/key
    # Client built Directly in TEST. NOT USING NSXTApiClientBuilder
    configuration = NSXT::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = @nsxt_username
    configuration.password = @nsxt_password
    configuration.client_side_validation = false

    if ENV['BOSH_NSXT_CA_CERT_FILE']
      configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
    else
      configuration.verify_ssl = false
      configuration.verify_ssl_host = false
    end
    @manager_client= NSXT::ApiClient.new(configuration)
    @manager_client_with_overwrite = NSXT::ApiClient.new(configuration)
    @manager_client_with_overwrite.x_allow_overwrite

    # Add cert and key
    @nsx_component_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementCertificateApi.new(@manager_client)
    @nsx_component_trust_mgmt_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementPrincipalIdentityApi.new(@manager_client)
    @private_key = generate_private_key
    @certificate = generate_certificate(@private_key)
    @cert_id = submit_cert_to_nsxt(@certificate)
    @principal_id = attach_cert_to_principal(@cert_id, "testprincipal-nsxt-spec-#{SecureRandom.alphanumeric(10)}")

    policy_configuration = NSXTPolicy::Configuration.new
    policy_configuration.host = @nsxt_host
    policy_configuration.username = @nsxt_username
    policy_configuration.password = @nsxt_password
    policy_configuration.client_side_validation = false
    if ENV['BOSH_NSXT_CA_CERT_FILE']
      policy_configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
    else
      policy_configuration.verify_ssl = false
      policy_configuration.verify_ssl_host = false
    end
    policy_client = NSXTPolicy::ApiClient.new(policy_configuration)
    @policy_group_api = NSXTPolicy::PolicyInventoryGroupsGroupsApi.new(policy_client)
    @policy_load_balancer_pools_api = NSXTPolicy::PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerPoolsApi.new(policy_client)
    @policy_group_members_api = NSXTPolicy::PolicyInventoryGroupsGroupMembersApi.new(policy_client)
    @policy_segment_api = NSXTPolicy::PolicyNetworkingConnectivitySegmentsSegmentsApi.new(policy_client)
    @policy_enforcement_points_api = NSXTPolicy::PolicyInfraEnforcementPointsApi.new(policy_client)
    @segments_ports_api = NSXTPolicy::PolicyNetworkingConnectivitySegmentsPortsApi.new(policy_client)
  end

  after(:all) do
    delete_principal(@principal_id) unless @principal_id.nil?
    delete_test_certificate(@cert_id) unless @cert_id.nil?
  end

  # This works exclusively with cert/key pair
  # Utilizes the CPI code in NSXTApiClientBuilder
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
      host: @nsxt_host,
      auth_certificate: @certificate.to_s,
      auth_private_key: @private_key.to_s,
      ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE']
    }))
  end

  let(:nsgroup_name_1) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:nsgroup_name_2) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:segment_1) { NameAndID.new }
  let(:segment_2) { NameAndID.new }
  let(:pool_1) { NameAndID.new}
  let(:pool_2) { NameAndID.new}
  let(:unmanaged_pool) { NameAndID.new}
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1
    }
  end
  let(:network_spec) do
    {
      'static-bridged' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @nsxt_opaque_vlan_1 },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      },
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @nsxt_opaque_vlan_2 },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end
  let(:policy_network_spec) do
    generate_random_policy_network_spec
  end

  def generate_random_policy_network_spec
    {
        'static-bridged' => {
            'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
            'netmask' => '255.255.254.0',
            'cloud_properties' => { 'name' => segment_1.name },
            'default' => ['dns', 'gateway'],
            'dns' => ['169.254.1.2'],
            'gateway' => '169.254.1.3'
        },
        'static' => {
            'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
            'netmask' => '255.255.254.0',
            'cloud_properties' => { 'name' => segment_2.name },
            'default' => ['dns', 'gateway'],
            'dns' => ['169.254.1.2'],
            'gateway' => '169.254.1.3'
        }
    }
  end

  class SegmentPortsAreNotInitialized < StandardError; end
  class StillUpdatingSegmentPorts < StandardError; end
  class StillUpdatingVMsInGroups < StandardError; end
  class NameAndID
    attr_reader :name, :id
    def initialize(name: "BOSH-CPI-test-#{SecureRandom.uuid}", id: SecureRandom.uuid)
      @name = name
      @id = id
    end
  end

  after do
    cpi.cleanup
  end

  describe 'on create_vm' do
    context 'when global default_vif_type is set' do
      # This works exclusively with cert/key pair
      # Utilizes the CPI code in NSXTApiClientBuilder
      let(:cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          auth_certificate: @certificate.to_s,
          auth_private_key: @private_key.to_s,
          ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
          default_vif_type: 'PARENT'
        }))
      end

      it 'sets vif_type for logical ports' do
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            expect(lport.attachment.context.resource_type).to eq('VifAttachmentContext')
            expect(lport.attachment.context.vif_type).to eq('PARENT')
          end
        end
      end

      context 'and cloud property nsxt.vif_type is set' do
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'nsxt' => { 'vif_type' => nil }
          }
        end

        it 'overrides vif_type with cloud property' do
          simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
            verify_ports(vm_id) do |lport|
              expect(lport).not_to be_nil

              expect(lport.attachment.context).to be_nil
            end
          end
        end
      end
    end

    context 'when global default_vif_type is not set' do
      it 'should not set vif_type for logical ports' do
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            expect(lport.attachment.context).to be_nil
          end
        end
      end
    end

    context 'when NSGroups are specified' do
      let(:vm_type) do
        {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'nsxt' => { 'ns_groups' => [nsgroup_name_1, nsgroup_name_2] }
        }
      end

      context 'but at least one of the NSGroups do NOT exist' do
        it 'raises NSGroupsNotFound' do
          expect do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type)
          end.to raise_error(VSphereCloud::NSGroupsNotFound)
        end
      end

      context 'and all the NSGroups exist' do
        let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
        let!(:nsgroup_2) { create_nsgroup(nsgroup_name_2) }
        before do
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            [nsgroup_name_1, nsgroup_name_2].include?(nsgroup.display_name)
          end
          expect(nsgroups.length).to eq(2)
        end
        after do
          delete_nsgroup(nsgroup_1)
          delete_nsgroup(nsgroup_2)
        end

        it 'adds all the logical ports of the VM to all given NSGroups' do
          simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
            verify_ports(vm_id) do |lport|
              expect(lport).not_to be_nil
              expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).to include(lport.id)
              expect(nsgroup_effective_logical_port_member_ids(nsgroup_2)).to include(lport.id)
            end
          end
        end

        context "but none of VM's networks are NSX-T Opaque Network (nsx.LogicalSwitch)" do
          it 'does NOT add VM to NSGroups' do
            simple_vm_lifecycle(cpi, @vlan, vm_type) do |vm_id|
              retryer do
                fabric_svc = NSXT::ManagementPlaneApiFabricVirtualMachinesApi.new(@manager_client)
                nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
                raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
                raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

                external_id = nsxt_vms.first.external_id
                vif_fabric_svc ||= NSXT::ManagementPlaneApiFabricVifsApi.new(@manager_client)
                vifs = vif_fabric_svc.list_vifs(:owner_vm_id => external_id).results
                expect(vifs.length).to eq(1)
                expect(vifs.first.lport_attachment_id).to be_nil
              end
            end
          end
        end
      end
    end

    context 'when server_pools are specified' do
      let(:port_no) { '443' }
      let(:vm_type) do
        {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'nsxt' => {
            'lb' => {
              'server_pools' => [
                {
                  'name' => pool_1.name,
                  'port' => port_no
                },
                {
                  'name' => pool_2.name,
                  'port' => 80
                }
              ]
            }
          }
        }
      end
      context 'but at least one server pool does not exist' do
        it 'raises an error' do
          expect do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type)
          end.to raise_error(VSphereCloud::ServerPoolsNotFound)
        end
      end
      context 'and all server pools exist' do
        let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
        let!(:server_pool_1) { create_static_server_pool(pool_1.name) }
        let!(:server_pool_2) { create_dynamic_server_pool(pool_2.name, nsgroup_1) }

        after do
          delete_server_pool(server_pool_1)
          delete_server_pool(server_pool_2)
          delete_nsgroup(nsgroup_1)
        end

        it 'adds vm to existing static server pools and adds all logical ports of the VM to NSGroups associated with the dynamic server pool' do
          simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            server_pool_1_members = find_pool_members(server_pool_1, vm_ip, port_no)
            expect(server_pool_1_members.count).to eq(1)
            verify_ports(vm_id, 1) do |lport|
              expect(lport).not_to be_nil

              expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).to include(lport.id)
            end
          end
        end
        context 'when port is not provided' do
          # Port is an optional parameter.
          # There are two use cases where port parameter isn't necessary...
          # 1. Virtual Server listening on the same port as backend instance
          # 2. Virtual Server listening on a range of ports (eg tcp_router)
          let(:vm_type) do
            {
              'ram' => 512,
              'disk' => 2048,
              'cpu' => 1,
              'nsxt' => {
                'lb' => {
                  'server_pools' => [
                    {
                      'name' => pool_1.name
                    }
                  ]
                }
              }
            }
          end
          it 'still adds vm to existing static server pool' do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_ip = vm.mob.guest&.ip_address
              expect(vm_ip).to_not be_nil
              server_pool_1_members = find_pool_members(server_pool_1, vm_ip, vm_type['nsxt']['lb']['server_pools'].first['port'])
              expect(server_pool_1_members.count).to eq(1)
            end
          end
        end
        it 'adds vm to all existing static server pools with given name and set the pool member display_name to the vm_cid' do
          begin
            server_pool_3 = create_static_server_pool(pool_1.name) #server pool with same name as server_pool_1
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_ip = vm.mob.guest&.ip_address
              expect(vm_ip).to_not be_nil
              server_pool_1_members = find_pool_members(server_pool_1, vm_ip, port_no)
              expect(server_pool_1_members.count).to eq(1)
              server_pool_3_members = find_pool_members(server_pool_3, vm_ip, port_no)
              expect(server_pool_3_members.count).to eq(1)
              expect(server_pool_1_members[0].display_name).to eq(vm.cid)
              expect(server_pool_3_members[0].display_name).to eq(vm.cid)
            end
          ensure
            delete_server_pool(server_pool_3)
          end
        end
      end
    end

    context 'when using NSX-T Policy API', nsxt_policy: true do
      let(:cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
            host: @nsxt_host,
            username: @nsxt_username,
            password: @nsxt_password,
            ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
            use_policy_api: true,
        }))
      end
      let(:vm_type) do
        {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'nsxt' => nsxt_spec
        }
      end

      before do
        @created_vms = []
        create_segments([segment_1, segment_2])
      end

      after do
        @created_vms.each do |vm_cid|
          delete_vm(cpi, vm_cid)
        end
        delete_segments([segment_1, segment_2])
      end

      context 'using principle identity auth' do
        let(:cpi) do
          VSphereCloud::Cloud.new(cpi_options(nsxt: {
              host: @nsxt_host,
              auth_certificate: @certificate.to_s,
              auth_private_key: @private_key.to_s,
              ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
              use_policy_api: true,
          }))
        end
        let(:nsxt_spec) {
          {
            'ns_groups' => [nsgroup_name_1],
          }
        }
        let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }

        after do
          delete_policy_group(nsgroup_name_1)
        end

        it 'authenticates successfully and creates VM in specified ns groups' do
          # This test exists primarily to exercise principal identity (cert-based) authentication with
          # the policy API. To do this, we need to add the VM to at least one group to force the CPI
          # to interact with the policy API.
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            retryer do
              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1

              expect(results.length).to eq(1)
              expect(results[0].display_name).to eq(vm_id)
            end
          end
        end
      end

      context 'with ns groups' do
        let(:nsxt_spec) {
          {
            'ns_groups' => [nsgroup_name_1, nsgroup_name_2],
          }
        }
        let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
        let!(:nsgroup_2) { create_policy_group(nsgroup_name_2) }

        after do
          delete_policy_group(nsgroup_name_1)
          delete_policy_group(nsgroup_name_2)
        end

        it 'creates VM in specified ns groups' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
            expect(segment_names.length).to eq(2)
            expect(segment_names).to include(segment_1.name)
            expect(segment_names).to include(segment_2.name)
            retryer do
              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1

              expect(results.length).to eq(1)
              expect(results[0].display_name).to eq(vm_id)

              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1

              expect(results.length).to eq(1)
              expect(results[0].display_name).to eq(vm_id)
            end
          end

          retryer do
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

            expect(results.length).to eq(0)
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

            expect(results.length).to eq(0)
          end
        end

        it 'creates more than 5 VMs' do
          begin
            6.times do |i|
              vm_id, _ = cpi.create_vm(
                  "agent-00#{i}",
                  @stemcell_id,
                  vm_type,
                  # Generate different IP addresses for each VM to ensure no conflicts
                  generate_random_policy_network_spec
              )
              expect(vm_id).to_not be_nil
              @created_vms << vm_id

              expect(cpi.has_vm?(vm_id)).to be(true)
            end

            retryer do
              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 6

              # results contain same vms in different power states
              expect(results.map(&:display_name).uniq.length).to eq(6)
              expect(results.map(&:display_name).uniq).to match_array(@created_vms)

              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 6

              expect(results.map(&:display_name).uniq.length).to eq(6)
              expect(results.map(&:display_name).uniq).to match_array(@created_vms)
            end
          ensure
            until @created_vms.empty?
              vm_cid, _ = @created_vms.pop
              delete_vm(cpi, vm_cid)
            end
          end

          retryer do
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

            expect(results.length).to eq(0)
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

            expect(results.length).to eq(0)
          end
        end
      end

      context 'with lb server pools' do
        let(:nsxt_spec) {
          {
            'lb'=> { 'server_pools' => [
              {
                'name' => pool_1.name,
                'port' => 80,
              },
              {
                'name' => pool_2.name,
              },
            ],
            }
          }
        }
        let!(:lb_pool_1) { create_lb_pool(pool_1) }
        let!(:lb_pool_2) { create_lb_pool(pool_2) }
        after do
          delete_lb_pool(pool_1)
          delete_lb_pool(pool_2)
        end

        it 'creates VM in specified server pools, regardless of whether port is specified, and deletes from pools when VM is deleted' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
            expect(segment_names.length).to eq(2)
            expect(segment_names).to include(segment_1.name)
            expect(segment_names).to include(segment_2.name)
            server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
            expect(server_pool_1.members.length).to eq(1)
            expect(server_pool_1.members[0].ip_address).to eq(vm.mob.guest&.ip_address)
            expect(server_pool_1.members[0].port).to eq("80")
            server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
            expect(server_pool_2.members.length).to eq(1)
            expect(server_pool_2.members[0].ip_address).to eq(vm.mob.guest&.ip_address)
            expect(server_pool_2.members[0].port).to eq(nil)
          end

          server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
          expect(server_pool_1.members).to be_nil
          server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
          expect(server_pool_2.members).to be_nil
        end

        context 'when there are bosh managed and unmanaged lb_pools' do
          let!(:unmanaged_lb_pool) { create_lb_pool(unmanaged_pool) }
          after do
            delete_lb_pool(unmanaged_lb_pool)
          end
          context 'when cpi_metadata_version is greater than 0' do
            it 'creates VM in specified server pools, and deletes the vm membership only from the managed lb server pools' do
              simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
                vm = @cpi.vm_provider.find(vm_id)
                segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
                expect(segment_names.length).to eq(2)
                expect(segment_names).to include(segment_1.name)
                expect(segment_names).to include(segment_2.name)
                server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
                expect(server_pool_1.members.length).to eq(1)
                expect(server_pool_1.members[0].display_name).to eq(vm.cid)
                server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
                expect(server_pool_2.members.length).to eq(1)
                expect(server_pool_2.members[0].display_name).to eq(vm.cid)

                unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
                expect(unmanaged_server_pool.members).to be_nil
                add_vm_to_unmanaged_server_pool_with_policy_api(unmanaged_lb_pool.id, vm.mob.guest&.ip_address, 80)
                unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
                expect(unmanaged_server_pool.members.length).to eq(1)
                expect(unmanaged_server_pool.members[0].display_name).to_not eq(vm.cid)
              end

              server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
              expect(server_pool_1.members).to be_nil
              server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
              expect(server_pool_2.members).to be_nil
              unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
              expect(unmanaged_server_pool.members.count).to eq(1)
            end
          end
          context 'when cpi_metadata_version is 0' do
            let(:cpi_metadata_version) {0}

            it 'creates VM in specified server pools, and deletes the vm membership from all the lb server pools' do
              simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
                vm = @cpi.vm_provider.find(vm_id)
                segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
                expect(segment_names.length).to eq(2)
                expect(segment_names).to include(segment_1.name)
                expect(segment_names).to include(segment_2.name)
                server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
                expect(server_pool_1.members.length).to eq(1)
                expect(server_pool_1.members[0].display_name).to eq(vm.cid)
                server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
                expect(server_pool_2.members.length).to eq(1)
                expect(server_pool_2.members[0].display_name).to eq(vm.cid)

                set_cpi_metadata_version(cpi, vm.mob, cpi_metadata_version)
                unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
                expect(unmanaged_server_pool.members).to be_nil
                add_vm_to_unmanaged_server_pool_with_policy_api(unmanaged_lb_pool.id, vm.mob.guest&.ip_address, 80)
                unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
                expect(unmanaged_server_pool.members.length).to eq(1)
                expect(unmanaged_server_pool.members[0].display_name).to_not eq(vm.cid)
              end

              server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
              expect(server_pool_1.members).to be_nil
              server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
              expect(server_pool_2.members).to be_nil
              unmanaged_server_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_pool.id)
              expect(unmanaged_server_pool.members).to be_nil
            end
          end
        end

        context "with dynamic pools" do
          let(:nsxt_spec) {
            {
              'lb'=> { 'server_pools' => [
                {
                  'name' => pool_1.name,
                  'port' => 80,
                },
                {
                  'name' => dynamic_pool.display_name
                },
              ],
              }
            }
          }

          let(:dynamic_pool_group) do
            create_policy_group('dynamic-pool-group')
          end

          let(:dynamic_pool) do
            member_group = NSXTPolicy::LBPoolMemberGroup.new(group_path: dynamic_pool_group.path)
            @policy_load_balancer_pools_api.update_lb_pool('pool-id', NSXTPolicy::LBPool.new(id: 'pool-id', display_name: 'dynamic-pool', member_group: member_group))
          end

          after do
            delete_lb_pool(dynamic_pool)
            delete_policy_group(dynamic_pool_group.display_name)
          end

          it "should add the VM to the group associated with the dynamic server pool and remove on delete" do
            simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
              vm = @cpi.vm_provider.find(vm_id)
              segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
              expect(segment_names.length).to eq(2)
              expect(segment_names).to include(segment_1.name)
              expect(segment_names).to include(segment_2.name)
              server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
              expect(server_pool_1.members.length).to eq(1)
              expect(server_pool_1.members[0].ip_address).to eq(vm.mob.guest&.ip_address)
              expect(server_pool_1.members[0].port).to eq("80")

              retryer do
                results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, dynamic_pool_group.display_name).results
                raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1

                expect(results.length).to eq(1)
                expect(results[0].display_name).to eq(vm_id)
              end
            end

            server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
            expect(server_pool_1.members).to be_nil

            retryer do
              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, dynamic_pool_group.display_name).results
              raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

              expect(results.length).to eq(0)
            end
          end
        end
      end

      context 'with non-nsxt distributed virtual switches' do
        let(:nsxt_spec) { {} }
        let(:dvpg_name) { ENV.fetch('BOSH_VSPHERE_CPI_FOLDER_PORTGROUP_ONE') }
        let(:policy_network_spec) do
          {
            'static-bridged' => {
              'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
              'netmask' => '255.255.254.0',
              'cloud_properties' => { 'name' => segment_1.name },
              'default' => ['dns', 'gateway'],
              'dns' => ['169.254.1.2'],
              'gateway' => '169.254.1.3'
            },
            'static' => {
              'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
              'netmask' => '255.255.254.0',
              'cloud_properties' => { 'name' => dvpg_name },
              'default' => ['dns', 'gateway'],
              'dns' => ['169.254.1.2'],
              'gateway' => '169.254.1.3'
            }
          }
        end
        it 'creates a VM without errors' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            cpi.set_vm_metadata(vm_id, {'id' => 'foo'})

            vm = @cpi.vm_provider.find(vm_id)
            segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
            expect(segment_names.length).to eq(1)
            expect(segment_names).to include(segment_1.name)
          end
        end
      end
    end
  end

  describe 'when policy_api_migration_mode is set', nsxt_policy: true do

    let(:migration_cpi) do
      VSphereCloud::Cloud.new(cpi_options(nsxt: {
        host: @nsxt_host,
        username: @nsxt_username,
        password: @nsxt_password,
        ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
        policy_api_migration_mode: true,
      }))
    end

    let(:port_no1) {'80'}
    let(:port_no2) {'443'}

    let(:bosh_id) { SecureRandom.uuid }

    before do
      @nsgroup_1 = create_nsgroup(nsgroup_name_1)
      @server_pool_1 = create_static_server_pool(pool_1.name)
      @server_pool_2 = create_dynamic_server_pool(pool_2.name, @nsgroup_1)
      create_lb_pool(pool_1)
      create_lb_pool(pool_2)

      create_policy_group(nsgroup_name_1)
      create_segments([segment_1, segment_2])
    end

    after do
      delete_policy_group(nsgroup_name_1)
      delete_segments([segment_1, segment_2])
      delete_server_pool(@server_pool_1)
      delete_server_pool(@server_pool_2)
      delete_lb_pool(pool_1)
      delete_lb_pool(pool_2)
      delete_nsgroup(@nsgroup_1)
    end

    context "when expected groups/server pools do no exist on the policy side" do

      let(:cpi) { migration_cpi }

      it "should create VMs only on the management side" do
      management_only_group = create_nsgroup('management-only-group')
      management_only_pool = create_static_server_pool('management-only-pool')

      vm_type_with_management_only_groups = {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'nsxt' => {
          'ns_groups' => [management_only_group.display_name],
          'lb' => {
            'server_pools' => []
          }
        }
      }

      vm_type_with_management_only_server_pools = {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'nsxt' => {
          'lb' => {
            'server_pools' => [
              {
                'name' => management_only_pool.display_name,
                'port' => port_no1
              },
            ]
          }
        }
        }

        simple_vm_lifecycle(migration_cpi, '', vm_type_with_management_only_groups, network_spec) do |vm_id|
          lport_ids = []
          #validate nsxt creation behavior occurred correctly for VMs created via management api.
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            lport_ids << lport.id
          end
          expect(lport_ids.length).to eq(2)

          lport_ids.each do |id|
            grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
            nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
              next unless nsgroup.members
              nsgroup.members.find do |member|
                member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
              end
            end
            expect(nsgroups.map(&:display_name)).to include('management-only-group')
          end
        end

        simple_vm_lifecycle(migration_cpi, '', vm_type_with_management_only_server_pools, network_spec) do |vm_id|
          #check that the VM was made a member of the static server pool (no group)
          server_pool_1_members = services_svc.read_load_balancer_pool(management_only_pool.id).members
          expect(server_pool_1_members).to contain_exactly(an_object_having_attributes(display_name: vm_id))
        end

      end
    end

    context "with VMs created via the management API" do

      let(:management_cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          auth_certificate: @certificate.to_s,
          auth_private_key: @private_key.to_s,
          ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE']
        }))
      end
      let(:cpi) { management_cpi } #the cpi variable is used to cleanup created VMs.

      context "and the ports are connected to a policy-api created segment/network switch" do
        let(:network_spec) { policy_network_spec }

        it "can successfully set metadata + remove" do
          vm_type = {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'nsxt' => {
              'lb' => {
                'server_pools' => [
                  {
                    'name' => pool_1.name,
                    'port' => port_no1
                  },
                  {
                    'name' => pool_2.name,
                    'port' => port_no2
                  }
                ]
              }
            }
          }
          #we use the policy network spec here so that the ports are accessible via segments on the policy side.

          vm_id, _ = management_cpi.create_vm(
            'vm-created-via-management-api',
            @stemcell_id,
            vm_type,
            network_spec
          )
          begin
            expect(vm_id).to_not be_nil
            expect(migration_cpi.has_vm?(vm_id)).to be(true)

            lport_ids = []
            #validate nsxt creation behavior occurred correctly for VMs created via management api.
            verify_ports(vm_id) do |lport|
              expect(lport).not_to be_nil
              lport_ids << lport.id
            end
            expect(lport_ids.length).to eq(2)

            #check that the VM was made a member of the group (via the dynamic server pool)
            lport_ids.each do |id|
              grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
              nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
                next unless nsgroup.members
                nsgroup.members.find do |member|
                  member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
                end
              end
              expect(nsgroups.map(&:display_name)).to include(@nsgroup_1.display_name)
            end

            #check that the VM was made a member of the static server pool (no group)
            server_pool_1_members = services_svc.read_load_balancer_pool(@server_pool_1.id).members
            expect(server_pool_1_members.count).to eq(1)

            #tags logical ports with metadata for management-created-vms (and doesn't fail when trying to tag segments that don't exist... )
            #NOTE: management side will ONLY add the metadata `id` value as a tag (with the scope of bosh/id)
            migration_cpi.set_vm_metadata(vm_id, {
              'id' => bosh_id,
              'test-tag-1-key' => 'test-tag-1-value',
              'test-tag-2-key' => 'test-tag-2-value',
            })

          #  sleep 30

            verify_policy_ports([segment_1, segment_2]) do |ports|
              expect(ports.length).to eq(1)
              ports.each do |port|
                raise StillUpdatingSegmentPorts if port.tags.length < 3
                expect(port.tags).to include(
                  an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                  an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                  an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
                )
              end
            end

            verify_ports(vm_id) do |logical_port|
              raise StillUpdatingSegmentPorts if logical_port.tags.length < 3
              expect(logical_port.tags).to include(
                  an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                  an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                  an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
              )
            end

          ensure
            delete_vm(migration_cpi, vm_id)
          end

          #PLEASE NOTE: with NSXT 3.1, group membership (in both management/policy groups) is automatically revoked on deletion for VMs created within the policy API.
          #TODO: do we see the same behavior with prior NSX-T versions.
          #check that delete removed the VM from the nsxt groups (that it was added to for the dynamic server pool)
          lport_ids.each do |id|
            grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
            nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
              next unless nsgroup.members
              nsgroup.members.find do |member|
                member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
              end
            end

            expect(nsgroups.map(&:display_name)).not_to include(@nsgroup_1.display_name)
          end

          #check that delete removed the VM from the nsxt server pool that it was directly added to (via the static pool).
          server_pool_1_members = services_svc.read_load_balancer_pool(@server_pool_1.id).members
          expect(server_pool_1_members).to be_nil
        end
      end

      context "and the ports are NOT connected to a policy-api created segment/network switch" do

        it "can successfully set metadata" do
          vm_type = {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'nsxt' => {} }
          #we use the policy network spec here so that the ports are accessible via segments on the policy side.

          vm_id, _ = management_cpi.create_vm(
            'vm-created-via-management-api',
            @stemcell_id,
            vm_type,
            network_spec
          )
          begin
            expect(vm_id).to_not be_nil
            expect(migration_cpi.has_vm?(vm_id)).to be(true)

            #tags logical ports with metadata for management-created-vms (and doesn't fail when trying to tag segments that don't exist... )
            #NOTE: management side will ONLY add the metadata `id` value as a tag (with the scope of bosh/id)
            migration_cpi.set_vm_metadata(vm_id, {
              'id' => bosh_id,
              'test-tag-1-key' => 'test-tag-1-value',
              'test-tag-2-key' => 'test-tag-2-value',
            })

            verify_ports(vm_id) do |logical_port|
              raise StillUpdatingSegmentPorts if logical_port.tags.length < 1
              expect(logical_port.tags).to contain_exactly(
                an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
              )
            end

          ensure
            delete_vm(migration_cpi, vm_id)
          end

        end
      end
    end

    context "with VMs created via the policy API" do
      let(:policy_cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          username: @nsxt_username,
          password: @nsxt_password,
          ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
          use_policy_api: true,
        }))
      end

      let(:cpi) { policy_cpi } # the cpi variable is used to cleanup created VMs.

      it "can successfully set metadata + remove" do
        # server pools cannot be dynamic, so just test one in this case.
        # must manually specify ns_groups since they aren't added via dynamic server pools.
        vm_type = {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'nsxt' => {
            'ns_groups' => [nsgroup_name_1],
            'lb' => {
              'server_pools' => [
                {
                  'name' => pool_1.name,
                  'port' => port_no1
                },
              ]
            }
          }
        }

        #create vm via policy api.
        vm_id, _ = policy_cpi.create_vm(
          'vm-created-via-policy-api',
          @stemcell_id,
          vm_type,
          policy_network_spec
        )

        logical_port_ids = []
        begin
          expect(vm_id).to_not be_nil
          expect(migration_cpi.has_vm?(vm_id)).to be(true)

          #verify segment names were attached correctly.
          vm = policy_cpi.vm_provider.find(vm_id)
          segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
          expect(segment_names).to contain_exactly(segment_1.name, segment_2.name)

          #verify vm is a member of the nsgroup_1
          retryer do
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1
            expect(results).to contain_exactly(an_object_having_attributes(display_name: vm_id))
          end

          #check that the VM was made a member of the server pool (no group)
          server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
          expect(server_pool_1.members).to contain_exactly(an_object_having_attributes(port: "80", ip_address: vm.mob.guest&.ip_address))

          #tags both logical (management) and segment (policy) ports with metadata for policy-created-vms.
          migration_cpi.set_vm_metadata(vm_id, {
            'id' => bosh_id,
            'test-tag-1-key' => 'test-tag-1-value',
            'test-tag-2-key' => 'test-tag-2-value',
          })

          verify_policy_ports([segment_1, segment_2]) do |ports|
            expect(ports.length).to eq(1)
            ports.each do |port|
              raise StillUpdatingSegmentPorts if port.tags.length < 3
              expect(port.tags).to include(
                an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
              )
            end
          end

          verify_ports(vm_id) do |logical_port|
            logical_port_ids << logical_port.id
            raise StillUpdatingSegmentPorts if logical_port.tags.length < 3
            expect(logical_port.tags).to include(
              an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
              an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
              an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
            )
          end

        ensure
          #delete vm created via the policy api.
          delete_vm(migration_cpi, vm_id)
        end

        #check that the management API side does not have orphan group memberships for this VM
        logical_port_ids.each do |id|
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            next unless nsgroup.members
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end

          expect(nsgroups.map(&:display_name)).not_to include(@nsgroup_1.display_name)
        end

        #check that the policy-created VM was removed from groups on the Policy side.
        retryer do
          results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
          raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

          expect(results.map(&:display_name)).not_to include(@nsgroup_1.display_name)
        end

        #check that the VM was removed from the server pool
        server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
        expect(server_pool_1.members).to be_nil

        policy_cpi.cleanup
      end
    end

    context "with VMs created via the migration API" do
      let(:cpi) { migration_cpi } # the cpi variable is used to cleanup created VMs.

      it "can successfully set metadata + remove" do
        vm_type = {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'nsxt' => {
            'ns_groups' => [nsgroup_name_1],
            'lb' => {
              'server_pools' => [
                {
                  'name' => pool_1.name,
                  'port' => port_no1
                },
              ]
            }
          }
        }

        #create vm via migration api.
        vm_id, _ = migration_cpi.create_vm(
          'vm-created-via-policy-api',
          @stemcell_id,
          vm_type,
          policy_network_spec
        )

        logical_port_ids = []
        begin
          expect(vm_id).to_not be_nil
          expect(migration_cpi.has_vm?(vm_id)).to be(true)

          #verify segment names were attached correctly.
          vm = migration_cpi.vm_provider.find(vm_id)
          segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
          expect(segment_names).to contain_exactly(segment_1.name, segment_2.name)

          #verify vm is a member of the nsgroup_1
          retryer do
            results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
            raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length < 1
            expect(results).to contain_exactly(an_object_having_attributes(display_name: vm_id))
          end

          #check that the VM was made a member of the server pool (no group)
          server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
          expect(server_pool_1.members).to contain_exactly(an_object_having_attributes(port: "80", ip_address: vm.mob.guest&.ip_address))

          #tags both logical (management) and segment (policy) ports with metadata for policy-created-vms.
          migration_cpi.set_vm_metadata(vm_id, {
            'id' => bosh_id,
            'test-tag-1-key' => 'test-tag-1-value',
            'test-tag-2-key' => 'test-tag-2-value',
          })

          verify_policy_ports([segment_1, segment_2]) do |ports|
            expect(ports.length).to eq(1)
            ports.each do |port|
              raise StillUpdatingSegmentPorts if port.tags.length < 3
              expect(port.tags).to include(
                an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
              )
            end
          end

          verify_ports(vm_id) do |logical_port|
            logical_port_ids << logical_port.id
            raise StillUpdatingSegmentPorts if logical_port.tags.length < 3
            expect(logical_port.tags).to include(
              an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
              an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
              an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
            )
          end

        ensure
          #delete vm created via the migration api.
          delete_vm(migration_cpi, vm_id)
        end

        #check that the management API side does not have orphan group memberships for this VM
        logical_port_ids.each do |id|
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            next unless nsgroup.members
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end

          expect(nsgroups.map(&:display_name)).not_to include(@nsgroup_1.display_name)
        end

        #check that the policy-created VM was removed from groups on the Policy side.
        retryer do
          results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
          raise StillUpdatingVMsInGroups if results.map(&:display_name).uniq.length > 0

          expect(results.map(&:display_name)).not_to include(@nsgroup_1.display_name)
        end

        #check that the VM was removed from the server pool
        server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
        expect(server_pool_1.members).to be_nil

        migration_cpi.cleanup
      end
    end

  end

  describe 'on delete_vm' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'nsxt' => nsxt_spec
      }
    end

    context 'when NS Groups are specified' do
      let(:nsxt_spec) {
        {
          'ns_groups' => [nsgroup_name_1, nsgroup_name_2],
        }
      }
      let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
      let!(:nsgroup_2) { create_nsgroup(nsgroup_name_2) }
      after do
        delete_nsgroup(nsgroup_1)
        delete_nsgroup(nsgroup_2)
      end
      it "removes all the VM's logical ports from all NSGroups" do
        lport_ids = []
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            lport_ids << lport.id
          end
        end
        expect(lport_ids.length).to eq(2)

        lport_ids.each do |id|
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            next unless nsgroup.members
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end
          expect(nsgroups).to eq([])
        end
      end
    end
    context 'when server pools are specified' do
      let(:port_no1) {'80'}
      let(:port_no2) {'443'}
      let(:nsxt_spec) {
        {
          'lb' => {
            'server_pools' => [
              {
                'name' => pool_1.name,
                'port' => port_no1
              },
              {
                'name' => pool_1.name,
                'port' => port_no2
              },
              {
                'name' => pool_2.name,
                'port' => port_no1
              }
            ]
          }
        }
      }
      let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
      let!(:server_pool_1) { create_static_server_pool(pool_1.name) }
      let!(:server_pool_2) { create_dynamic_server_pool(pool_2.name, nsgroup_1) }
      after do
        delete_server_pool(server_pool_1)
        delete_server_pool(server_pool_2)
        delete_nsgroup(nsgroup_1)
      end
      it "removes all the VM's logical ports from all NSGroups linked to dynamic server pool" do
        lport_ids = []
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            lport_ids << lport.id
          end
        end
        expect(lport_ids.length).to eq(2)

        lport_ids.each do |id|
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            next unless nsgroup.members
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end

          expect(nsgroups).to eq([])
        end
      end
      it 'removes VM from all server pools' do
        simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          vm_ip = vm.mob.guest&.ip_address
          expect(vm_ip).to_not be_nil

          server_poo1_1_members = find_pool_members(server_pool_1, vm_ip, port_no1)
          server_poo1_1_members.concat(find_pool_members(server_pool_1, vm_ip, port_no2))
          expect(server_poo1_1_members.count).to eq(2)
        end

        server_poo1_1_members = services_svc.read_load_balancer_pool(server_pool_1.id).members
        expect(server_poo1_1_members).to be_nil
      end
    end
    context 'when bosh managed and unmanaged server pools exist on nsx' do
      let(:port_no1) {'80'}
      let(:nsxt_spec) {
        {
          'lb' => {
            'server_pools' => [
              {
                'name' => pool_1.name,
                'port' => port_no1
              }
            ]
          }
        }
      }
      let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
      let!(:server_pool_1) { create_static_server_pool(pool_1.name) }
      let!(:unmanaged_server_pool) { create_static_server_pool(unmanaged_pool.name) }
      after do
        delete_server_pool(server_pool_1)
        delete_server_pool(unmanaged_pool)
        delete_nsgroup(nsgroup_1)
      end
      context 'when cpi_metadata_version is greater than 0' do
        it 'removes the VM from the bosh managed server pools' do
          simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            add_vm_to_unmanaged_server_pool_with_manager_api(unmanaged_server_pool.id, vm_ip, port_no1)
            server_pool_1_members = find_pool_members(server_pool_1, vm_ip, port_no1)
            unmanaged_pool_members = find_pool_members(unmanaged_server_pool, vm_ip, port_no1)
            expect(server_pool_1_members.count).to eq(1)
            expect(unmanaged_pool_members.count).to eq(1)
          end

          server_poo1_1_members = services_svc.read_load_balancer_pool(server_pool_1.id).members
          unmanaged_pool_members = services_svc.read_load_balancer_pool(unmanaged_server_pool.id).members
          expect(server_poo1_1_members).to be_nil
          expect(unmanaged_pool_members.count).to eq(1)
        end
      end
      context 'when cpi_metadata_version is 0' do
        let(:cpi_metadata_version) {0}

        it 'removes the VM from all the server pools' do
        simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          vm_ip = vm.mob.guest&.ip_address
          expect(vm_ip).to_not be_nil
          set_cpi_metadata_version(cpi, vm.mob, cpi_metadata_version)
          add_vm_to_unmanaged_server_pool_with_manager_api(unmanaged_server_pool.id, vm_ip, port_no1)
          server_pool_1_members = find_pool_members(server_pool_1, vm_ip, port_no1)
          unmanaged_pool_members = find_pool_members(unmanaged_server_pool, vm_ip, port_no1)
          expect(server_pool_1_members.count).to eq(1)
          expect(unmanaged_pool_members.count).to eq(1)
        end

        server_poo1_1_members = services_svc.read_load_balancer_pool(server_pool_1.id).members
        unmanaged_pool_members = services_svc.read_load_balancer_pool(unmanaged_server_pool.id).members
        expect(server_poo1_1_members).to be_nil
        expect(unmanaged_pool_members).to be_nil
      end
      end
    end
  end

  describe 'on_set_vm_metadata' do
    context 'with bosh id' do
      let(:bosh_id) { SecureRandom.uuid }

      context 'when using policy API', nsxt_policy: true do
        let(:cpi) do
          VSphereCloud::Cloud.new(cpi_options(nsxt: {
              host: @nsxt_host,
              username: @nsxt_username,
              password: @nsxt_password,
              ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
              use_policy_api: true,
          }))
        end

        before { create_segments([segment_1, segment_2]) }

        after { delete_segments([segment_1, segment_2]) }

        it "tags the VM's segment ports with the bosh id" do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            cpi.set_vm_metadata(vm_id, {
              'id' => bosh_id,
              'test-tag-1-key' => 'test-tag-1-value',
              'test-tag-2-key' => 'test-tag-2-value',
            })
            verify_policy_ports([segment_1, segment_2]) do |ports|
              expect(ports.length).to eq(1)
              ports.each do |port|
                raise StillUpdatingSegmentPorts if port.tags.length < 3
                expect(port.tags).to contain_exactly(
                  an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                  an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                  an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value')
                )
              end
            end
          end
        end
      end

      context 'when using management API' do
        it "tags the VM's logical ports with the bosh id" do
          simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
            cpi.set_vm_metadata(vm_id, 'id' => bosh_id)
            verify_ports(vm_id) do |logical_port|
              raise StillUpdatingSegmentPorts if logical_port.tags.length < 1
              expect(logical_port.tags).to contain_exactly( an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)) )
            end
          end
        end
      end

      context 'tagging nsx VM objects' do
        let(:cpi) do
          VSphereCloud::Cloud.new(cpi_options(nsxt: {
            host: @nsxt_host,
            username: @nsxt_username,
            password: @nsxt_password,
            ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
            tag_nsx_vm_objects: tag_nsx_vm_objects,
          }))
        end

        context 'when tag_nsx_vm_objects? is true' do
          let(:tag_nsx_vm_objects) { true }

          it 'tags the object with the same tags as the vsphere VM' do
            simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
              cpi.set_vm_metadata(vm_id, {
                'id' => bosh_id,
                'nxst-tag-1-key' => 'nsxt-tag-1-value',
              })
              nxst_provider = cpi.instance_variable_get(:@nsxt_provider)
              svc = nxst_provider.send(:vm_fabric_svc)
              nsx_raw_tags = svc.list_virtual_machines(display_name: vm_id).results.first.tags || []
              nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                { "scope" => nsx_tag.scope, "tag" => nsx_tag.tag}
              end

              vm = cpi.vm_provider.find(vm_id)
              vsphere_custom_values = vm.mob.custom_value
              field_defs = cpi.client.service_content.custom_fields_manager.field
              vsphere_vm_tags = []
              vsphere_custom_values.each do |custom_value|
                matching_field_def = field_defs.find do |field_def|
                  field_def.key == custom_value.key
                end
                if matching_field_def.name == "cpi_metadata_version"
                  next
                end
                tag_value = ""
                if matching_field_def.name == "id"
                  tag_value = Digest::SHA1.hexdigest(custom_value.value)
                else
                  tag_value = custom_value.value
                end

                vsphere_vm_tags << { "scope" => "bosh/#{matching_field_def.name}", "tag" => tag_value }
              end

              expect(nsx_vm_tags).to include(*vsphere_vm_tags)
            end
          end

          context 'when the nsx VM has existing tags' do
            it 'does not overwrite existing tags' do
              simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
                cpi.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'tag-1-key' => 'tag-1-value',
                })

                cpi.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'tag-2-key' => 'tag-2-value',
                })

                nxst_provider = cpi.instance_variable_get(:@nsxt_provider)
                svc = nxst_provider.send(:vm_fabric_svc)
                nsx_raw_tags = svc.list_virtual_machines(display_name: vm_id).results.first.tags || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag.scope, "tag" => nsx_tag.tag}
                end
                expected_tags = [
                  {"scope" => "bosh/id", "tag" => Digest::SHA1.hexdigest(bosh_id)},
                  {"scope" => "bosh/tag-1-key", "tag" => "tag-1-value"},
                  {"scope" => "bosh/tag-2-key", "tag" => "tag-2-value"},
                ]

                expect(nsx_vm_tags).to match_array(expected_tags)
              end
            end
          end
        end

        context 'when tag_nsx_vm_objects? is false' do
          let(:tag_nsx_vm_objects) { false }

          it 'does not tag' do
            simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
              cpi.set_vm_metadata(vm_id, {
                'id' => bosh_id,
                'nxst-tag-1-key' => 'nsxt-tag-1-value',
              })
              nxst_provider = cpi.instance_variable_get(:@nsxt_provider)
              svc = nxst_provider.send(:vm_fabric_svc)
              nsx_raw_tags = svc.list_virtual_machines(display_name: vm_id).results.first.tags || []
              expect(nsx_raw_tags.length).to eq(0)

              vm = cpi.vm_provider.find(vm_id)
              vsphere_custom_values = vm.mob.custom_value
              ## There's an extra 'cpi_metadata_version' "tag" that gets automatically added to vSphere VM objects.
              ## So, this is one larger than one would expect.
              expect(vsphere_custom_values.length).to eq(3)
            end
          end

          context 'when the nsx VM has existing tags' do
            it 'does not overwrite existing tags' do
              simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
                # first create a nsx vm w/ tags
                tagging_cpi_client = VSphereCloud::Cloud.new(cpi_options(nsxt: {
                  host: @nsxt_host,
                  username: @nsxt_username,
                  password: @nsxt_password,
                  ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
                  tag_nsx_vm_objects: true
                }))
                tagging_cpi_client.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'existing-tag' => 'existing-value',
                })

                # Then update the tags with the non-tagging CPI to ensure that we don't blow away existing tags
                cpi.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'new-tag' => 'new-value',
                })
                nxst_provider = cpi.instance_variable_get(:@nsxt_provider)
                svc = nxst_provider.send(:vm_fabric_svc)
                nsx_raw_tags = svc.list_virtual_machines(display_name: vm_id).results.first.tags || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag.scope, "tag" => nsx_tag.tag}
                end
                expected_tags = [
                  {"scope" => "bosh/id", "tag" => Digest::SHA1.hexdigest(bosh_id)},
                  {"scope" => "bosh/existing-tag", "tag" => "existing-value"},
                ]
                expect(nsx_vm_tags).to match_array(expected_tags)

                # Then make sure that the CPI code will preserve the existing tags when adding new ones.
                tagging_cpi_client.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'yet-another-existing-tag' => 'existing-value',
                })

                nxst_provider = cpi.instance_variable_get(:@nsxt_provider)
                svc = nxst_provider.send(:vm_fabric_svc)
                nsx_raw_tags = svc.list_virtual_machines(display_name: vm_id).results.first.tags || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag.scope, "tag" => nsx_tag.tag}
                end
                expected_tags = [
                  {"scope" => "bosh/id", "tag" => Digest::SHA1.hexdigest(bosh_id)},
                  {"scope" => "bosh/existing-tag", "tag" => "existing-value"},
                  {"scope" => "bosh/yet-another-existing-tag", "tag" => "existing-value"},
                ]
                expect(nsx_vm_tags).to match_array(expected_tags)
              end
            end
          end
        end
      end
    end
  end

  describe 'on adding a vm to security groups' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'nsxt' => { 'ns_groups' => @names }
      }
    end

    before do
      @names = []
      @groups = []
      200.times do #create 200 ns groups to make multiple pages
        @names << "BOSH-CPI-test-#{SecureRandom.uuid}"
        @groups << create_nsgroup(@names[-1])
      end
    end

    after do
      @groups.each do |group|
        delete_nsgroup(group)
      end
    end

    context 'when there are more than one page of security groups (requires client pagination)' do
      it 'should create/delete vm with add/delete nsgroups' do
        nsgroups = cpi.instance_variable_get(:@nsxt_provider).send(:retrieve_all_ns_groups_with_pagination).select do |nsgroup|
          @names.include?(nsgroup.display_name)
        end
        expect(nsgroups.length).to eq(200)
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            @groups.each do |group|
              expect(nsgroup_effective_logical_port_member_ids(group)).to include(lport.id)
            end
          end
        end
      end
    end
  end

  private

  def verify_ports(vm_id, expected_vif_number = 2)
    retryer do
      fabric_svc = NSXT::ManagementPlaneApiFabricVirtualMachinesApi.new(@manager_client)
      nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
      raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
      raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

      expect(nsxt_vms.length).to eq(1)
      expect(nsxt_vms.first.external_id).not_to be_nil

      vif_fabric_svc ||= NSXT::ManagementPlaneApiFabricVifsApi.new(@manager_client)
      vifs = vif_fabric_svc.list_vifs(:owner_vm_id => nsxt_vms.first.external_id).results
      raise VSphereCloud::VIFNotFound.new(vm_id, nsxt_vms.first.external_id) if vifs.empty?
      expect(vifs.length).to eq(expected_vif_number)
      expect(vifs.map(&:lport_attachment_id).compact.length).to eq(expected_vif_number)

      logical_switching_svc = NSXT::ManagementPlaneApiLogicalSwitchingLogicalSwitchPortsApi.new(@manager_client)
      vifs.each do |vif|
        lports = logical_switching_svc.list_logical_ports(attachment_id: vif.lport_attachment_id).results.first
        yield lports if block_given?
      end
    end
  end

  def verify_policy_ports(segments)
    retryer do
      segments.each do |segment|
        segment_ports = @segments_ports_api.list_infra_segment_ports(segment.id).results
        raise SegmentPortsAreNotInitialized.new if segment_ports.empty?
        expect(segment_ports.length).to eq(1)
        yield segment_ports if block_given?
      end
    end
  end

  def create_nsgroup(display_name)
    nsgrp = NSXT::NSGroup.new(:display_name => display_name)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
    grouping_object_svc.create_ns_group(nsgrp)
  end

  def delete_nsgroup(nsgroup)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client_with_overwrite)
    grouping_object_svc.delete_ns_group(nsgroup.id)
  end

  def create_policy_group(group_name)
    grp = NSXTPolicy::Group.new(:display_name => group_name)
    @policy_group_api.update_group_for_domain(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_name, grp)
  end

  def delete_policy_group(group_name)
    @policy_group_api.delete_group(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, group_name)
  end

  def create_segments(segments)
    tzs = @policy_enforcement_points_api.list_transport_zones_for_enforcement_point(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, 'default')
    overlay_tz = tzs.results.find { |tz| tz.display_name == 'tz-overlay' }
    segments.each do |segment|
      seg_1 = NSXTPolicy::Segment.new(display_name: segment.name, transport_zone_path: overlay_tz.path)
      @policy_segment_api.create_or_replace_infra_segment(segment.id, seg_1)
    end
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@manager_client)
    results = grouping_object_svc.get_effective_logical_port_members(nsgroup.id).results
    results.map { |member| member.target_id }
  end

  def create_static_server_pool(pool_name)
    server_pool = NSXT::LbPool.new(display_name: pool_name)
    services_svc.create_load_balancer_pool(server_pool)
  end

  def create_dynamic_server_pool(pool_name, nsgroup)
    server_pool = NSXT::LbPool.new(display_name: pool_name)
    resource = NSXT::ResourceReference.new(target_id: nsgroup.id, target_type: nsgroup.resource_type, target_display_name: nsgroup.display_name)
    server_pool.member_group = NSXT::PoolMemberGroup.new(grouping_object: resource, max_ip_list_size: 2)
    services_svc.create_load_balancer_pool(server_pool)
  end

  def find_pool_members(server_pool, ip_address, port_no)
    server_pool = services_svc.read_load_balancer_pool(server_pool.id)
    server_pool.members.select do |member|
      member.ip_address == ip_address && member.port == port_no
    end
  end

  def delete_server_pool(server_pool)
    services_svc.delete_load_balancer_pool(server_pool.id)
  end

  def services_svc
    NSXT::ManagementPlaneApiServicesLoadbalancerApi.new(@manager_client)
  end

  def create_lb_pool(pool)
    @policy_load_balancer_pools_api.update_lb_pool(pool.id, NSXTPolicy::LBPool.new(id: pool.id, display_name: pool.name))
  end

  def delete_lb_pool(pool)
    @policy_load_balancer_pools_api.delete_lb_pool(pool.id)
  end

  def add_vm_to_unmanaged_server_pool_with_manager_api(server_pool_id, vm_ip, port_no)
    pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: port_no, display_name: 'not-a-vm-cid')
    pool_member_setting_list = NSXT::PoolMemberSettingList.new(members: [pool_member])
    services_svc.perform_pool_member_action(server_pool_id, pool_member_setting_list, 'ADD_MEMBERS')
  end

  def add_vm_to_unmanaged_server_pool_with_policy_api(server_pool_id, vm_ip, port_no)
    load_balancer_pool = @policy_load_balancer_pools_api.read_lb_pool(server_pool_id)
    (load_balancer_pool.members ||= []).push(NSXTPolicy::LBPoolMember.new(port: port_no, ip_address: vm_ip, display_name: 'not-a-vm-cid'))
    @policy_load_balancer_pools_api.update_lb_pool(server_pool_id, load_balancer_pool)
  end

  def retryer(additional_exceptions = [])
    Bosh::Retryable.new(
      tries: 300,
      sleep: ->(try_count, retry_exception) { 1 },
      on: [
        VSphereCloud::VirtualMachineNotFound,
        VSphereCloud::MultipleVirtualMachinesFound,
        VSphereCloud::VIFNotFound,
        VSphereCloud::LogicalPortNotFound,
        SegmentPortsAreNotInitialized,
        StillUpdatingSegmentPorts,
        StillUpdatingVMsInGroups,
        *additional_exceptions,
      ]
    ).retryer do |i|
      yield i if block_given?
    end
  end

  def submit_cert_to_nsxt(certificate)
    trust_object = NSXT::TrustObjectData.new(pem_encoded: certificate)
    certs = @nsx_component_api.add_certificate_import(trust_object)
    certs.results[0].id
  end

  def delete_test_certificate(cert_id)
    @nsx_component_api.delete_certificate(cert_id)
  end

  def attach_cert_to_principal(cert_id, pi_name = 'testprincipal-nsxt-spec-8', node_id = 'node-nsxt-spec-4')
    pi = NSXT::PrincipalIdentity.new(name: pi_name, node_id: node_id,
                                     certificate_id: cert_id, role: 'enterprise_admin')
    @nsx_component_trust_mgmt_api.register_principal_identity(pi).id
  end

  def delete_principal(principal_id)
    @nsx_component_trust_mgmt_api.delete_principal_identity(principal_id)
  end

  def generate_private_key
    OpenSSL::PKey::RSA.new(2048)
  end

  def generate_certificate(private_key)
    subject = '/CN=bosh-test-user'
    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = Time.now
    cert.not_after = Time.now + 365 * 24 * 60 * 60
    cert.public_key = private_key.public_key
    cert.serial = 0x0
    cert.version = 1
    cert.sign(private_key, OpenSSL::Digest::SHA256.new)
    cert
  end

  def delete_segments(segments)
    Bosh::Retryable.new(
        tries: 61,
        sleep: ->(try_count, retry_exception) { 1 },
        on: [NSXTPolicy::ApiCallError]
    ).retryer do |i|
      segments.each do |segment|
        @policy_segment_api.delete_infra_segment(segment.id)
      end
      true
    end
  end

  def set_cpi_metadata_version(cpi, vm_mob, cpi_metadata_version)
    cpi.client.set_custom_field(vm_mob, "cpi_metadata_version", cpi_metadata_version.to_s)
  end
end
