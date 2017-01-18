require 'integration/spec_helper'

describe 'nested datacenters', nested_datacenter: true  do

  before(:all) do
    @nested_datacenter_name = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    @nested_datacenter_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    @nested_datacenter_cluster_name = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    @nested_datacenter_resource_pool_name = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL')

    @nested_datacenter_vlan = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')
    @nested_datacenter_nested_vlan = fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_NESTED_VLAN')

    @nested_datacenter_cpi_options = cpi_options(
      datacenters: [{
        name: @nested_datacenter_name,
        datastore_pattern: @nested_datacenter_datastore_pattern,
        persistent_datastore_pattern: @nested_datacenter_datastore_pattern,
        clusters: [{@nested_datacenter_cluster_name => {'resource_pool' => @nested_datacenter_resource_pool_name}}]
      }]
    )
    @nested_datacenter_cpi = VSphereCloud::Cloud.new(@nested_datacenter_cpi_options)
    verify_datacenter_exists(@nested_datacenter_cpi, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    verify_datacenter_is_nested(@nested_datacenter_cpi, @nested_datacenter_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    verify_cluster(@nested_datacenter_cpi, @nested_datacenter_cluster_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    verify_datastore_within_cluster(
      @nested_datacenter_cpi,
      'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN',
      @nested_datacenter_datastore_pattern,
      @nested_datacenter_cluster_name
    )

    verify_resource_pool(@nested_datacenter_cpi, @nested_datacenter_cluster_name, @nested_datacenter_resource_pool_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    verify_vlan(@nested_datacenter_cpi, @nested_datacenter_vlan, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')
    verify_vlan(@nested_datacenter_cpi, @nested_datacenter_nested_vlan, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_NESTED_VLAN')
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => nested_datacenter_vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when datacenter is in folder' do
    let(:nested_datacenter_vlan) { @nested_datacenter_vlan }

    it 'exercises the vm lifecycle' do
      nested_datacenter_lifecycle
    end

    context 'and network is in a folder' do
      let(:nested_datacenter_vlan) { @nested_datacenter_nested_vlan }

      it 'exercises the vm lifecycle' do
        nested_datacenter_lifecycle
      end
    end
  end

  def nested_datacenter_lifecycle
    begin
      nested_datacenter_stemcell_id = nil
      Dir.mktmpdir do |temp_dir|
        output = `tar -C #{temp_dir} -xzf #{@stemcell_path} 2>&1`
        raise "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
        nested_datacenter_stemcell_id = @nested_datacenter_cpi.create_stemcell("#{temp_dir}/image", nil)
      end

      vm_lifecycle(@nested_datacenter_cpi, [], vm_type, network_spec, nested_datacenter_stemcell_id) do |vm_id|
        vm = @nested_datacenter_cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@nested_datacenter_cluster_name)
        expect(vm.resource_pool).to eq(@nested_datacenter_resource_pool_name)
      end
    ensure
      delete_stemcell(@nested_datacenter_cpi, nested_datacenter_stemcell_id)
    end
  end
end
