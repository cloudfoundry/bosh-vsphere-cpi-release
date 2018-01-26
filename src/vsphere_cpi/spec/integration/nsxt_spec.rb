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
    NSXT::Client.new(@nsxt_host,@nsxt_username, @nsxt_password)
  end
  let(:nsgroup_name_1) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:nsgroup_name_2) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
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

    @nsxt_opaque_vlan_1 = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
    @nsxt_opaque_vlan_2 = fetch_property('BOSH_VSPHERE_SECOND_OPAQUE_VLAN')
  end

  after do
    if @nsxt_ca_cert
      ENV.delete('BOSH_NSXT_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
  end

  describe 'on create_vm', nsx_two_only: true do
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

            expected_context = { 'resource_type' => 'VifAttachmentContext', 'vif_type' => 'PARENT' }
            expect(lport.attachment['context']).to eq(expected_context)
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

              expect(lport.attachment['context']).to be_nil
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
            expect(lport.attachment['context']).to be_nil
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

          nsgroups = nsxt.nsgroups.select do |nsgroup|
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
                nsxt_vms = nsxt.virtual_machines(display_name: vm_id)
                raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
                raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

                external_id = nsxt_vms.first.external_id
                vifs = nsxt.vifs(owner_vm_id: external_id)
                expect(vifs.length).to eq(1)
                expect(vifs.first.lport_attachment_id).to be_nil
              end
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
          nsgroups = nsxt.nsgroups.select do |nsgroup|
            nsgroup.members.find do |member|
              member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == id
            end
          end

          expect(nsgroups).to eq([])
        end
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
            expect(logical_port.tags).to include(
              { 'scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest(bosh_id) }
            )
          end
        end
      end
    end
  end

  def verify_ports(vm_id, expected_vif_number = 2)
    retryer do
      nsxt_vms = nsxt.virtual_machines(display_name: vm_id)
      raise VSphereCloud::VirtualMachineNotFound.new(vm_id) if nsxt_vms.empty?
      raise VSphereCloud::MultipleVirtualMachinesFound.new(vm_id, nsxt_vms.length) if nsxt_vms.length > 1

      expect(nsxt_vms.length).to eq(1)
      expect(nsxt_vms.first.external_id).not_to be_nil

      vifs = nsxt.vifs(owner_vm_id: nsxt_vms.first.external_id)
      expect(vifs.length).to eq(expected_vif_number)
      expect(vifs.map(&:lport_attachment_id).compact.length).to eq(expected_vif_number)

      vifs.each do |vif|
        lport = nsxt.logical_ports(attachment_id: vif.lport_attachment_id).first
        yield lport if block_given?
      end
    end
  end

  def nsxt_client
    nsxt.instance_variable_get('@client')
  end

  def create_nsgroup(display_name)
    json = nsxt_client.post('ns-groups', body: {
      display_name: display_name
    }).body
    NSXT::NSGroup.new(nsxt_client,json['id'], json['display_name'], json['members'])
  end

  def delete_nsgroup(nsgroup)
    nsxt_client.delete("ns-groups/#{nsgroup.id}")
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    json = nsxt_client.get("ns-groups/#{nsgroup.id}/effective-logical-port-members").body
    json['results'].map { |member| member['target_id'] }
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
