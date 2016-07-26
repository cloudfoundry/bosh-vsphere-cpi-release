require 'integration/spec_helper'

context 'when disk is in non-accessible datastore' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @second_cluster_name)
  end

  let(:cpi_for_vm) do
    options = cpi_options(
      clusters: [@cluster_name]
    )
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

  context 'when a VM hint is provided during disk creation' do
    let(:existing_vm_id) do
      vm_id = create_vm_with_cpi(cpi_for_vm, @stemcell_id)
      expect(vm_id).to_not be_nil
      vm_id
    end

    after do
      delete_vm(@cpi, existing_vm_id)
    end

    it 'creates disk in an accessible datastore' do
      begin
        datastores_accessible_to_vm = datastores_accessible_from_cluster(@cpi, @cluster_name)
        disk_id = @cpi.create_disk(128, {}, existing_vm_id)

        verify_disk_is_in_datastores(disk_id, datastores_accessible_to_vm)
      ensure
        delete_disk(@cpi, disk_id)
      end
    end
  end

  context 'when disk exists in a non-accessible datastore' do
    let(:existing_vm_id) do
      vm_id = create_vm_with_cpi(cpi_for_vm, @stemcell_id)
      expect(vm_id).to_not be_nil
      vm_id
    end
    let(:accessible_datastores) do
      accessible_datastores = datastores_accessible_from_cluster(@cpi, @cluster_name)
      expect(accessible_datastores).to_not include(@second_cluster_datastore)
      accessible_datastores
    end
    let(:existing_disk_id) do
      options = cpi_options
      options['vcenters'].first['datacenters'].first.merge!(
        {
          'datastore_pattern' => @second_cluster_datastore,
          'persistent_datastore_pattern' => @second_cluster_datastore,
          'clusters' => [{@second_cluster => {'resource_pool' => @second_cluster_resource_pool_name}}]
        }
      )
      cpi_for_non_accessible_datastore = VSphereCloud::Cloud.new(options)

      disk_id = cpi_for_non_accessible_datastore.create_disk(128, {}, nil)
      expect(disk_id).to_not be_nil

      disk_id
    end

    after do
      delete_disk(@cpi, existing_disk_id)
      delete_vm(@cpi, existing_vm_id)
    end

    it 'migrates disk to a datastore accessible to the VM on attach' do
      begin
        verify_disk_is_not_in_datastores(existing_disk_id, accessible_datastores)

        @cpi.attach_disk(existing_vm_id, existing_disk_id)

        verify_disk_is_in_datastores(existing_disk_id, accessible_datastores)
      ensure
        detach_disk(@cpi, existing_vm_id, existing_disk_id)
      end
    end
  end

  context 'when requested placement cannot be satisfied' do
    let(:mismatch_cpi) do
      options_with_cluster_datastore_mismatch = cpi_options(
        datastore_pattern: @second_cluster_datastore,
        persistent_datastore_pattern: @second_cluster_datastore,
        clusters: [@cluster_name], # cluster 1 does not have access to cluster 2's datastore
      )
      VSphereCloud::Cloud.new(options_with_cluster_datastore_mismatch)
    end

    it 'raises an error containing target cluster and datastore' do
      expect {
        mismatch_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
      }.to raise_error { |error|
        expect(error).to be_a(Bosh::Clouds::CloudError)
        expect(error.message).to include(@second_cluster_datastore)
        expect(error.message).to include('No valid placement found for disks')
      }
    end
  end
end
