require 'integration/spec_helper'

describe 'NSX integration', nsx: true do

  before (:all) do
    @nsx_address = fetch_property('BOSH_VSPHERE_CPI_NSX_ADDRESS')
    @nsx_user = fetch_property('BOSH_VSPHERE_CPI_NSX_USER')
    @nsx_password = fetch_property('BOSH_VSPHERE_CPI_NSX_PASSWORD')
    @nsx_ca_cert = ENV['BOSH_VSPHERE_CPI_NSX_CA_CERT']
    if @nsx_ca_cert
      @ca_cert_file = Tempfile.new('bosh-cpi-ca-cert')
      @ca_cert_file.write(@nsx_ca_cert)
      @ca_cert_file.close
      ENV['BOSH_NSX_CA_CERT_FILE'] = @ca_cert_file.path
    end

    @nsx_lb_name = fetch_property('BOSH_VSPHERE_CPI_NSX_LB_NAME')
    @nsx_pool_name = fetch_property('BOSH_VSPHERE_CPI_NSX_POOL_NAME')
  end

  after (:all) do
    if @nsx_ca_cert
      ENV.delete('BOSH_NSX_CA_CERT_FILE')
      @ca_cert_file.unlink
    end
  end

  let(:security_group) { "BOSH-CPI-test-#{SecureRandom.uuid}" }

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

  let(:base_vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

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
      cpi.nsx.delete_security_group(security_group)
    rescue => e
      # ignore clean-up errors
      puts e
    end
  end

  context 'when vm_type specifies an nsx Security Group' do
    let(:vm_type) do
      base_vm_type.merge({
        'nsx' => {
          'security_groups' => [
            security_group,
          ],
        },
      })
    end

    it 'creates the Security Group' do
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id) do |vm_id|
        vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
        expect(vm_ids).to eq([vm_id])
      end
    end

    it 'adds a second VM to the Security Group' do
      begin
        vm_id1 = create_vm_with_vm_type(cpi, vm_type, @stemcell_id)
        vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
        expect(vm_ids).to contain_exactly(vm_id1)

        # avoid IP collision
        network_spec['static']['ip'] = "169.254.0.#{rand(4..254)}"
        vm_id2 = create_vm_with_vm_type(cpi, vm_type, @stemcell_id)
        vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
        expect(vm_ids).to contain_exactly(vm_id1, vm_id2)
      ensure
        delete_vm(cpi, vm_id1)
        delete_vm(cpi, vm_id2)
      end
    end

    context 'when the BOSH Director specifies a set of groups' do
      let(:vm_type) { base_vm_type }
      let(:environment) do
        {
          'bosh' => {
            'groups' => [
              security_group,
            ]
          }
        }
      end

      it 'creates a Security Group for each BOSH group' do
        vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, environment) do |vm_id|
          vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
          expect(vm_ids).to eq([vm_id])
        end
      end

      context 'and there\'s no NSX configuration in the Director\'s manifest' do
        let(:nsx_options) do
          cpi_options
        end

        it 'does not attempt to create security groups' do
          vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, environment)
        end
      end

      context 'and vm_type specifies a duplicate nsx Security Group' do
        let(:vm_type) do
          base_vm_type.merge({
            'nsx' => {
              'security_groups' => [
                security_group,
              ],
            },
          })
        end

        it 'adds the VM to the Security Group' do
          vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, environment) do |vm_id|
            vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
            expect(vm_ids).to eq([vm_id])
          end
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

      it 'raises an error' do
        expect {
          create_vm_with_vm_type(cpi, vm_type, @stemcell_id)
        }.to raise_error(/Bad Username or Credentials presented/)
      end
    end

    context 'when there\'s no NSX configuration in the Director\'s manifest' do
      let(:nsx_options) do
        cpi_options
      end

      it 'raises an error' do
        expect {
          create_vm_with_vm_type(cpi, vm_type, @stemcell_id)
        }.to raise_error(/NSX/)
      end
    end
  end

  context 'when vm_extensions has an NSX load balancer and pool' do
    let(:vm_type) do
      base_vm_type.merge({
        'nsx' => {
          'lbs' => [
            {
              'edge_name' => @nsx_lb_name,
              'pool_name' => @nsx_pool_name,
              'security_group' => security_group,
              'port' => 443,
              'monitor_port' => 443,
            },
            {
              'edge_name' => @nsx_lb_name,
              'pool_name' => @nsx_pool_name,
              'security_group' => security_group,
              'port' => 80,
            }
          ],
        },
      })
    end

    before do
      cpi.nsx.remove_pool_members(@nsx_lb_name, @nsx_pool_name)
    end

    after do
      cpi.nsx.remove_pool_members(@nsx_lb_name, @nsx_pool_name)
    end

    it 'creates a Security Group for the NSX load balancer and pool' do
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id) do |vm_id|
        vm_ids = cpi.nsx.get_vms_in_security_group(security_group)
        expect(vm_ids).to include(vm_id)

        members = cpi.nsx.get_pool_members(@nsx_lb_name, @nsx_pool_name)
        expect(members).to contain_exactly(
          {
            'group_name' => security_group,
            'port' => '443',
            'monitor_port' => '443',
          },
          {
            'group_name' => security_group,
            'port' => '80',
            'monitor_port' => '80',
          }
        )
      end
    end
  end
end
