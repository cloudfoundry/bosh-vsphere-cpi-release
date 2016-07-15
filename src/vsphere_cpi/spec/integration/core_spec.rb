require 'integration/spec_helper'

context 'exercising core CPI functionality' do

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vlan) { @vlan }

  let(:resource_pool) do
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  describe 'deleting things that do not exist' do
    it 'raises the appropriate Clouds::Error' do
      expect {
        @cpi.delete_vm('fake-vm-cid')
      }.to raise_error(Bosh::Clouds::VMNotFound)

      expect {
        @cpi.delete_disk('fake-disk-cid')
      }.to raise_error(Bosh::Clouds::DiskNotFound)
    end
  end

  context 'without existing disks' do
    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [], resource_pool, network_spec, @stemcell_id)
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

  context 'with existing disks' do
    before { @existing_volume_id = @cpi.create_disk(2048, {}) }
    after { delete_disk(@cpi, @existing_volume_id) }

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [@existing_volume_id], resource_pool, network_spec, @stemcell_id)
    end
  end
end
