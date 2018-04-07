require 'digest'
require 'securerandom'
require 'integration/spec_helper'

describe 'CPI', nsx_transformers: true do
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
      host: @nsxt_host,
      username: @nsxt_username,
      password: @nsxt_password
    }))
  end
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

  before do
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

    @nsxt_opaque_vlan_1 = 'pks-vif-switch' #TODO update this in nimbus and then revert this change
    @nsxt_opaque_vlan_2 = 'service-vif-switch'
  end

  after do
    if @nsxt_ca_cert
      ENV.delete('BOSH_NSXT_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
  end

  describe 'on create_vm', nsxt_version_two: true do
    context 'when global default_vif_type is set' do
      let(:cpi) do
        VSphereCloud::Cloud.new(cpi_options(nsxt: {
          host: @nsxt_host,
          username: @nsxt_username,
          password: @nsxt_password,
          default_vif_type: 'PARENT'
        }))
      end

      it 'sets vif_type for logical ports' do
        simple_vm_lifecycle(cpi, '', vm_type, network_spec) do |vm_id|
          verify_ports(vm_id) do |lport|
            expect(lport).not_to be_nil
            expect(lport.attachment.context.resource_type).to eq('VifAttachmentContext')
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

      context 'but at least one of the NSGroups does NOT exist' do
        it 'raises NSGroupsNotFound' do
          expect do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type)
          end.to raise_error(VSphereCloud::NSGroupsNotFound)
        end
      end

      context 'and all the NSGroups exist' do
        let(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
        let(:nsgroup_2) { create_nsgroup(nsgroup_name_2) }
        before do
          expect(nsgroup_1).to_not be_nil
          expect(nsgroup_2).to_not be_nil
          grouping_object_svc = NSXT::GroupingObjectsApi.new(nsxt)
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
                fabric_svc = NSXT::FabricApi.new(nsxt)
                nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
                raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
                raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

                external_id = nsxt_vms.first.external_id
                vifs = fabric_svc.list_vifs(:owner_vm_id => external_id).results
                expect(vifs.length).to eq(1)
                expect(vifs.first.lport_attachment_id).to be_nil
              end
            end
          end
        end
      end
    end

    context 'when load balancers are specified' do
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

      context 'but atleast one server pool does not exist' do
        it 'raises an error' do
          expect do
            simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type)
          end.to raise_error(VSphereCloud::ServerPoolsNotFound)
        end
      end
      context 'and all server pool exists' do
        let(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
        let(:server_pool_1) { create_server_pool(server_pool_name_1) }
        let(:server_pool_2) { create_server_pool(server_pool_name_2, nsgroup_1) }

        before do
          expect(server_pool_1).to_not be_nil
          expect(server_pool_2).to_not be_nil
        end

        after do
          delete_server_pool(server_pool_1)
          delete_server_pool(server_pool_2)
          delete_nsgroup(nsgroup_1)
        end

        it 'adds vm to existing static server pools and adds all logical ports of the VM to NSGroups associated with the dynamic server pool' do
          simple_vm_lifecycle(cpi, @nsxt_opaque_vlan_1, vm_type) do |vm_id|
            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            vm_ip = vm.mob.guest&.ip_address
            expect(vm_ip).to_not be_nil
            verify_pool_member(server_pool_1, vm_ip, port_no)
            verify_ports(vm_id, 1) do |lport|
              expect(lport).not_to be_nil

              expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).to include(lport.id)
            end
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
        'nsxt' => { 'ns_groups' => [nsgroup_name_1, nsgroup_name_2] }
      }
    end

    context 'when NSX-T is enabled' do
      let(:nsgroup_1) { create_nsgroup(nsgroup_name_1) }
      let(:nsgroup_2) { create_nsgroup(nsgroup_name_2) }
      before do
        expect(nsgroup_1).to_not be_nil
        expect(nsgroup_2).to_not be_nil
      end
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
          grouping_object_svc = NSXT::GroupingObjectsApi.new(nsxt)
          nsgroups = grouping_object_svc.list_ns_groups.results.select do |nsgroup|
            next unless nsgroup.members
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end

          expect(nsgroups).to eq([])
        end
      end
      xit 'removes VM from all server pools' do

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

  private

  def verify_ports(vm_id, expected_vif_number = 2)
    retryer do
      fabric_svc = NSXT::FabricApi.new(nsxt)
      nsxt_vms = fabric_svc.list_virtual_machines(:display_name => vm_id).results
      raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
      raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

      expect(nsxt_vms.length).to eq(1)
      expect(nsxt_vms.first.external_id).not_to be_nil

      vifs = fabric_svc.list_vifs(:owner_vm_id => nsxt_vms.first.external_id).results
      expect(vifs.length).to eq(expected_vif_number)
      expect(vifs.map(&:lport_attachment_id).compact.length).to eq(expected_vif_number)

      logical_switching_svc = NSXT::LogicalSwitchingApi.new(nsxt)
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
    grouping_object_svc = NSXT::GroupingObjectsApi.new(nsxt)
    grouping_object_svc.create_ns_group(nsgrp)
  end

  def delete_nsgroup(nsgroup)
    grouping_object_svc = NSXT::GroupingObjectsApi.new(nsxt)
    grouping_object_svc.delete_ns_group(nsgroup.id)
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    grouping_object_svc = NSXT::GroupingObjectsApi.new(nsxt)
    results = grouping_object_svc.get_effective_logical_port_members(nsgroup.id).results
    results.map { |member| member.target_id }
  end

  def create_server_pool(pool_name, nsgroup=nil)
    server_pool = NSXT::LbPool.new(display_name: pool_name)
    if nsgroup
      resource = NSXT::ResourceReference.new(target_id: nsgroup.id, target_type: nsgroup.resource_type, target_display_name: nsgroup.display_name)
      server_pool.member_group = NSXT::PoolMemberGroup.new(grouping_object: resource, max_ip_list_size: 2)
    end
    services_svc.create_load_balancer_pool(server_pool)
  end

  def verify_pool_member(server_pool, ip_address, port_no)
    server_pool = services_svc.read_load_balancer_pool(server_pool.id)
    matching_members = server_pool.members.select{ |member| member.ip_address == ip_address && member.port == port_no }
    expect(matching_members.count).to eq(1)
  end

  def delete_server_pool(server_pool)
    services_svc.delete_load_balancer_pool(server_pool.id)
  end

  def services_svc
    NSXT::ServicesApi.new(nsxt)
  end

  def retryer
    Bosh::Retryable.new(
      tries: 20,
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
end
