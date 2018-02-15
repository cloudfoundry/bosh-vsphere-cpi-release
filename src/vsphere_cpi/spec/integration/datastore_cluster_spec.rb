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

context 'when datastore cluster is also defined in vm_type' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @datastore_cluster = fetch_and_verify_datastore_cluster('BOSH_VSPHERE_CPI_DATASTORE_CLUSTER')
    @datastore_cluster_drs_disabled = fetch_and_verify_datastore_cluster('BOSH_VSPHERE_CPI_DATASTORE_CLUSTER_DRS_DISABLED')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL', @cluster_name)
    @datastore_in_dc = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_DATASTORE_CLUSTER', @cluster_name) #datastore which is part of datastore cluster
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN', @cluster_name) # local-ds-*
    @datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name) # with more free space then datastore cluster
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
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'datastores' => datastores
    }
  end
  let(:cloud_properties) { {'datastores' => datastores} }

  context 'and drs is enabled' do
    let(:datastores) { ['clusters' => [@datastore_cluster => {}]] }

    it 'should place the ephemeral disk & persistent disk in datastore belonging to datastore cluster' do
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
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_datastore = ephemeral_disk.backing.datastore
        expect(ephemeral_datastore.name).to eq(@datastore_in_dc)

        director_disk_id = cpi.create_disk(128, cloud_properties)
        disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(director_disk_id))
        expect(disk.datastore.name).to match(@datastore_in_dc)
      ensure
        delete_vm(cpi, vm_id)
        delete_disk(cpi, director_disk_id)
      end
    end
    it 'should place vm in the given resource pool' do
      vm_type.merge!({
        'datacenters' => [{
          'clusters' => [{ @cluster_name => { 'resource_pool' => @resource_pool_name } }],
        }]
      })
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
        expect(vm.resource_pool).to eq(@resource_pool_name)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
    it 'should place vm, ephemeral disk & persistent disk in given datastore if that has more free space than datastore cluster' do
      vm_type.merge!({
        'datastores' => [ @datastore, ['clusters' => [@datastore_cluster => {}]] ]
      })
      cloud_properties.merge!({
        'datastores' => [ @datastore, ['clusters' => [@datastore_cluster => {}]] ]
      })

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
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_datastore = ephemeral_disk.backing.datastore
        expect(ephemeral_datastore.name).to eq(@datastore)

        director_disk_id = cpi.create_disk(128, cloud_properties)
        disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(director_disk_id))
        expect(disk.datastore.name).to match(@datastore)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
  end
  context 'and drs is not enabled' do
    let(:datastores) { ['clusters' => [@datastore_cluster_drs_disabled => {}]] }
    it 'should place ephemeral disk & persistent disk in datastore defined in global config' do
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
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(ephemeral_ds).to match(@datastore_pattern)

        director_disk_id = cpi.create_disk(128, cloud_properties)
        disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(director_disk_id))
        expect(disk.datastore.name).to match(@datastore_pattern)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
  end
end