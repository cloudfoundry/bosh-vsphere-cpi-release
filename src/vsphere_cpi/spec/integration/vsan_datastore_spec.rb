require 'integration/spec_helper'

context 'given cpis that are configured to use VSAN datastores', vsan_datastore: true do

  before(:all) do
    @datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @vsan_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_VSAN_DATASTORE_PATTERN')

    verify_vsan_datastore(
      cpi_options,
      @vsan_datastore_pattern,
      'BOSH_VSPHERE_CPI_VSAN_DATASTORE_PATTERN',
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
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:vsan_cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @vsan_datastore_pattern,
        persistent_datastore_pattern: @vsan_datastore_pattern,
      }],
    )
    VSphereCloud::Cloud.new(options)
  end

  it 'should exercise the vm lifecycle with a vsan stemcell' do
    begin
      vsan_stemcell_id = upload_stemcell(vsan_cpi)
      vm_lifecycle(vsan_cpi, [], resource_pool, network_spec, vsan_stemcell_id)
    ensure
      delete_stemcell(vsan_cpi, vsan_stemcell_id)
    end
  end

  context 'when vm and disk already exist in a non-vsan datastore' do
    let(:non_vsan_cpi) do
      options = cpi_options(
        datastore_pattern: @datastore_pattern,
        persistent_datastore_pattern: @datastore_pattern,
      )
      VSphereCloud::Cloud.new(options)
    end

    before do
      @vm_id = non_vsan_cpi.create_vm(
        'agent-007',
        @stemcell_id,
        resource_pool,
        network_spec,
        [],
        {}
      )

      expect(@vm_id).to_not be_nil
      expect(non_vsan_cpi.has_vm?(@vm_id)).to be(true)

      @disk_id = non_vsan_cpi.create_disk(2048, {}, @vm_id)
      expect(@disk_id).to_not be_nil
      expect(non_vsan_cpi.has_disk?(@disk_id)).to be(true)
      disk = non_vsan_cpi.datacenter.find_disk(@disk_id)
      expect(disk.datastore.name).to match(@datastore_pattern)
    end

    after do
      delete_vm(vsan_cpi, @vm_id)
      delete_disk(vsan_cpi, @disk_id)
    end

    it '#attach_disk can move the disk to and from the vsan datastore', focus: true do
      vsan_cpi.attach_disk(@vm_id, @disk_id)

      disk = vsan_cpi.datacenter.find_disk(@disk_id)
      expect(disk.cid).to eq(@disk_id)
      expect(disk.datastore.name).to match(@vsan_datastore_pattern)

      vsan_cpi.detach_disk(@vm_id, @disk_id)

      non_vsan_cpi.attach_disk(@vm_id, @disk_id)

      disk = non_vsan_cpi.datacenter.find_disk(@disk_id)
      expect(disk.cid).to eq(@disk_id)
      expect(disk.datastore.name).to match(@datastore_pattern)

      non_vsan_cpi.detach_disk(@vm_id, @disk_id)
    end
  end
end
