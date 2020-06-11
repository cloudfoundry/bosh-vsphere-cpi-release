require 'digest'
require 'securerandom'
require 'integration/spec_helper'

describe 'CPI', nvds: true, cvds: true do

  before(:all) do
    # Read basic info about env
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

    # Configure a user/pass client to add cert/key
    # Client built Directly in TEST. NOT USING NSXTApiClientBuilder
    configuration = NSXT::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = @nsxt_username
    configuration.password = @nsxt_password
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false
    client = NSXT::ApiClient.new(configuration)

    # Add cert and key
    @nsx_component_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementCertificateApi.new(client)
    @nsx_component_trust_mgmt_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementPrincipalIdentityApi.new(client)
    @private_key = generate_private_key
    @certificate = generate_certificate(@private_key)
    @cert_id = submit_cert_to_nsxt(@certificate)
    @principal_id = attach_cert_to_principal(@cert_id)
  end

  after(:all) do
    delete_principal(@principal_id) unless @principal_id.nil?
    delete_test_certificate(@cert_id) unless @cert_id.nil?
    if @nsxt_ca_cert
      ENV.delete('BOSH_NSXT_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
  end

  # This works exclusively with cert/key pair
  # Utilizes the CPI code in NSXTApiClientBuilder
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
      host: @nsxt_host,
      auth_certificate: @certificate.to_s,
      auth_private_key: @private_key.to_s
    }))
  end

  # Verifier Client using user/pass. Built Directly in TEST
  let(:nsxt) do
    configuration = NSXT::Configuration.new
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
    NSXT::ApiClient.new(configuration)
  end
  let(:nsgroup_name_1) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:nsgroup_name_2) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:server_pool_name_1) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:server_pool_name_2) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
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

  describe 'on create_vm' do
    context 'when global default_vif_type is set' do
      # This works exclusively with cert/key pair
      # Utilizes the CPI code in NSXTApiClientBuilder
      let(:cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          auth_certificate: @certificate.to_s,
          auth_private_key: @private_key.to_s,
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

      context 'but at least one of the NSGroups does NOT exists' do
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
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
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
                fabric_svc = NSXT::ManagementPlaneApiFabricVirtualMachinesApi.new(nsxt)
                nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
                raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
                raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

                external_id = nsxt_vms.first.external_id
                vif_fabric_svc ||= NSXT::ManagementPlaneApiFabricVifsApi.new(nsxt)
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
                  'name' => server_pool_name_1,
                  'port' => port_no
                },
                {
                  'name' => server_pool_name_2,
                  'port' => 80
                }
              ]
            }
          }
        }
      end
      context 'but atleast one server pool does not exists' do
        it 'raises an error' do
          expect do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type)
          end.to raise_error(VSphereCloud::ServerPoolsNotFound)
        end
      end
      context 'and all server pools exist' do
        let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
        let!(:server_pool_1) { create_static_server_pool(server_pool_name_1) }
        let!(:server_pool_2) { create_dynamic_server_pool(server_pool_name_2, nsgroup_1) }

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
        it 'adds vm to all existing static server pools with given name' do
          begin
            server_pool_3 = create_static_server_pool(server_pool_name_1) #server pool with same name as server_pool_1
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              vm_ip = vm.mob.guest&.ip_address
              expect(vm_ip).to_not be_nil
              server_pool_1_members = find_pool_members(server_pool_1, vm_ip, port_no)
              expect(server_pool_1_members.count).to eq(1)
              server_pool_3_members = find_pool_members(server_pool_3, vm_ip, port_no)
              expect(server_pool_3_members.count).to eq(1)
            end
          ensure
            delete_server_pool(server_pool_3)
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
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
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
                'name' => server_pool_name_1,
                'port' => port_no1
              },
              {
                'name' => server_pool_name_1,
                'port' => port_no2
              },
              {
                'name' => server_pool_name_2,
                'port' => port_no1
              }
            ]
          }
        }
      }
      let!(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
      let!(:server_pool_1) { create_static_server_pool(server_pool_name_1) }
      let!(:server_pool_2) { create_dynamic_server_pool(server_pool_name_2, nsgroup_1) }
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
          grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
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
  end

  describe 'on_set_vm_metadata' do
    context 'with bosh id' do
      let(:bosh_id) { SecureRandom.uuid }

      it "tags the VM's logical ports with the bosh id" do
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          cpi.set_vm_metadata(vm_id, 'id' => bosh_id)
          verify_ports(vm_id) do |logical_port|
            expect(logical_port.tags.first.scope).to eq('bosh/id')
            expect(logical_port.tags.first.tag).to eq(Digest::SHA1.hexdigest(bosh_id))
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
      fabric_svc = NSXT::ManagementPlaneApiFabricVirtualMachinesApi.new(nsxt)
      nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
      raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
      raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

      expect(nsxt_vms.length).to eq(1)
      expect(nsxt_vms.first.external_id).not_to be_nil

      vif_fabric_svc ||= NSXT::ManagementPlaneApiFabricVifsApi.new(nsxt)
      vifs = vif_fabric_svc.list_vifs(:owner_vm_id => nsxt_vms.first.external_id).results
      raise VSphereCloud::VIFNotFound.new(vm_id, nsxt_vms.first.external_id) if vifs.empty?
      expect(vifs.length).to eq(expected_vif_number)
      expect(vifs.map(&:lport_attachment_id).compact.length).to eq(expected_vif_number)

      logical_switching_svc = NSXT::ManagementPlaneApiLogicalSwitchingLogicalSwitchPortsApi.new(nsxt)
      vifs.each do |vif|
        lports = logical_switching_svc.list_logical_ports(attachment_id: vif.lport_attachment_id).results.first
        yield lports if block_given?
      end
    end
  end

  def nsxt_client
    nsxt.instance_variable_get('@client')
  end

  def create_nsgroup(display_name)
    nsgrp = NSXT::NSGroup.new(:display_name => display_name)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
    grouping_object_svc.create_ns_group(nsgrp)
  end

  def delete_nsgroup(nsgroup)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
    grouping_object_svc.delete_ns_group(nsgroup.id)
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    grouping_object_svc = NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(nsxt)
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
    NSXT::ManagementPlaneApiServicesLoadbalancerApi.new(nsxt)
  end

  def retryer
    Bosh::Retryable.new(
      tries: 61,
      sleep: ->(try_count, retry_exception) { 1 },
      on: [
        VSphereCloud::VirtualMachineNotFound,
        VSphereCloud::MultipleVirtualMachinesFound,
        VSphereCloud::VIFNotFound,
        VSphereCloud::LogicalPortNotFound
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

  def attach_cert_to_principal(cert_id, pi_name = 'testprincipal-nsxt-spec-3', node_id = 'node-nsxt-spec-3')
    pi = NSXT::PrincipalIdentity.new(name: pi_name, node_id: node_id,
                                     certificate_id: cert_id, permission_group: 'superusers')
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

end
