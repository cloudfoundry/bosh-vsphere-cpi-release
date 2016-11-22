require 'integration/spec_helper'

context 'given cpis that are configured to use same cluster but different datastores' do
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

  let(:first_datastore_cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @datastore_pattern,
        persistent_datastore_pattern: @datastore_pattern,
      }],
    )
    VSphereCloud::Cloud.new(options)
  end

  let(:second_datastore_cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @second_datastore,
        persistent_datastore_pattern: @second_datastore,
      }],
    )
    VSphereCloud::Cloud.new(options)
  end

  before do
    @vm_id = first_datastore_cpi.create_vm(
      'agent-007',
      @stemcell_id,
      vm_type,
      network_spec,
      [],
      {}
    )

    expect(@vm_id).to_not be_nil
    expect(first_datastore_cpi.has_vm?(@vm_id)).to be(true)

    @disk_id = first_datastore_cpi.create_disk(2048, {}, @vm_id)
    expect(@disk_id).to_not be_nil
    expect(first_datastore_cpi.has_disk?(@disk_id)).to be(true)
    disk = first_datastore_cpi.datacenter.find_disk(@disk_id)
    expect(disk.datastore.name).to match(@datastore_pattern)
  end

  after do
    delete_vm(first_datastore_cpi, @vm_id)
    delete_disk(first_datastore_cpi, @disk_id)
  end

  it 'can exercise lifecycle with the cpi configured with a non-overlapping datastore pattern' do
    begin
      expect(second_datastore_cpi.has_disk?(@disk_id)).to be(true)

      first_datastore_cpi.attach_disk(@vm_id, @disk_id)

      second_datastore_cpi.detach_disk(@vm_id, @disk_id)

      expect(second_datastore_cpi.has_disk?(@disk_id)).to be(true)
    ensure
      second_datastore_cpi.delete_vm(@vm_id)
      second_datastore_cpi.delete_disk(@disk_id)
    end
  end

  it '#attach_disk can move the disk to the new datastore pattern' do
    second_datastore_cpi.attach_disk(@vm_id, @disk_id)

    disk = second_datastore_cpi.datacenter.find_disk(@disk_id)
    expect(disk.cid).to eq(@disk_id)
    expect(disk.datastore.name).to match(@second_datastore)

    second_datastore_cpi.detach_disk(@vm_id, @disk_id)
  end
end
