require 'integration/spec_helper'

describe 'Creating VM with existing persistent disks' do
  before(:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_shared_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SHARED_DATASTORE', @cluster_name)
    @cluster_one_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
  end

  context 'when there are existing persistent disks that needs to be migrated to new datastore' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1
      }
    end
    let(:cpi) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'datastore_pattern' => @datastore_shared_pattern,
            'persistent_datastore_pattern' => @datastore_shared_pattern,
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

    let(:cpi_different_persistent_pattern) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'datastore_pattern' => @datastore_shared_pattern,
            'persistent_datastore_pattern' => @cluster_one_datastore_pattern,
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

    before do
      @disk_id_one = cpi.create_disk(2048, {}, nil)
      @disk_id_two = cpi.create_disk(2048, {}, nil)
      expect(@disk_id_one).to_not be_nil
      expect(@disk_id_two).to_not be_nil
    end

    after do
      cpi.cleanup
      cpi_different_persistent_pattern.cleanup
    end

    it 'cpi should be able to create a VM' do
      begin
        vm_id = cpi_different_persistent_pattern.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [@disk_id_one, @disk_id_two],
          {}
        )
        expect(vm_id).to_not be_nil
        expect(cpi_different_persistent_pattern.has_vm?(vm_id)).to be(true)
      ensure
        delete_vm(cpi_different_persistent_pattern, vm_id)
      end
    end

    after do
      delete_disk(cpi, @disk_id_one)
      delete_disk(cpi, @disk_id_two)
    end
  end
end
