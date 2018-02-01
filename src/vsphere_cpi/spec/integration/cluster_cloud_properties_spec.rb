require 'integration/spec_helper'

describe 'cloud_properties related to clusters' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')

    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')

    @cluster_more_datastore_free_space = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER_MORE_DATASTORE_FREE_SPACE')
    @cluster_less_datastore_free_space = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER_LESS_DATASTORE_FREE_SPACE')
    @shared_datastore = fetch_property('BOSH_VSPHERE_CPI_SHARED_DATASTORE')
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @vlan },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  context 'when vm_type specifies a cluster not defined in global config' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_name => {}
              }
            ]
          }
        ]
      }
    end
    let(:options) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @second_cluster_name => {}
              },
            ]
          }
        ]
      )
    end

    it 'creates vm in cluster defined in `vm_type`' do
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

        expect(vm.cluster).to eq(@cluster_name)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
  end

  context 'when vm_type specifies multiple clusters' do
    before do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_more_datastore_free_space => {}
              },
              {
                @cluster_less_datastore_free_space => {}
              }
            ]
          }
        ]
      )
      cpi = VSphereCloud::Cloud.new(options)
      # @cluster_more_memory should have more memory than @cluster_less_memory and
      # both clusters need to have the specified @shared_datastore
      verify_cluster_free_space(cpi, @cluster_more_datastore_free_space, @cluster_less_datastore_free_space)
    end

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datastores' => [@shared_datastore],
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_less_datastore_free_space => {}
              },
              {
                @cluster_more_datastore_free_space => {}
              }
            ]
          }
        ]
      }
    end
    let(:options) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_more_datastore_free_space => {}
              },
              {
                @cluster_less_datastore_free_space => {}
              }
            ]
          }
        ]
      )
    end

    it 'creates vm in the best possible cluster defined in `vm_type`' do
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

        expect(vm.cluster).to eq(@cluster_more_datastore_free_space)
      ensure
        delete_vm(cpi, vm_id)
      end
    end
  end
  context 'when disk_pool specifies a datastore accessible from cluster defined in vm_type' do
    before (:all) do
      @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN', @cluster_name)
      #cluster which has a disjoint datastore (not shared with any other cluster)
      @disjoint_cluster = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
      @disjoint_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE', @disjoint_cluster)
    end
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @disjoint_cluster => {}
              }
            ]
          }
        ]
      }
    end
    let(:cpi) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'datastore_pattern' => @datastore_pattern,
            'persistent_datastore_pattern' => @datastore_pattern,
            'clusters' => [
              {
                @cluster_name => {}
              },
            ]
          }
        ]
      )
      VSphereCloud::Cloud.new(options)
    end

    let(:disjoint_cluster_cpi) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'datastore_pattern' => @datastore_pattern,
            'persistent_datastore_pattern' => @datastore_pattern,
            'clusters' => [
              {
                @disjoint_cluster => {}
              },
            ]
          }
        ]
      )
      VSphereCloud::Cloud.new(options)
    end

    let(:disk_pool) { { 'datastores' => [@disjoint_datastore] } }

    it 'should place disk into datastore that belongs to the cluster defined in cloud config' do
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
        expect(vm.cluster).to eq(@disjoint_cluster)
        expect(cpi.has_vm?(vm_id)).to be(true)

        disk_id = cpi.create_disk(2048, disk_pool, vm_id)
        expect(disk_id).to_not be_nil
        expect(disjoint_cluster_cpi.has_disk?(disk_id)).to be(true)
        disk = disjoint_cluster_cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(disk_id))
        expect(disk.datastore.name).to eq(@disjoint_datastore)
      ensure
        delete_vm(cpi, vm_id)
        delete_disk(disjoint_cluster_cpi, disk_id)
      end
    end
  end
end

