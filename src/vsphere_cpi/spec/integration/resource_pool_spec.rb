require 'integration/spec_helper'

context 'given a CPI configured with vSphere resource pools' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @resource_pool_name = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_RESOURCE_POOL', @cluster_name)
    @second_resource_pool_name = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL', @cluster_name)

    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE', @second_cluster_name)
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
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:resource_pool_cpi) do
    options = cpi_options(
      datacenters: [{
        clusters: [{ @cluster_name => {'resource_pool' => @resource_pool_name} }],
      }]
    )
    VSphereCloud::Cloud.new(options)
  end

  it 'should exercise the vm lifecycle' do
    vm_lifecycle(resource_pool_cpi, [], resource_pool, network_spec, @stemcell_id) do |vm_id|
      vm = resource_pool_cpi.vm_provider.find(vm_id)
      expect(vm.resource_pool).to eq(@resource_pool_name)
    end
  end

  context 'when a VM already exists in a vSphere resource pool' do
    vm_id = nil

    before do
      vm_id = resource_pool_cpi.create_vm(
        'agent-007',
        @stemcell_id,
        resource_pool,
        network_spec,
        [],
        {}
      )
      expect(vm_id).to_not be_nil
    end

    after do
      delete_vm(resource_pool_cpi, vm_id)
    end

    context 'and a second CPI is not configured with the resource pool' do
      let(:second_cpi) do
        options = cpi_options(
          datacenters: [{
            clusters: [@cluster_name]
          }],
        )
        VSphereCloud::Cloud.new(options)
      end

      it 'can still find a vm created by a cpi configured with a vSphere resource pool' do
        expect(second_cpi.has_vm?(vm_id)).to be(true)
      end

      it 'can still find the stemcell created by a cpi configured with a vSphere resource pool' do
        expect(second_cpi.stemcell_vm(@stemcell_id)).to_not be_nil
      end
    end
  end

  context 'when vm_type.resource_pool is set to a cluster' do
    let(:second_cluster_cpi) do
      options = cpi_options(
        datacenters: [{
          datastore_pattern: @second_cluster_datastore_pattern,
          persistent_datastore_pattern: @second_cluster_datastore_pattern,
          clusters: [@second_cluster_name]
        }]
      )
      VSphereCloud::Cloud.new(options)
    end

    before do
      resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@second_cluster_name => {}}]}]
    end

    it 'places vm in provided cluster' do
      vm_lifecycle(second_cluster_cpi, [], resource_pool, network_spec, @stemcell_id) do |vm_id|
        vm = second_cluster_cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@second_cluster_name)
      end
    end
  end

  context 'when vm_type.resource_pool is set to a resource pool within the cluster' do
    before do
      resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster_name => {'resource_pool' => @second_resource_pool_name}}]}]
    end

    it 'places vm in the specified resource pool, overriding the globally configured resource pool' do
      begin
        vm_id = resource_pool_cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec
        )

        vm = resource_pool_cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@cluster_name)
        expect(vm.resource_pool).to eq(@second_resource_pool_name)
      ensure
        delete_vm(resource_pool_cpi, vm_id)
      end
    end
  end
end
