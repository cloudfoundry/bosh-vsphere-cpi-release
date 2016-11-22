require 'integration/spec_helper'

describe 'cloud_properties related to disks' do
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

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:options) do
    options = cpi_options(
      datacenters: [{persistent_datastore_pattern: @datastore_pattern}],
    )
  end

  it 'creates an ephemeral disk with the default type' do
    cpi = VSphereCloud::Cloud.new(options)
    begin
      vm_id = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {}
      )
      expect(vm_id).to_not be_nil

      vm = cpi.vm_provider.find(vm_id)
      expect(vm).to_not be_nil

      disk_mob = vm.ephemeral_disk
      backing = disk_mob.backing
      expect(backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT)
      # default is 'preallocated', thin + lazy-zeroed
      expect(backing.thin_provisioned).to be(false)
      expect(backing.eagerly_scrub).to be_falsey
    ensure
      delete_vm(cpi, vm_id)
    end
  end

  it 'creates a persistent disk with the default type' do
    cpi = VSphereCloud::Cloud.new(options)
    begin
      disk_id = cpi.create_disk(128, {})
      expect(cpi.has_disk?(disk_id)).to be(true)

      yield_persistent_disk_mob(cpi, disk_id) do |disk_mob|
        backing = disk_mob.backing
        expect(backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT)
        # default is 'preallocated', thin + lazy-zeroed
        expect(backing.thin_provisioned).to be(false)
        expect(backing.eagerly_scrub).to be_falsey
      end
    ensure
      delete_disk(cpi, disk_id)
    end
  end

  context 'when user provides global_properties.default_disk_type' do
    let(:options) do
      cpi_options(
        default_disk_type: 'thin',
        datacenters: [{persistent_datastore_pattern: @datastore_pattern}],
      )
    end

    it 'creates an ephemeral disk with the specified default type' do
      cpi = VSphereCloud::Cloud.new(options)
      begin
        vm_id = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {}
        )
        expect(vm_id).to_not be_nil

        vm = cpi.vm_provider.find(vm_id)
        expect(vm).to_not be_nil

        disk_mob = vm.ephemeral_disk
        backing = disk_mob.backing
        expect(backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT)
        expect(backing.thin_provisioned).to be(true)
        expect(backing.eagerly_scrub).to be_falsey
      ensure
        delete_vm(cpi, vm_id)
      end
    end

    it 'creates a persistent disk with the specified default type' do
      cpi = VSphereCloud::Cloud.new(options)
      begin
        disk_id = cpi.create_disk(128, {})
        expect(cpi.has_disk?(disk_id)).to be(true)

        yield_persistent_disk_mob(cpi, disk_id) do |disk_mob|
          backing = disk_mob.backing
          expect(backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT)
          expect(backing.thin_provisioned).to be(true)
          expect(backing.eagerly_scrub).to be_falsey
        end
      ensure
        delete_disk(cpi, disk_id)
      end
    end

    context 'and type is not supported' do
      let(:options) do
        cpi_options(
          default_disk_type: 'fake-disk-type',
          datacenters: [{persistent_datastore_pattern: @datastore_pattern}],
        )
      end

      it 'raises an error' do
        expect do
          cpi = VSphereCloud::Cloud.new(options)
          cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
        end.to raise_error(/fake-disk-type/)
      end
    end
  end

  context 'when user provides disk_pool.cloud_properties.type' do
    let(:disk_pool) { {'type' => 'eagerZeroedThick' } }

    it 'creates a persistent disk with the specified type' do
      cpi = VSphereCloud::Cloud.new(options)
      begin
        disk_id = cpi.create_disk(128, disk_pool)
        expect(cpi.has_disk?(disk_id)).to be(true)

        yield_persistent_disk_mob(cpi, disk_id) do |disk_mob|
          backing = disk_mob.backing
          expect(backing.disk_mode).to eq(VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT)
          expect(backing.thin_provisioned).to be(false)
          expect(backing.eagerly_scrub).to be(true)
        end
      ensure
        delete_disk(cpi, disk_id)
      end
    end
  end

  context 'when user provides disk_pool.cloud_properties.datastores' do
    let(:persistent_datastores) { datastore_names_matching_pattern(@cpi, @cluster_name, @second_datastore) }
    let(:cloud_properties) { {'datastores' => persistent_datastores} }

    it 'places the disk in the specified datastore and does not move it when attached' do
      cpi = VSphereCloud::Cloud.new(options)
      begin
        director_disk_id = cpi.create_disk(128, cloud_properties)
        disk_id, _ = VSphereCloud::DiskMetadata.decode(director_disk_id)
        verify_disk_is_in_datastores(cpi, disk_id, persistent_datastores)
        expect(cpi.has_disk?(director_disk_id)).to be(true)

        vm_id = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [director_disk_id],
          {}
        )
        expect(vm_id).to_not be_nil

        cpi.attach_disk(vm_id, director_disk_id)
        verify_disk_is_in_datastores(cpi, disk_id, persistent_datastores)
        expect(cpi.has_disk?(director_disk_id)).to be(true)
      ensure
        detach_disk(cpi, vm_id, director_disk_id)
        delete_vm(cpi, vm_id)
        delete_disk(cpi, director_disk_id)
      end
    end
  end

  def yield_persistent_disk_mob(cpi, disk_id)
    # the vSphere API provides little info about disks until they are attached
    vm_id = cpi.create_vm(
      'agent-007',
      @stemcell_id,
      vm_type,
      network_spec,
      [disk_id],
      {}
    )
    expect(vm_id).to_not be_nil

    cpi.attach_disk(vm_id, disk_id)

    vm = cpi.vm_provider.find(vm_id)
    expect(vm).to_not be_nil

    yield vm.persistent_disks.first
  ensure
    detach_disk(cpi, vm_id, disk_id)
    delete_vm(cpi, vm_id)
  end
end
