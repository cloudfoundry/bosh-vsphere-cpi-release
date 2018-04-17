require 'integration/spec_helper'

describe 'Give a cluster with DRS On ' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    # We actually use a healthy cluster but manipulate it before the test and restore after we are done
    @cluster_name_maintenance = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER__MAINTENANCE_MODE_HOST')
    @datastore_shared_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SHARED_DATASTORE_MAINTENANCE_MODE_HOST', @cluster_name_maintenance)
    @datastore_pattern_maintenance_cluster = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN_MAINTENANCE_MODE_HOST', @cluster_name_maintenance)
  end

  context 'when regex matches one or more of datastores that are accessible by one or few non-maintenace mode hosts in a cluster (datastore-*) ' do
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
                  'datastore_pattern' => @datastore_pattern_maintenance_cluster,
                  'persistent_datastore_pattern' => @datastore_pattern_maintenance_cluster,
                  'clusters' => [
                      {
                          @cluster_name_maintenance => {}
                      },
                  ]
              }
          ]
      )
      VSphereCloud::Cloud.new(options)
    end

    # We turn the maintenance mode ON for half of the hosts (rounding off to the floor) in a cluster
    before do
      turn_maintenance_on_for_half_hosts(cpi, @cluster_name_maintenance)
    end
    it 'cpi should be able to replicate stemcell (create vm and create ephemeral disk) ' do
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
        # These checks are sufficient as any try to create a vm on maintenance mode host or non-accessible host will error out.
      ensure
        delete_vm(cpi, @vm_id)
      end
    end
    it 'cpi should be able to create persistent disk ' do
      begin
        @disk_id = cpi.create_disk(2048, {}, nil)
        expect(@disk_id).to_not be_nil
        expect(cpi.has_disk?(@disk_id)).to be(true)
        disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(@disk_id))
        expect(disk.datastore.name).to match(@datastore_pattern_maintenance_cluster)
      ensure
        delete_disk(cpi, @disk_id)
    end

    end
    after do
      turn_maintenance_off_for_all_hosts(cpi, @cluster_name_maintenance)
    end
  end

  context 'when regex matches one or more of datastores that are accessible by all maintenace mode hosts in a cluster (datastore-*) ' do
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
                  'datastore_pattern' => @datastore_pattern_maintenance_cluster,
                  'persistent_datastore_pattern' => @datastore_pattern_maintenance_cluster,
                  'clusters' => [
                      {
                          @cluster_name_maintenance => {}
                      },
                  ]
              }
          ]
      )
      VSphereCloud::Cloud.new(options)
    end

    # We turn the maintenance mode ON for all of the hosts (rounding off to the floor) in a cluster
    before do
      turn_maintenance_on_for_all_hosts(cpi, @cluster_name_maintenance)
    end
    xit 'cpi should fail to replicate stemcell (create vm and create ephemeral disk) on a datastore ' do
      begin
        expect do
          @vm_id = cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            get_network_spec,
            [],
            {}
          )
         end.to raise_error(/No valid placement found/)
      end
    end
    xit 'cpi should fail to create persistent disk on a datastore ' do
      begin
        expect do
          cpi.create_disk(2048, {}, nil)
        end.to raise_error(/No valid placement found due to no active host/)
      end
    end
    after do
      turn_maintenance_off_for_all_hosts(cpi, @cluster_name_maintenance)
    end
  end

  context 'when regex matches one or more of datastores that are accessible by all maintenace mode hosts in other cluster (datastore-*) ' do
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
                          @cluster_name_maintenance => {}
                      },
                  ]
              }
          ]
      )
      VSphereCloud::Cloud.new(options)
    end

    # We turn the maintenance mode ON for all of the hosts (rounding off to the floor) in a cluster
    before do
      turn_maintenance_on_for_all_hosts(cpi, @cluster_name_maintenance)
    end
    xit 'cpi should fail to replicate stemcell (create vm and create ephemeral disk) on a datastore ' do
      begin
        expect do
          @vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              {}
          )
        end.to raise_error(/No valid placement/)
      end
    end
    xit 'cpi should be able to create persistent disk on a datastore ' do
      begin
        @disk_id = cpi.create_disk(2048, {}, nil)
        expect(@disk_id).to_not be_nil
        expect(cpi.has_disk?(@disk_id)).to be(true)
        disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(@disk_id))
        expect(disk.datastore.name).to match(@datastore_shared_pattern)
      ensure
        delete_disk(cpi, @disk_id)
      end
    end
    after do
      turn_maintenance_off_for_all_hosts(cpi, @cluster_name_maintenance)
    end
  end

end
