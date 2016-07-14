require 'integration/spec_helper'

context 'given cpis that are configured to use same cluster but different datastores' do

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

  let(:first_datastore_cpi) do
    options = cpi_options(persistent_datastore_pattern: @datastore_pattern)
    VSphereCloud::Cloud.new(options)
  end

  before do
    @vm_id = first_datastore_cpi.create_vm(
      'agent-007',
      @stemcell_id,
      resource_pool,
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

  after {
    delete_vm(first_datastore_cpi, @vm_id)
    delete_disk(first_datastore_cpi, @disk_id)
  }

  it 'can exercise lifecycle with the cpi configured with a new datastore pattern' do
    # second cpi can see disk in datastore outside of its datastore pattern
    expect(second_datastore_cpi.has_disk?(@disk_id)).to be(true)

    first_datastore_cpi.attach_disk(@vm_id, @disk_id)

    second_datastore_cpi.detach_disk(@vm_id, @disk_id)

    second_datastore_cpi.delete_vm(@vm_id)
    expect {
      first_datastore_cpi.vm_provider.find(@vm_id)
    }.to raise_error(Bosh::Clouds::VMNotFound)
    @vm_id = nil

    second_datastore_cpi.delete_disk(@disk_id)
    expect {
      first_datastore_cpi.datacenter.find_disk(@disk_id)
    }.to raise_error(Bosh::Clouds::DiskNotFound)
    @disk_id = nil
  end

  it '#attach_disk can move the disk to the new datastore pattern' do
    second_datastore_cpi.attach_disk(@vm_id, @disk_id)

    disk = second_datastore_cpi.datacenter.find_disk(@disk_id)
    expect(disk.cid).to eq(@disk_id)
    expect(disk.datastore.name).to match(@second_datastore_within_cluster)

    second_datastore_cpi.detach_disk(@vm_id, @disk_id)
  end
end
