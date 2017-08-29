require 'integration/spec_helper'
require 'pry-byebug'

describe 'NSX-T' do
  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @opaque_vlan },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options(nsxt: {
      host: @nsxt_host,
      username: @nsxt_username,
      password: @nsxt_password,
    }))
  end
  let(:nsxt) do
    VSphereCloud::NSXT::Client.new(@nsxt_host,@nsxt_username, @nsxt_password)
  end
  let(:nsgroup_name_1) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:nsgroup_name_2) { "BOSH-CPI-test-#{SecureRandom.uuid}" }
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'nsxt' => { 'nsgroups' => [nsgroup_name_1, nsgroup_name_2] }
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

    @opaque_vlan = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
  end

  after do
    if @nsxt_ca_cert
      ENV.delete('BOSH_NSXT_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
  end

  describe 'on create_vm' do
    context 'when the vm_type specifies an NSGroup' do
      context 'but the NSGroup does NOT exist' do
        it 'raises NSGroupsNotFound' do
          expect do
            vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id)
          end.to raise_error(VSphereCloud::NSGroupsNotFound)
        end
      end

      context 'and the NSGroup does exist' do
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

        it 'adds the logical port of the VM to all given NSGroups' do
          simple_vm_lifecycle(cpi, @opaque_vlan, vm_type) do |vm_id|
            external_id = nsxt.virtual_machines(display_name: vm_id).first.external_id
            attachment_id = nsxt.vifs(owner_vm_id: external_id).first.lport_attachment_id
            logical_port_id = nsxt.logical_ports(attachment_id: attachment_id).first.id

            nsgroups = nsxt.nsgroups.select do |nsgroup|
              [nsgroup_name_1, nsgroup_name_2].include?(nsgroup.display_name)
            end
            expect(nsgroups.length).to eq(2)

            expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).to include(logical_port_id)
            expect(nsgroup_effective_logical_port_member_ids(nsgroup_2)).to include(logical_port_id)
          end
        end

        context "but none of VM's networks are NSX-T Opaque Network (nsx.LogicalSwitch)" do
          it 'does NOT try to add VM to NSGroups' do
            simple_vm_lifecycle(cpi, @vlan, vm_type) do |vm_id|
              external_id = nsxt.virtual_machines(display_name: vm_id).first.external_id
              attachment_id = nsxt.vifs(owner_vm_id: external_id).first.lport_attachment_id
              logical_port_id = nsxt.logical_ports(attachment_id: attachment_id).first.id

              nsgroups = nsxt.nsgroups.select do |nsgroup|
                [nsgroup_name_1, nsgroup_name_2].include?(nsgroup.display_name)
              end
              expect(nsgroups.length).to eq(2)

              expect(nsgroup_effective_logical_port_member_ids(nsgroup_1)).to_not include(logical_port_id)
              expect(nsgroup_effective_logical_port_member_ids(nsgroup_2)).to_not include(logical_port_id)
            end
          end
        end
      end
    end
  end

  describe 'on delete_vm' do
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

      it "removes the VM's logical port from all NSGroups" do
        logical_port_id = nil
        simple_vm_lifecycle(cpi, @opaque_vlan, vm_type) do |vm_id|
          external_id = nsxt.virtual_machines(display_name: vm_id).first.external_id
          attachment_id = nsxt.vifs(owner_vm_id: external_id).first.lport_attachment_id
          logical_port_id = nsxt.logical_ports(attachment_id: attachment_id).first.id
        end

        expect(logical_port_id).not_to be_nil

        nsgroups = nsxt.nsgroups.select do |nsgroup|
          nsgroup.members.find do |member|
            member.target_type == 'LogicalPort' && member.target_property == 'id' && member.value == logical_port_id
          end
        end
        expect(nsgroups).to eq([])
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
    VSphereCloud::NSXT::NSGroup.new(nsxt_client, id: json['id'], display_name: json['display_name'], members: json['members'])
  end

  def delete_nsgroup(nsgroup)
    nsxt_client.delete(nsgroup.href)
  end

  def nsgroup_effective_logical_port_member_ids(nsgroup)
    json = nsxt_client.get("#{nsgroup.href}/effective-logical-port-members").body
    json['results'].map { |member| member['target_id'] }
  end
end