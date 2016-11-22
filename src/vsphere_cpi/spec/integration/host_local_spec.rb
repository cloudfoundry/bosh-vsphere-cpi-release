require 'integration/spec_helper'

describe 'host-local storage patterns', :host_local => true do
  include LifecycleProperties

  let(:local_disk_cpi) { VSphereCloud::Cloud.new(local_disk_options) }

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
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

  before(:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    verify_non_overlapping_datastores(
      cpi_options,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @second_datastore,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )

    cpi = VSphereCloud::Cloud.new(cpi_options)

    @single_local_ds_pattern = fetch_property('BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN')
    @multi_local_ds_pattern = fetch_property('BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN')
    @second_cluster_local_datastore = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE')

    verify_local_disk_infrastructure(
      cpi,
      'BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN',
      @single_local_ds_pattern,
    )

    verify_local_disk_infrastructure(
      cpi,
      'BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN',
      @multi_local_ds_pattern,
    )

    verify_local_disk_infrastructure(
      cpi,
      'BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE',
      @second_cluster_local_datastore,
    )

    verify_datastore_within_cluster(
      cpi,
      'BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN',
      @single_local_ds_pattern,
      @cluster_name
    )

    verify_datastore_within_cluster(
      cpi,
      'BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN',
      @multi_local_ds_pattern,
      @cluster_name
    )

    verify_datastore_within_cluster(
      cpi,
      'BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE',
      @second_cluster_local_datastore,
      @second_cluster_name
    )
  end

  context 'when both ephemeral and persistent storage patterns reference a single host-local datastore' do
    let(:local_disk_options) do
      cpi_options({
        datacenters: [{
          datastore_pattern: @single_local_ds_pattern,
          persistent_datastore_pattern: @single_local_ds_pattern,
          clusters: [@cluster_name]
        }]
      })
    end

    it 'places both ephemeral and persistent disks on local DS' do
      begin
        vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
        vm = local_disk_cpi.vm_provider.find(vm_id)
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(ephemeral_ds).to match(@single_local_ds_pattern)

        disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
        expect(disk_id).to_not be_nil
        disk = local_disk_cpi.datacenter.find_disk(disk_id)
        expect(disk.datastore.name).to eq(ephemeral_ds)

        local_disk_cpi.attach_disk(vm_id, disk_id)
        expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
      ensure
        detach_disk(local_disk_cpi, vm_id, disk_id)
        delete_vm(local_disk_cpi, vm_id)
        delete_disk(local_disk_cpi, disk_id)
      end
    end
  end

  context 'when both ephemeral and persistent storage patterns reference a multiple host-local datastores' do
    let(:local_disk_options) do
      cpi_options({
        datacenters: [{
          datastore_pattern: @multi_local_ds_pattern,
          persistent_datastore_pattern: @multi_local_ds_pattern,
          clusters: [@cluster_name]
        }]
      })
    end

    context 'when a VM hint is provided' do
      it 'places both ephemeral and persistent disks on local DS' do
        begin
          vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
          vm = local_disk_cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil

          ephemeral_ds = ephemeral_disk.backing.datastore.name
          expect(ephemeral_ds).to match(@multi_local_ds_pattern)

          disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil
          disk = local_disk_cpi.datacenter.find_disk(disk_id)
          expect(disk.datastore.name).to eq(ephemeral_ds)

          local_disk_cpi.attach_disk(vm_id, disk_id)
          expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
        ensure
          detach_disk(local_disk_cpi, vm_id, disk_id)
          delete_vm(local_disk_cpi, vm_id)
          delete_disk(local_disk_cpi, disk_id)
        end
      end
    end

    context 'when a VM hint is not provided and the disk is placed elsewhere' do
      it 'moves the persistent disk onto the same datastore as the VM' do
        begin
          vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
          vm = local_disk_cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil

          ephemeral_ds = ephemeral_disk.backing.datastore.name
          expect(ephemeral_ds).to match(@multi_local_ds_pattern)

          disk_id = local_disk_cpi.create_disk(2048, {})
          expect(disk_id).to_not be_nil
          disk = local_disk_cpi.datacenter.find_disk(disk_id)

          host_local_datastores = matching_datastores(local_disk_cpi.datacenter, @multi_local_ds_pattern)
          other_datastore = host_local_datastores.values.find { |ds| ds.name != ephemeral_ds }
          disk = local_disk_cpi.datacenter.move_disk_to_datastore(disk, other_datastore)
          expect(disk.datastore.name).to_not eq(ephemeral_ds)

          local_disk_cpi.attach_disk(vm_id, disk_id)
          expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
          disk = local_disk_cpi.datacenter.find_disk(disk_id)
          expect(disk.datastore.name).to eq(ephemeral_ds)
        ensure
          detach_disk(local_disk_cpi, vm_id, disk_id)
          delete_vm(local_disk_cpi, vm_id)
          delete_disk(local_disk_cpi, disk_id)
        end
      end

      context 'when a persistent disk exists in a host-local datastore in a different cluster' do
        let(:local_disk_options) do
          cpi_options({
            datacenters: [{
              datastore_pattern: @multi_local_ds_pattern,
              persistent_datastore_pattern: @multi_local_ds_pattern,
              clusters: [
                 @cluster_name,
                 @second_cluster_name,
              ],
            }]
          })
        end
        let(:second_cluster_cpi) do
          VSphereCloud::Cloud.new(cpi_options({
            datacenters: [{
              datastore_pattern: @second_cluster_local_datastore,
              persistent_datastore_pattern: @second_cluster_local_datastore,
              clusters: [@second_cluster_name],
            }]
          }))
        end

        before do
          @disk_id = second_cluster_cpi.create_disk(2048, {}, nil)
          expect(@disk_id).to_not be_nil
        end

        after do
          delete_disk(local_disk_cpi, @disk_id)
        end

        it 'migrates the persistent disk to a host-local datastore in the same cluster as the VM' do
          begin
            vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
            vm = local_disk_cpi.vm_provider.find(vm_id)
            ephemeral_disk = vm.ephemeral_disk
            expect(ephemeral_disk).to_not be_nil

            ephemeral_ds = ephemeral_disk.backing.datastore.name
            expect(ephemeral_ds).to match(@multi_local_ds_pattern)

            local_disk_cpi.attach_disk(vm_id, @disk_id)
            expect(local_disk_cpi.has_disk?(@disk_id)).to be(true)
            disk = local_disk_cpi.datacenter.find_disk(@disk_id)
            expect(disk.datastore.name).to eq(ephemeral_ds)
          ensure
            detach_disk(local_disk_cpi, vm_id, @disk_id)
            delete_vm(local_disk_cpi, vm_id)
          end
        end
      end
    end
  end

  context 'when host-local datastores are specified under vm_type and disk_pool' do
    let(:local_disk_options) do
      cpi_options({
        # expect global patterns to be overridden
        datacenters: [{
          datastore_pattern: @datastore_pattern,
          persistent_datastore_pattern: @datastore_pattern,
          clusters: [@cluster_name],
        }],
      })
    end
    let(:ephemeral_datastores) { datastore_names_matching_pattern(@cpi, @cluster_name, @single_local_ds_pattern) }
    let(:persistent_datastores) { datastore_names_matching_pattern(@cpi, @cluster_name, @multi_local_ds_pattern) }
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datastores' => ephemeral_datastores,
      }
    end
    let(:disk_pool) { { 'datastores' => persistent_datastores } }

    it 'places both disks on the overlapping local DS' do
      begin
        vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, vm_type, network_spec)
        vm = local_disk_cpi.vm_provider.find(vm_id)
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(ephemeral_ds).to match(@single_local_ds_pattern)

        disk_id = local_disk_cpi.create_disk(2048, disk_pool, vm_id)
        expect(disk_id).to_not be_nil
        clean_disk_cid, _ = VSphereCloud::DiskMetadata.decode(disk_id)
        disk = local_disk_cpi.datacenter.find_disk(clean_disk_cid)
        expect(disk.datastore.name).to match(@multi_local_ds_pattern)

        local_disk_cpi.attach_disk(vm_id, disk_id)
        expect(disk.datastore.name).to match(ephemeral_ds)
        expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
      ensure
        detach_disk(local_disk_cpi, vm_id, disk_id)
        delete_vm(local_disk_cpi, vm_id)
        delete_disk(local_disk_cpi, disk_id)
      end
    end
  end
end
