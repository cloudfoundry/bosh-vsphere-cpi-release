require 'digest'
require 'securerandom'
require 'integration/spec_helper'
require 'nsxt_policy_client/nsxt_policy_client'

# This spec is designed to run on environments which have only the policy API available.
describe 'CPI', nsxt_pure_policy: true do
  include VSphereCloud::Logger
  before(:all) do
    # Read basic info about env
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    @nsxt_username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    @nsxt_password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')
    @nsxt_opaque_vlan_1 = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
    @nsxt_opaque_vlan_2 = fetch_property('BOSH_VSPHERE_SECOND_OPAQUE_VLAN')
    @nsxt_overlay_tz = fetch_property('BOSH_VSPHERE_TRANSPORT_ZONE_ID')

    # Configure NSXT9 Policy API client
    configuration = NSXTPolicy::Configuration.new
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

    @policy_client = NSXTPolicy::ApiClient.new(configuration)

    # Initialize NSXT9 Policy APIs
    @policy_groups_api = NSXTPolicy::GroupsApi.new(@policy_client)
    @policy_load_balancer_pools_api = NSXTPolicy::LoadBalancerPoolsApi.new(@policy_client)
    @policy_segments_api = NSXTPolicy::SegmentsApi.new(@policy_client)
    @policy_virtual_machines_api = NSXTPolicy::VirtualMachinesApi.new(@policy_client)
    @policy_transport_zones_api = NSXTPolicy::TransportZonesApi.new(@policy_client)
    @segments_ports_api = NSXTPolicy::PortsApi.new(@policy_client)
    @policy_infra_api = NSXTPolicy::InfraApi.new(@policy_client)
    @policy_group_members_api = NSXTPolicy::GroupMembersApi.new(@policy_client)
  end

  # Test variables
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

  # CPI instance using NSXT9 Policy API
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
      host: @nsxt_host,
      username: @nsxt_username,
      password: @nsxt_password,
      ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
      use_policy_api: true,
    }))
  end

  # Test cases
  describe 'on create_vm' do
    context 'when global default_vif_type is set' do
      # This works exclusively with cert/key pair
      # Utilizes the CPI code in NSXTApiClientBuilder
      let(:cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          username: @nsxt_username,
          password: @nsxt_password,
          ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
          use_policy_api: true,
          default_vif_type: 'PARENT'
        }))
      end
      before do
        create_segments([segment_1, segment_2])
      end
      after do
        delete_segments([segment_1, segment_2])
      end

        it 'sets vif_type for logical ports' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            verify_ports(vm_id, [segment_1, segment_2]) do |lport|
              expect(lport).not_to be_nil
              expect(lport.attachment.id).not_to be_nil
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
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            verify_ports(vm_id, [segment_1, segment_2]) do |lport|
              expect(lport).not_to be_nil
              expect(lport.attachment.id).not_to be_nil
            end
          end
        end
      end


      context 'when global default_vif_type is not set' do
        it 'should not set vif_type for logical ports' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            verify_ports(vm_id, [segment_1, segment_2]) do |lport|
              expect(lport).not_to be_nil
              expect(lport.attachment.id).not_to be_nil
            end
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
          end.to raise_error(VSphereCloud::Cloud::MissingNSXTGroups)
        end
      end

      context 'and all the NSGroups exist' do
        let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
        let!(:nsgroup_2) { create_policy_group(nsgroup_name_2) }
        before do
          create_segments([segment_1, segment_2])
        end
        after do
          delete_policy_group(nsgroup_name_1)
          delete_policy_group(nsgroup_name_2)
          delete_segments([segment_1, segment_2])
        end

        it 'adds all the logical ports of the VM to all given NSGroups' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            verify_ports(vm_id, [segment_1, segment_2]) do |lport|
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
                all_nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
                nsxt_vms = all_nsx_vms.select { |vm| vm[:display_name] == vm_id }

                raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
                raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

                external_id = nsxt_vms.first[:external_id]
                vif_fabric_svc = @policy_infra_api.list_vifs_on_enforcement_point('default').results
                vifs = vif_fabric_svc.select { |vif| vif.owner_vm_id == nsxt_vms.first[:external_id] }
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
        let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
        let!(:server_pool_1) { create_lb_pool(pool_1) }
        let!(:server_pool_2) { create_lb_pool(pool_2) }

        before do
          create_segments([segment_1, segment_2])
        end

        after do
          delete_lb_pool(pool_1)
          delete_lb_pool(pool_2)
          delete_policy_group(nsgroup_name_1)
          delete_segments([segment_1, segment_2])
        end

        it 'adds vm to existing static server pools and adds all logical ports of the VM to NSGroups associated with the dynamic server pool' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
            expect(server_pool_1.members.length).to eq(1)
            expect(server_pool_1.members[0].ip_address).to eq(vm_ip)
            expect(server_pool_1.members[0].port).to eq(port_no)
            verify_ports(vm_id, [segment_1, segment_2]) do |lport|
              expect(lport).not_to be_nil
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
            simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_ip = vm.mob.guest&.ip_address
              expect(vm_ip).to_not be_nil
              server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
              expect(server_pool_1.members.length).to eq(1)
              expect(server_pool_1.members[0].ip_address).to eq(vm_ip)
            end
          end
        end
        it 'adds vm to all existing static server pools with given name and set the pool member display_name to the vm_cid' do
          begin
            server_pool_3 = create_lb_pool(NameAndID.new(name: pool_1.name)) #server pool with same name as server_pool_1
            simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_ip = vm.mob.guest&.ip_address
              expect(vm_ip).to_not be_nil
              server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
              expect(server_pool_1.members.length).to eq(1)
              expect(server_pool_1.members[0].display_name).to eq(vm.cid)
              server_pool_3_members = @policy_load_balancer_pools_api.read_lb_pool(server_pool_3.id)
              expect(server_pool_3_members.members.length).to eq(1)
              expect(server_pool_3_members.members[0].display_name).to eq(vm.cid)
            end
          ensure
            delete_lb_pool(server_pool_3) if server_pool_3
          end
        end
      end
    end

    context 'when using NSX-T Policy API' do
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
              username: @nsxt_username,
              password: @nsxt_password,
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

        it 'authenticates successfully and creates VM in specified ns groups', focus: true do
          # This test exists primarily to exercise principal identity (cert-based) authentication with
          # the policy API. To do this, we need to add the VM to at least one group to force the CPI
          # to interact with the policy API.
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = @cpi.vm_provider.find(vm_id)
            retryer do
              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_1).results
              raise StillUpdatingVMsInGroups unless results.any? { |r| r.display_name == vm_id }
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
              raise StillUpdatingVMsInGroups unless results.any? { |r| r.display_name == vm_id }

              expect(results.length).to eq(1)
              expect(results[0].display_name).to eq(vm_id)

              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
              raise StillUpdatingVMsInGroups unless results.any? { |r| r.display_name == vm_id }

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
              raise StillUpdatingVMsInGroups unless @created_vms.all? { |vm| results.any? { |r| r.display_name == vm } }

              # results contain same vms in different power states
              expect(results.map(&:display_name).uniq.length).to eq(6)
              expect(results.map(&:display_name).uniq).to match_array(@created_vms)

              results = @policy_group_members_api.get_group_vm_members(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, nsgroup_name_2).results
              raise StillUpdatingVMsInGroups unless @created_vms.all? { |vm| results.any? { |r| r.display_name == vm } }

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
            vm = cpi.vm_provider.find(vm_id)
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
                vm = cpi.vm_provider.find(vm_id)
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
            let(:cpi_metadata_version) { 0 }

            it 'creates VM in specified server pools, and deletes the vm membership from all the lb server pools' do
              simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
                vm = cpi.vm_provider.find(vm_id)
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
                raise StillUpdatingVMsInGroups unless results.any? { |r| r.display_name == vm_id }

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

            vm = cpi.vm_provider.find(vm_id)
            segment_names = vm.get_nsxt_segment_vif_list.map { |x| x[0] }
            expect(segment_names.length).to eq(1)
            expect(segment_names).to include(segment_1.name)
          end
        end
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
      let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
      let!(:nsgroup_2) { create_policy_group(nsgroup_name_2) }
      after do
        delete_policy_group(nsgroup_name_1)
        delete_policy_group(nsgroup_name_2)
      end

      before do
        create_segments([segment_1, segment_2])
      end

      after do
        delete_segments([segment_1, segment_2])
      end

      it "removes all the VM's logical ports from all NSGroups" do
        lport_ids = []
        simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
          verify_ports(vm_id, [segment_1, segment_2]) do |lport|
            expect(lport).not_to be_nil
            lport_ids << lport.id
          end
        end

        lport_ids.each do |id|
          expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).not_to include(id)
          expect(nsgroup_effective_logical_port_member_ids(nsgroup_2)).not_to include(id)
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
      let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
      let!(:lb_pool_1) { create_lb_pool(pool_1) }
      let!(:lb_pool_2) { create_lb_pool(pool_2) }
      after do
        delete_lb_pool(lb_pool_1)
        delete_lb_pool(lb_pool_2)
        delete_policy_group(nsgroup_name_1)
      end

      before do
        create_segments([segment_1, segment_2])
      end

      after do
        delete_segments([segment_1, segment_2])
      end

      it "removes all the VM's logical ports from all NSGroups linked to dynamic server pool" do
        lport_ids = []
        simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
          verify_ports(vm_id, [segment_1, segment_2]) do |lport|
            expect(lport).not_to be_nil
            lport_ids << lport.id
          end
        end
        expect(lport_ids.length).to eq(2)
        lport_ids.each do |id|
          expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).not_to include(id)
        end
      end

      it 'removes VM from all server pools' do
        simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          vm_ip = vm.mob.guest&.ip_address
          expect(vm_ip).to_not be_nil
        end
        server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
        expect(server_pool_1.members).to be_nil
        server_pool_2 = @policy_load_balancer_pools_api.read_lb_pool(pool_2.id)
        expect(server_pool_2.members).to be_nil
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
      let!(:nsgroup_1) { create_policy_group(nsgroup_name_1) }
      let!(:server_pool_1) { create_lb_pool(pool_1) }
      let!(:unmanaged_server_pool) { create_lb_pool(unmanaged_pool) }
      after do
        delete_lb_pool(server_pool_1)
        delete_lb_pool(unmanaged_pool)
        delete_policy_group(nsgroup_name_1)
      end

      before do
        create_segments([segment_1, segment_2])
      end

      after do
        delete_segments([segment_1, segment_2])
      end

      context 'when cpi_metadata_version is greater than 0' do
        it 'removes the VM from the bosh managed server pools' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            add_vm_to_unmanaged_server_pool_with_policy_api(unmanaged_server_pool.id, vm_ip, port_no1)
            server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
            expect(server_pool_1.members.length).to eq(1)
            expect(server_pool_1.members[0].ip_address).to eq(vm_ip)
            unmanaged_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_server_pool.id)
            expect(unmanaged_pool.members.length).to eq(1)
            expect(unmanaged_pool.members[0].ip_address).to eq(vm_ip)
          end

          server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
          expect(server_pool_1.members).to be_nil
          unmanaged_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_server_pool.id)
          expect(unmanaged_pool.members.length).to eq(1)
        end
      end

      context 'when cpi_metadata_version is 0' do
        let(:cpi_metadata_version) {0}

        it 'removes the VM from all the server pools' do
          simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            set_cpi_metadata_version(cpi, vm.mob, cpi_metadata_version)
            add_vm_to_unmanaged_server_pool_with_policy_api(unmanaged_server_pool.id, vm_ip, port_no1)
            server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
            expect(server_pool_1.members.length).to eq(1)
            expect(server_pool_1.members[0].ip_address).to eq(vm_ip)
            unmanaged_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_server_pool.id)
            expect(unmanaged_pool.members.length).to eq(1)
            expect(unmanaged_pool.members[0].ip_address).to eq(vm_ip)
          end

          server_pool_1 = @policy_load_balancer_pools_api.read_lb_pool(pool_1.id)
          expect(server_pool_1.members).to be_nil
          unmanaged_pool = @policy_load_balancer_pools_api.read_lb_pool(unmanaged_server_pool.id)
          expect(unmanaged_pool.members).to be_nil
        end
      end
    end
  end

  describe 'on_set_vm_metadata' do
    context 'with bosh id' do
      let(:bosh_id) { SecureRandom.uuid }

      context 'when using policy API' do
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
                expect(port.tags).to contain_exactly(an_object_having_attributes(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(bosh_id)),
                                                     an_object_having_attributes(scope: 'bosh/test-tag-1-key', tag: 'test-tag-1-value'),
                                                     an_object_having_attributes(scope: 'bosh/test-tag-2-key', tag: 'test-tag-2-value'))
              end
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
            use_policy_api: true,
          }))
        end
        before { create_segments([segment_1, segment_2]) }

        after { delete_segments([segment_1, segment_2]) }

        context 'when tag_nsx_vm_objects? is true' do
          let(:tag_nsx_vm_objects) { true }

          it 'tags the object with the same tags as the vsphere VM' do
            simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
              cpi.set_vm_metadata(vm_id, {
                'id' => bosh_id,
                'nxst-tag-1-key' => 'nsxt-tag-1-value',
              })
              nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
              nsx_raw_tags = nsx_vms.select { |vm| vm[:display_name] == vm_id }.first[:tags] || []
              nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                { "scope" => nsx_tag[:scope], "tag" => nsx_tag[:tag]}
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
              simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
                cpi.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'tag-1-key' => 'tag-1-value',
                })

                cpi.set_vm_metadata(vm_id, {
                  'id' => bosh_id,
                  'tag-2-key' => 'tag-2-value',
                })

                nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
                nsx_raw_tags = nsx_vms.select { |vm| vm[:display_name] == vm_id }.first[:tags] || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag[:scope], "tag" => nsx_tag[:tag]}
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
            simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
              cpi.set_vm_metadata(vm_id, {
                'id' => bosh_id,
                'nxst-tag-1-key' => 'nsxt-tag-1-value',
              })
              nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
              nsx_raw_tags = nsx_vms.select { |vm| vm[:display_name] == vm_id }.first[:tags] || []
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
              simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
                # first create a nsx vm w/ tags
                tagging_cpi_client = VSphereCloud::Cloud.new(cpi_options(nsxt: {
                  host: @nsxt_host,
                  username: @nsxt_username,
                  password: @nsxt_password,
                  ca_cert_file: ENV['BOSH_NSXT_CA_CERT_FILE'],
                  tag_nsx_vm_objects: true,
                  use_policy_api: true,
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
                nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
                nsx_raw_tags = nsx_vms.select { |vm| vm[:display_name] == vm_id }.first[:tags] || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag[:scope], "tag" => nsx_tag[:tag]}
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

                nsx_vms=@policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
                nsx_raw_tags = nsx_vms.select { |vm| vm[:display_name] == vm_id }.first[:tags] || []
                nsx_vm_tags = nsx_raw_tags.map do |nsx_tag|
                  { "scope" => nsx_tag[:scope], "tag" => nsx_tag[:tag]}
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
        @groups << create_policy_group(@names[-1])
      end
      create_segments([segment_1, segment_2])
    end

    after do
      @groups.each do |group|
        delete_policy_group(group.display_name)
      end
      delete_segments([segment_1, segment_2])
    end

    context 'when there are more than one page of security groups (requires client pagination)' do
      it 'should create/delete vm with add/delete nsgroups' do
        nsgroups = retrieve_all_ns_groups_with_pagination.select do |nsgroup|
          @names.include?(nsgroup.display_name)
        end
        expect(nsgroups.length).to eq(200)
        simple_vm_lifecycle(cpi, '', vm_type, policy_network_spec) do |vm_id|
          verify_ports(vm_id, [segment_1, segment_2]) do |lport|
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

  def create_policy_group(group_name)
    grp = NSXTPolicy::Group.new(:display_name => group_name)
    @policy_groups_api.update_group_for_domain('default', group_name, grp)
  end

  def delete_policy_group(group_name)
    @policy_groups_api.delete_group('default', group_name)
  end

  def create_segments(segments)
    tzs = @policy_transport_zones_api.list_transport_zones_for_enforcement_point(VSphereCloud::NSXTPolicyProvider::DEFAULT_NSXT_POLICY_DOMAIN, 'default')
    overlay_tz = tzs.results.find { |tz| tz.id == @nsxt_overlay_tz || tz.nsx_id == @nsxt_overlay_tz }

    segments.each do |segment|
      seg = NSXTPolicy::Segment.new(display_name: segment.name, transport_zone_path: overlay_tz.path)
      @policy_segments_api.create_or_replace_infra_segment(segment.id, seg)
      logger.info("Created segment: #{segment.name}")

    end
  end

  def delete_segments(segments)
    segments.each do |segment|
      @policy_segments_api.delete_infra_segment(segment.id)
      rescue => e
        # Ignore errors during cleanup
    end
  end

  def create_lb_pool(pool)
    @policy_load_balancer_pools_api.update_lb_pool(pool.id, NSXTPolicy::LBPool.new(id: pool.id, display_name: pool.name))
  end

  def delete_lb_pool(pool)
    @policy_load_balancer_pools_api.delete_lb_pool(pool.id)
  end

  def add_vm_to_unmanaged_server_pool_with_policy_api(server_pool_id, vm_ip, port_no)
    load_balancer_pool = @policy_load_balancer_pools_api.read_lb_pool(server_pool_id)
    (load_balancer_pool.members ||= []).push(NSXTPolicy::LBPoolMember.new(port: port_no, ip_address: vm_ip, display_name: 'not-a-vm-cid'))
    @policy_load_balancer_pools_api.update_lb_pool(server_pool_id, load_balancer_pool)
  end

  def verify_ports(vm_id, segments, expected_vif_number = 2)
    retryer do
      # Find the VM in NSXT
      fabric_svc = @policy_virtual_machines_api.list_virtual_machines_on_enforcement_point('default').results
      nsxt_vms = fabric_svc.select { |vm| vm[:display_name] == vm_id }
      raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
      raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

      expect(nsxt_vms.length).to eq(1)
      expect(nsxt_vms.first[:external_id]).not_to be_nil

      # Find VIFs for the VM using the new API
      vif_fabric_svc = @policy_infra_api.list_vifs_on_enforcement_point('default').results
      vifs = vif_fabric_svc.select { |vif| vif.owner_vm_id == nsxt_vms.first[:external_id] }
      raise VSphereCloud::VIFNotFound.new(vm_id, nsxt_vms.first[:external_id]) if vifs.empty?
      expect(vifs.length).to eq(expected_vif_number)
      expect(vifs.map(&:lport_attachment_id).compact.length).to eq(expected_vif_number)

      # Collect all segment ports from all segments
      all_segment_ports = []
      segments.each do |segment|
        segment_ports = @segments_ports_api.list_infra_segment_ports(segment.id).results
        all_segment_ports.concat(segment_ports)
      end

      # Match VIFs with their corresponding logical ports
      vifs.each do |vif|
        lports = all_segment_ports.select { |lport| lport.attachment.id == vif.lport_attachment_id }
        yield lports.first if block_given?
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

  def set_cpi_metadata_version(cpi, vm_mob, cpi_metadata_version)
    cpi.client.set_custom_field(vm_mob, "cpi_metadata_version", cpi_metadata_version.to_s)
  end

  def retrieve_all_ns_groups_with_pagination
    logger.info("Gathering all NS Groups using policy API")
    objects = []
    result_list = @policy_groups_api.list_group_for_domain('default')
    objects.push(*result_list.results)
    until result_list.cursor.nil?
      result_list = @policy_groups_api.list_group_for_domain('default', cursor: result_list.cursor)
      objects.push(*result_list.results)
    end
    logger.info("Found #{objects.size} number of NS Groups")
    objects
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    logger.info("Waiting for 30 seconds to allow the NSGroup to be updated")
    sleep (5)
    policy_group_members_api = NSXTPolicy::GroupMembersApi.new(@policy_client)
    results = policy_group_members_api.get_group_segment_port_members('default', nsgroup.id).results
    results.map { |member| member.id }
  end

  def retryer
    Bosh::Retryable.new(
      tries: 300,
      sleep: ->(try_count, retry_exception) { 1 },
      on: [
        VSphereCloud::VirtualMachineNotFound,
        VSphereCloud::MultipleVirtualMachinesFound,
        VSphereCloud::VIFNotFound,
        VSphereCloud::LogicalPortNotFound,
        SegmentPortsAreNotInitialized,
        StillUpdatingVMsInGroups,
      ]
    ).retryer do |i|
      yield i if block_given?
    end
  end

  class SegmentPortsAreNotInitialized < StandardError; end
  class StillUpdatingVMsInGroups < StandardError; end
end
