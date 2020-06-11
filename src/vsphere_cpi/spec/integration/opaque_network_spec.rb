require 'integration/spec_helper'

describe 'NSX Tranformers integration', nvds: true, cvds: true do
  before (:all) do
    @opaque_vlan = fetch_property('BOSH_VSPHERE_OPAQUE_VLAN')
  end

  context 'when an opaque network is specified' do
    let(:network_spec) do
      {
        'static' => {
          'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => {'name' => vlan},
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        }
      }
    end

    let(:vlan) { @opaque_vlan }

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [], vm_type, network_spec, @stemcell_id) do |vm_id|
        # Find VM with id that was given to block (vm_id),
        # examine networks attached to VM,
        # ensure networks are opaque networks and not DVPs
        network = @cpi.client.find_network(@cpi.datacenter, @opaque_vlan)
        vm = @cpi.vm_provider.find(vm_id)

        expect(vm.nics.first.backing).to be_a(VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
        expect(vm.nics.first.backing.opaque_network_id).to eq(network.summary.opaque_network_id)
      end
    end
  end
end
