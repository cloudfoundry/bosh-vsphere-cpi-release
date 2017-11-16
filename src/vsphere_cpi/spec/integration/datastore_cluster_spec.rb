require 'integration/spec_helper'

context 'when regex matching datastores in a datastore cluster (datastore-*)' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_DATASTORE_CLUSTER', @cluster_name) # datastore-name-*
  end
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end
  let(:cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @datastore_pattern,
        persistent_datastore_pattern: @datastore_pattern,
      }],
    )
    VSphereCloud::Cloud.new(options)
  end

  it 'should place disk into datastores that belong to the datastore cluster' do
    begin
      @vm_id = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        get_network_spec,
        [],
        {}
      )
      expect(@vm_id).to_not be_nil
      expect(cpi.has_vm?(@vm_id)).to be(true)

      @disk_id = cpi.create_disk(2048, {}, nil)
      expect(@disk_id).to_not be_nil
      expect(cpi.has_disk?(@disk_id)).to be(true)
      disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(@disk_id))
      expect(disk.datastore.name).to match(@datastore_pattern)
    ensure
      delete_vm(cpi, @vm_id)
      delete_disk(cpi, @disk_id)
    end
  end
end

context 'when cluster is not defined in global config' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_DATASTORE_CLUSTER', @cluster_name) #local-ds*
    @cluster_name_3 = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_THIRD_CLUSTER')
    @datastore_cluster_3 = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_CLUSTER_3', @cluster_name_3) #isc-cl3-ds0
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
  end
  let(:vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datacenters' => [
            {
                'name' => @datacenter_name,
                'datastores' =>  [@datastore_cluster_3],
                'clusters' => [
                    {
                        @cluster_name_3 => {}
                    }
                ]
            }
        ]
    }
  end
  let(:cpi) do
    options = cpi_options(
        'datacenters' => [
            {
                'name' => @datacenter_name,
                'datastore_pattern' => @datastore_pattern,
                'persistent_datastore_pattern' => @datastore_pattern,
                'clusters' => [
                    {
                        @cluster_name => {}
                    },
                ]
            }
        ]
    )
    VSphereCloud::Cloud.new(options)
  end

  let(:cpi2) do
    options = cpi_options(
        'datacenters' => [
            {
                'name' => @datacenter_name,
                'datastore_pattern' => @datastore_pattern,
                'persistent_datastore_pattern' => @datastore_pattern,
                'clusters' => [
                    {
                        @cluster_name_3 => {}
                    },
                ]
            }
        ]
    )
    VSphereCloud::Cloud.new(options)
  end

  let(:disk_pool) { { 'datastores' => [@datastore_cluster_3] } }

  it 'should place disk into datastore that belongs to the cluster defined in cloud config' do
    begin
      vm_id = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [],
          {}
      )
      expect(vm_id).to_not be_nil
      vm = cpi.vm_provider.find(vm_id)
      expect(vm.cluster).to eq(@cluster_name_3)
      expect(cpi.has_vm?(vm_id)).to be(true)
      disk_id = cpi.create_disk(2048, disk_pool, vm_id)
      expect(disk_id).to_not be_nil
      expect(cpi2.has_disk?(disk_id)).to be(true)
      disk = cpi2.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(disk_id))
      expect(disk.datastore.name).to eq(@datastore_cluster_3)
    ensure
      delete_vm(cpi, vm_id)
      delete_disk(cpi2, disk_id)
    end
  end

end