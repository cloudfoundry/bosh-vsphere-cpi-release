require 'integration/spec_helper'

describe 'NSX integration', nsx: true do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')

    @nsx_address = fetch_property('BOSH_VSPHERE_CPI_NSX_ADDRESS')
    @nsx_user = fetch_property('BOSH_VSPHERE_CPI_NSX_USER')
    @nsx_password = fetch_property('BOSH_VSPHERE_CPI_NSX_PASSWORD')
  end

  let(:tag) { "BOSH-CPI-test-#{SecureRandom.uuid}" }

  let(:cpi) do
    VSphereCloud::Cloud.new(nsx_options)
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => @vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:resource_pool) do
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
      'nsx' => {
        'security_tags' => [
          tag,
        ],
      },
    }
  end

  context 'when the Director\'s manifest has an NSX Manager configuration' do
    let(:nsx_options) do
      cpi_options(
        nsx: {
          address: @nsx_address,
          user: @nsx_user,
          password: @nsx_password,
        },
      )
    end

    after do
      begin
        cpi.nsx.delete_tag(tag)
      # rescue => e
      #   puts e
      #   # ignore clean-up errors
      end
    end

    context 'and a vm_type specifies an nsx security tag' do
      it 'creates the tag' do
        vm_lifecycle(cpi, [], resource_pool, network_spec, @stemcell_id) do |vm_id|
          vm_ids = cpi.nsx.get_vms_for_tag(tag)
          expect(vm_ids).to eq([vm_id])
        end
      end

      it 'creates the second time without raising an error' do
        begin
          vm_id1 = create_vm_with_resource_pool(cpi, resource_pool, @stemcell_id)
          vm_ids = cpi.nsx.get_vms_for_tag(tag)
          expect(vm_ids).to contain_exactly(vm_id1)

          vm_id2 = create_vm_with_resource_pool(cpi, resource_pool, @stemcell_id)
          vm_ids = cpi.nsx.get_vms_for_tag(tag)
          expect(vm_ids).to contain_exactly(vm_id1, vm_id2)
        ensure
          delete_vm(cpi, vm_id1)
          delete_vm(cpi, vm_id2)
        end
      end
    end

    context 'when the NSX password information is incorrect' do
      let(:nsx_options) do
        cpi_options(
          nsx: {
            address: @nsx_address,
            user: @nsx_user,
            password: 'fake-bad-password',
          },
        )
      end

      context 'and a vm_type specifies an nsx security tag' do
        it 'raises an error' do
          expect {
            create_vm_with_resource_pool(cpi, resource_pool, @stemcell_id)
          }.to raise_error(/Bad Username or Credentials presented/)
        end
      end

    end
  end

  context 'when there\'s no NSX configuration in the Director\'s manifest' do
    let(:nsx_options) do
      cpi_options
    end

    context 'and a vm_type specifies an nsx security tag' do
      it 'raises an error' do
        expect {
          create_vm_with_resource_pool(cpi, resource_pool, @stemcell_id)
        }.to raise_error(/NSX/)
      end
    end
  end
end
