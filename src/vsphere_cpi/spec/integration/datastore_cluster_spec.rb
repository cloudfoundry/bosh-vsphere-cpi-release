require 'integration/spec_helper'

context 'when regex matching datastores in a datastore cluster (datastore-*)' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_IN_DATASTORE_CLUSTER', @cluster_name) # datastore-name-*
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
        network_spec,
        [],
        {}
      )
      expect(@vm_id).to_not be_nil
      expect(cpi.has_vm?(@vm_id)).to be(true)

      @disk_id = cpi.create_disk(2048, {}, nil)
      expect(@disk_id).to_not be_nil
      expect(cpi.has_disk?(@disk_id)).to be(true)
      disk = cpi.datacenter.find_disk(@disk_id)
      expect(disk.datastore.name).to match(@datastore_pattern)
    ensure
      delete_vm(cpi, @vm_id)
      delete_disk(cpi, @disk_id)
    end
  end
end