require 'integration/spec_helper'

context 'when regex matching datastores in a datastore cluster (datastore-*)' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER_DATASTORE_MAINTENANCE')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_DATASTORE_CLUSTER_DATASTORE_MAINTENANCE', @cluster_name) # datastore-name-*
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
        clusters: [
          {
            @cluster_name => {}
          }]
      }]
    )
    VSphereCloud::Cloud.new(options)
  end

  context'when all datastores present in cluster are in maintenance mode' do
    before do
      all_pattern_datastore_enter_maintenance_mode(cpi, @cluster_name, @datastore_pattern)
    end
    after do
      all_pattern_datastore_exit_maintenance_mode
    end
    it 'should raise error for datastores in maintenance mode' do
      begin
        expect {
          cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            get_network_spec,
            [],
            {}
          )
        }.to raise_error(/No valid placement found for disks/)

        expect {
          cpi.create_disk(2048, {}, nil)
        }.to raise_error(/Datastores matching criteria are in maintenance mode. No valid placement found/)
      end
    end
  end
  context'when half of the datastores (matching pattern) present in cluster are in maintenance mode' do
    before do
      half_pattern_datastore_enter_maintenance_mode(cpi, @cluster_name, @datastore_pattern)
    end
    after do
      all_pattern_datastore_exit_maintenance_mode
    end
    it 'should place disk into datastores that are not in maintenance mode' do
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
end
