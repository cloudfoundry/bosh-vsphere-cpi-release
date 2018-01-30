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
    do_setup
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @datastore_cluster = fetch_and_verify_datastore_cluster('BOSH_VSPHERE_CPI_DATASTORE_CLUSTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_RESOURCE_POOL', @cluster_name)
    @datastore_in_dc = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SHARED_DATASTORE', @cluster_name) #datastore which is part of datastore cluster
    @another_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
  end
  let(:cpi) do
    VSphereCloud::Cloud.new(cpi_options)
  end
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'datastores' => [@another_datastore, 'cluster' => [@datastore_cluster => {}]]
    }
  end
  context 'and drs is enabled' do
    let(:datastore_cluster_1) { VSphereCloud::Resources::StoragePod.find(@datastore_cluster, @datacenter_name, @client) }
    it 'should place the ephemeral disk in datastore part of datastore cluster' do
      begin
        expect_any_instance_of(VSphereCloud::VmCreator).to receive(:choose_storage).with(anything).and_return(datastore_cluster_1)
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
      ensure
        delete_vm(cpi, vm_id)
      end
    end
    it 'should place vm in the given resource pool' do
      vm_type.merge({
        datacenters: [{
          clusters: [{ @cluster_name => { 'resource_pool' => @resource_pool_name } }],
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
  end
  context 'and drs is not enabled' do
    it 'should place disk in datastore' do
      #turn_drs_off_for_datastore_cluster(cpi, @datastore_cluster)
      #datastore_cluster.pod_storage_drs_entry.storage_drs_config.pod_config.enabled or stub this method to return false
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
        expect(ephemeral_ds).to eq(@another_datastore)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
  end

  def do_setup
    host = ENV.fetch('BOSH_VSPHERE_CPI_HOST')
    user = ENV.fetch('BOSH_VSPHERE_CPI_USER')
    password = ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD')
    logger = Logger.new(StringIO.new(""))

    @client = VSphereCloud::VCenterClient.new(
      vcenter_api_uri: URI.parse("https://#{host}/sdk/vimService"),
      http_client: VSphereCloud::CpiHttpClient.new(logger),
      logger: logger,
    )
    @client.login(user, password, 'en')
  end
end