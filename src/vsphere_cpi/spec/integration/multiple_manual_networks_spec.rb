require 'integration/spec_helper'

describe 'multiple manual networks' do

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      },
      'second' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vlan) { @vlan }

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'with multiple manual networks' do
    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [], vm_type, network_spec, @stemcell_id)
    end
  end
end
