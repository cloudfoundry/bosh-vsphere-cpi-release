require 'integration/spec_helper'

context 'when disk_pools.cloud_properties.datastores is specified' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    verify_non_overlapping_datastores(
      cpi_options,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @second_datastore,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )
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
    }
  end

  let(:options) do
    options = cpi_options(
      persistent_datastore_pattern: @datastore_pattern
    )
  end
  let(:persistent_datastores) { datastore_names_matching_pattern(@cpi, @cluster_name, @second_datastore) }
  let(:cloud_properties) { {'datastores' => persistent_datastores} }

  it 'places the disk in the specified datastore and does not move it when attached' do
    cpi = VSphereCloud::Cloud.new(options)
    begin
      director_disk_id = cpi.create_disk(128, cloud_properties)
      disk_id, _ = VSphereCloud::DiskMetadata.decode(director_disk_id)
      verify_disk_is_in_datastores(options, disk_id, persistent_datastores)
      expect(cpi.has_disk?(director_disk_id)).to be(true)

      vm_id = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        resource_pool,
        network_spec,
        [director_disk_id],
        {}
      )
      expect(vm_id).to_not be_nil

      cpi.attach_disk(vm_id, director_disk_id)
      verify_disk_is_in_datastores(options, disk_id, persistent_datastores)
      expect(cpi.has_disk?(director_disk_id)).to be(true)
    ensure
      detach_disk(cpi, vm_id, director_disk_id)
      delete_vm(cpi, vm_id)
      delete_disk(cpi, director_disk_id)
    end
  end
end
