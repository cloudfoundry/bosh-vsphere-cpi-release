require 'integration/spec_helper'

context 'when datastores are configured in vm_types' do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)

    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE', @second_cluster_name)
  end

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

  let (:vm_type_with_datastores) do
    vm_type.merge({
      'datastores' => [@second_cluster_datastore]
    })
  end

  let(:second_cluster_cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @second_cluster_datastore,
        persistent_datastore_pattern: @second_cluster_datastore,
        clusters: [@second_cluster_name]
      }]
    )
    VSphereCloud::Cloud.new(options)
  end

  it 'creates a VM in one of the specified datastores' do
    begin
      vm_id = second_cluster_cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type_with_datastores,
        network_spec,
        [],
        {}
      )

      expect(vm_id).to_not be_nil
      vm = second_cluster_cpi.vm_provider.find(vm_id)
      ephemeral_disk = vm.ephemeral_disk
      expect(ephemeral_disk).to_not be_nil

      ephemeral_ds = ephemeral_disk.backing.datastore.name
      expect(ephemeral_ds).to eq(@second_cluster_datastore)
    ensure
      delete_vm(second_cluster_cpi, vm_id)
    end
  end

  context 'when a valid cluster is configured in vm_types' do
    let(:second_cluster_cpi) do
      # expect global datastore pattern to be overridden
      options = cpi_options(
        datacenters: [{
          datastore_pattern: @datastore_pattern,
          persistent_datastore_pattern: @second_cluster_datastore,
          clusters: [@second_cluster_name]
        }],
      )
      VSphereCloud::Cloud.new(options)
    end

    let (:vm_type_with_datastores) do
      vm_type.merge({
        'datastores' => [@second_cluster_datastore],
        'datacenters' => [{
          'name' => @datacenter_name,
          'clusters' => [{
            @second_cluster_name => {}
          }]
        }]
      })
    end

    it 'creates a VM in one of the specified datastores' do
      begin
        vm_id = second_cluster_cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type_with_datastores,
          network_spec,
          [],
          {}
        )

        expect(vm_id).to_not be_nil
        vm = second_cluster_cpi.vm_provider.find(vm_id)

        expect(vm.cluster).to eq(@second_cluster_name)

        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(ephemeral_ds).to eq(@second_cluster_datastore)
      ensure
        delete_vm(second_cluster_cpi, vm_id)
      end
    end
  end

  context 'when an invalid cluster is configured in vm_types' do
    let(:two_cluster_cpi) do
      options = cpi_options(
        datacenters: [{
          clusters: [@cluster_name, @second_cluster_name]
        }]
      )
      VSphereCloud::Cloud.new(options)
    end

    let (:vm_type_with_datastores) do
      vm_type.merge({
        'datastores' => [@second_cluster_datastore],
        'datacenters' => [{
          'name' => @datacenter_name,
          'clusters' => [{
            @cluster_name => {}
          }]
        }]
      })
    end

    it 'raises an error' do
      begin
        vm_id = nil
        expect {
          vm_id = two_cluster_cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type_with_datastores,
            network_spec,
            [],
            {}
          )
        }.to raise_error Bosh::Clouds::CloudError, /No valid placement found for disks/
      ensure
        delete_vm(two_cluster_cpi, vm_id)
      end
    end
  end
end
