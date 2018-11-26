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

  let(:vm_type_with_pin_vm) do
    vm_type.merge({'pin_vm' => true})
  end

  it 'creates a VM and PINS it by disabling DRS on it' do
    begin
      vm_id = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type_with_pin_vm,
        network_spec,
        [],
        {}
      )

      expect(vm_id).to_not be_nil
      vm = @cpi.vm_provider.find(vm_id)
      vm_mob = vm.mob
      cluster = @cpi.datacenter.find_cluster(@cluster_name)
      cluster_vm_drs_config = cluster.mob.configuration_ex.drs_vm_config
      vms_in_cluster_drs_config = cluster_vm_drs_config.map(&:key).map(&:name)
      expect(vms_in_cluster_drs_config).to include(vm_mob.name)
    ensure
      delete_vm(@cpi, vm_id)
    end
  end
end
