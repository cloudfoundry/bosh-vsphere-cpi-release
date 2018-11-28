require 'integration/spec_helper'

context 'when having pin vm enabled' do

  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
  end

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:vm_type_with_disable_drs) do
    vm_type.merge({'disable_drs' => true})
  end

  it 'creates a VM and PINS it by disabling DRS on it' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type_with_disable_drs,
        get_network_spec,
        [],
        {}
      )

      expect(vm_id).to_not be_nil
      vm = @cpi.vm_provider.find(vm_id)
      vm_mob = vm.mob
      cluster = @cpi.datacenter.find_cluster(@cluster_name)
      cluster_vm_drs_config = cluster.mob.configuration_ex.drs_vm_config.first
      expect(cluster_vm_drs_config.key.name).to eq(vm_mob.name)
      expect(cluster_vm_drs_config.enabled).to be false
    ensure
      delete_vm(@cpi, vm_id)
    end
  end
end
