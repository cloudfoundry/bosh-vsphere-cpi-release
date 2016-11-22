require 'integration/spec_helper'

describe 'inactive datastore handling' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @inactive_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_INACTIVE_DATASTORE_PATTERN')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
  end

  let(:inactive_cpi) { VSphereCloud::Cloud.new(cpi_options) }
  let(:inactive_datastores) { datastore_names_matching_pattern(inactive_cpi, @cluster_name, @inactive_datastore_pattern) }
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

  context 'when the user specifies an inactive datastore' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datastores' => inactive_datastores,
      }
    end
    let(:disk_pool) do
      {
        'datastores' => inactive_datastores,
      }
    end

    it 'returns an error creating a VM' do
      expect {
        inactive_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
      }.to raise_error(/No valid placement found/)
    end

    it 'returns an error creating a disk' do
      expect {
        inactive_cpi.create_disk(128, disk_pool)
      }.to raise_error(/No valid placement found/)
    end
  end

  context 'when the user specifies a mix of active and inactive datastores' do
    let(:active_datastores) { datastore_names_matching_pattern(inactive_cpi, @cluster_name, @datastore_pattern) }
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datastores' => inactive_datastores + active_datastores,
      }
    end
    let(:disk_pool) do
      {
        'datastores' => inactive_datastores + active_datastores,
      }
    end

    it 'places the VM in the active datastore' do
      begin
        vm_id = inactive_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
        vm = inactive_cpi.vm_provider.find(vm_id)
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(active_datastores).to include(ephemeral_ds)
      ensure
        delete_vm(inactive_cpi, vm_id)
      end
    end

    it 'places the disk in the active datastore' do
      begin
        disk_id = inactive_cpi.create_disk(128, disk_pool)
        expect(disk_id).to_not be_nil

        clean_disk_cid, _ = VSphereCloud::DiskMetadata.decode(disk_id)
        disk = inactive_cpi.datacenter.find_disk(clean_disk_cid)
        expect(active_datastores).to include(disk.datastore.name)
      ensure
        delete_disk(inactive_cpi, disk_id)
      end
    end
  end
end
