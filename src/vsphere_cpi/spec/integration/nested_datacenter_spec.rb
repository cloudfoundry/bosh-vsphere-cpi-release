require 'integration/spec_helper'

describe 'nested datacenters' do

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

  let(:vlan) { @vlan }

  let(:resource_pool) do
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when datacenter is in folder' do
    let(:vlan) { @nested_datacenter_vlan }

    it 'exercises the vm lifecycle' do
      begin
        nested_datacenter_cpi = VSphereCloud::Cloud.new(@nested_datacenter_cpi_options)
        nested_datacenter_stemcell_id = nil
        Dir.mktmpdir do |temp_dir|
          output = `tar -C #{temp_dir} -xzf #{@stemcell_path} 2>&1`
          raise "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
          nested_datacenter_stemcell_id = nested_datacenter_cpi.create_stemcell("#{temp_dir}/image", nil)
        end

        vm_lifecycle(nested_datacenter_cpi, [], resource_pool, network_spec, nested_datacenter_stemcell_id)
      ensure
        delete_stemcell(nested_datacenter_cpi, nested_datacenter_stemcell_id)
      end
    end
  end
end
