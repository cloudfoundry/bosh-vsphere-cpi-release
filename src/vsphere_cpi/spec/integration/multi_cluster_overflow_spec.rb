require 'integration/spec_helper'

context 'given 2 clusters with a datastore and a resource pool' do
  before (:all) do
    @first_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN')
    @first_rp = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_RESOURCE_POOL', @first_cluster_name)
    @second_rp = fetch_and_verify_resource_pool('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL', @second_cluster_name)
  end

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'memory_reservation_locked_to_max' => true,
    }
  end
  let(:cpi) do
    options = cpi_options(
      datacenters: [{
        datastore_pattern: @datastore_pattern,
        clusters: [
          { @first_cluster_name => { resource_pool: @first_rp }},
          { @second_cluster_name => { resource_pool: @second_rp }},
        ]
      }]
    )
    VSphereCloud::Cloud.new(options)
  end

  after do
    cpi.cleanup
  end

  context 'when no cluster has enough reservable memory' do
    before do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 100, false)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 100, false)
    end
    after do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 1, true)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 1, true)
    end
    it 'should raise error for insufficient available Memory' do
      begin
        expect {
          cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            get_network_spec,
            [],
            {}
          )
        }.to raise_error(/The available Memory resources in the parent resource pool are insufficient for the operation./)
      end
    end
  end

  context 'when the first cluster has enough reservable memory' do
    before do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 1024, false)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 100, false)
    end
    after do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 1, true)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 1, true)
    end
    it 'should create a VM on the first cluster' do
      begin
        @vm_id, _ = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [],
          {}
        )

        expect(@vm_id).to_not be_nil
        expect(cpi.has_vm?(@vm_id)).to be(true)

        vm = @cpi.vm_provider.find(@vm_id)
        expect(vm.mob.runtime.host.parent.name).to eq(@first_cluster_name)
      ensure
        delete_vm(cpi, @vm_id)
      end
    end
  end

  context 'when the second cluster has enough reservable memory' do
    before do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 100, false)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 1024, false)
    end
    after do
      update_resource_pool_memory_reservation(cpi, @first_cluster_name, @first_rp, 1, true)
      update_resource_pool_memory_reservation(cpi, @second_cluster_name, @second_rp, 1, true)
    end
    it 'should create a VM on the second cluster' do
      begin
        @vm_id, _ = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          get_network_spec,
          [],
          {}
        )

        expect(@vm_id).to_not be_nil
        expect(cpi.has_vm?(@vm_id)).to be(true)

        vm = @cpi.vm_provider.find(@vm_id)
        expect(vm.mob.runtime.host.parent.name).to eq(@second_cluster_name)
      ensure
        delete_vm(cpi, @vm_id)
      end
    end
  end
end
