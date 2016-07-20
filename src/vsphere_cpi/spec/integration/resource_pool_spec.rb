require 'integration/spec_helper'

context 'given a cpi that is configured' do
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
    }
  end

  context 'without specifying the vSphere resource pool' do
    let(:second_cpi) do
      options = cpi_options(
      clusters: [@cluster]
      )
      VSphereCloud::Cloud.new(options)
    end

    it 'can still find a vm created by a cpi configured with a vSphere resource pool' do
      begin
        vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        resource_pool,
        network_spec,
        [],
        {}
        )

        expect(vm_id).to_not be_nil
        expect(second_cpi.has_vm?(vm_id)).to be(true)
      ensure
        delete_vm(@cpi, vm_id)
      end
    end

    it 'can still find the stemcell created by a cpi configured with a vSphere resource pool' do
      expect(second_cpi.stemcell_vm(@stemcell_id)).to_not be_nil
    end

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(second_cpi, [], resource_pool, network_spec, @stemcell_id)
    end
  end

  context 'when resource_pool is set to the first cluster' do
    it 'places vm in first cluster when vsphere resource pool is not provided' do
      begin
        resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {}}]}]
        vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec
        )

        vm = @cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@cluster)
        default_resource_pool = @resource_pool_name
        expect(vm.resource_pool).to_not eq(default_resource_pool)
      ensure
        delete_vm(@cpi, vm_id)
      end
    end

    it 'places vm in the specified resource pool when vsphere resource pool is provided' do
      begin
        resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {'resource_pool' => @second_resource_pool_within_cluster}}]}]
        vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec
        )

        vm = @cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@cluster)
        expect(vm.resource_pool).to eq(@second_resource_pool_within_cluster)
      ensure
        delete_vm(@cpi, vm_id)
      end
    end
  end

  context 'when resource_pool is set to the second cluster' do
    it 'places vm in second cluster' do
      options = cpi_options(
        datastore_pattern: @second_cluster_datastore,
        persistent_datastore_pattern: @second_cluster_datastore
      )
      second_cluster_cpi = VSphereCloud::Cloud.new(options)
      resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@second_cluster => {}}]}]
      vm_lifecycle(second_cluster_cpi, [], resource_pool, network_spec, @stemcell_id) do |vm_id|
        vm = second_cluster_cpi.vm_provider.find(vm_id)
        expect(vm.cluster).to eq(@second_cluster)
      end
    end
  end
end
