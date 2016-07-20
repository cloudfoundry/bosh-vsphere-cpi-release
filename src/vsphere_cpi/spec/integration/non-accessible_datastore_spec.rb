require 'integration/spec_helper'

context 'when disk is in non-accessible datastore' do
  let(:vm_cluster) { @cluster }
  let(:cpi_for_vm) do
    options = cpi_options
    options['vcenters'].first['datacenters'].first['clusters'] = [
      { vm_cluster => {'resource_pool' => @resource_pool_name} }
    ]
    VSphereCloud::Cloud.new(options)
  end
  let(:resource_pool) do
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }
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

  it 'creates disk in accessible datastore' do
    begin
      accessible_datastores = datastores_accessible_from_cluster(@cpi, @cluster)

      vm_id = create_vm_with_cpi(cpi_for_vm, @stemcell_id)
      expect(vm_id).to_not be_nil

      disk_id = @cpi.create_disk(128, {}, vm_id)

      verify_disk_is_in_datastores(disk_id, accessible_datastores)
    ensure
      delete_vm(@cpi, vm_id)
      delete_disk(@cpi, disk_id)
    end
  end

  it 'migrates disk to accessible datastore' do
    begin
      options = cpi_options
      options['vcenters'].first['datacenters'].first.merge!(
        {
          'datastore_pattern' => @second_cluster_datastore,
          'persistent_datastore_pattern' => @second_cluster_datastore,
          'clusters' => [{@second_cluster => {'resource_pool' => @second_cluster_resource_pool_name}}]
        }
      )
      cpi_for_non_accessible_datastore = VSphereCloud::Cloud.new(options)

      accessible_datastores = datastores_accessible_from_cluster(@cpi, vm_cluster)
      expect(accessible_datastores).to_not include(@second_cluster_datastore)

      vm_id = create_vm_with_cpi(cpi_for_vm, @stemcell_id)
      expect(vm_id).to_not be_nil
      disk_id = cpi_for_non_accessible_datastore.create_disk(128, {}, nil)
      disk = find_disk_in_datastore(disk_id, @second_cluster_datastore)
      expect(disk).to_not be_nil

      @cpi.attach_disk(vm_id, disk_id)

      verify_disk_is_in_datastores(disk_id, accessible_datastores)
    ensure
      detach_disk(@cpi, vm_id, disk_id)
      delete_vm(@cpi, vm_id)
      delete_disk(@cpi, disk_id)
    end
  end
end
