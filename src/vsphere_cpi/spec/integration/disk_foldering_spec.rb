require 'integration/spec_helper'
require 'rspec/expectations'

# Custom matcher to search for disk's existence inside search folder passed
#  * Search uses Datacenter's find_disk method with some patching
#  * Responds to
#       - expect(disk_id).to be_inside_folder(cpi: @cpi, search_folder: "XXX/YYY/ZZZ")
#
# @return Boolean if it finds a matching disk inside search folder, returns true else false
RSpec::Matchers.define :be_inside_folder do |**kwargs|
  match do |disk_cid|
    disk = nil
    cpi = kwargs[:cpi]
    search_folder = kwargs[:search_folder]
    begin
      # Monkey Patch Datacenter's default disk path to search_path passed.
      old_disk_path = cpi.datacenter.instance_variable_get(:@disk_path)
      cpi.datacenter.instance_variable_set(:@disk_path, search_folder)
      disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(disk_cid))
    rescue Bosh::Clouds::DiskNotFound
    ensure
      # Un Monkey Patch disk path
      cpi.datacenter.instance_variable_set(:@disk_path, old_disk_path)
    end
    # The second part of && below is to make sure that disk found above is
    # present in the search folder passed to matcher.
    #
    # If find_vm_by_disk_cid method is called in find_disk method.
    # It might find the disk in location other than search_folder.
    # But our matcher is intended to return true only if disk is directly
    # present in search_folder
    !disk.nil? && disk.folder == search_folder
  end
end

describe 'Selecting & creating datastore folder for persistent disks' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    @shared_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SHARED_DATASTORE', @cluster_name)
    @disk_restore_path = fetch_property('BOSH_VSPHERE_CPI_DISK_PATH')
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
        datacenters: [{persistent_datastore_pattern: @shared_datastore}],
        )
  end


  it 'creates a persistent disk in default datacenter disk folder (Global Properties)' do
    cpi = VSphereCloud::Cloud.new(options)
    begin
      disk_id = cpi.create_disk(128, {})
      expect(cpi.has_disk?(disk_id)).to be(true)
      expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder")
    ensure
      delete_disk(cpi, disk_id)
    end
  end

  context 'when attaching a disk to VM on the different datastore' do
    it 'moves the disk to vm-cid named folder parallel to the master disk folder and moves back to master disk folder when disk is detached' do
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

        disk_id = cpi.create_disk(128, {})
        expect(cpi.has_disk?(disk_id)).to be(true)
        expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder")

        cpi.attach_disk(vm_id, disk_id)
        expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "#{vm_id}")

        # Detach the disk.
        cpi.detach_disk(vm_id, disk_id)
        # it should be back in the master disk folder and should not be in a vm folder
        expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder")
        expect(disk_id).to_not be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder/#{vm_id}")

        # Attach the disk again
        cpi.attach_disk(vm_id, disk_id)
        # should be back in vm folder
        expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "#{vm_id}")

        # Delete the VM
        delete_vm(cpi, vm_id)
        # it should be back in the master disk folder and should not be in the vm folder
        expect(disk_id).to be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder/")
        expect(disk_id).to_not be_inside_folder(cpi: cpi, search_folder: "vcpi-disk-folder/#{vm_id}")
      ensure
        delete_vm(cpi, vm_id)
        delete_disk(cpi, disk_id)
      end
    end
  end
end
