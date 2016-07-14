require 'integration/spec_helper'

context 'when cluster specified for VM cannot access datastore matching the given pattern' do

  let(:resource_pool) do
    {
      'ram' => 1024,
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

  let(:cpi) do
    options_with_cluster_datastore_mismatch = cpi_options(
      datastore_pattern: @second_cluster_datastore,
      persistent_datastore_pattern: @second_cluster_datastore,
      clusters: [{ @cluster => {'resource_pool' => @resource_pool_name} }],
    )
    second_cluster_cpi = VSphereCloud::Cloud.new(options_with_cluster_datastore_mismatch)
  end

  it 'raises an error containing target cluster and datastore' do
    expect {
      cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
    }.to raise_error { |error|
      expect(error).to be_a(Bosh::Clouds::CloudError)
      expect(error.message).to include(@second_cluster_datastore)
      expect(error.message).to include('No valid placement found for disks')
    }
  end
end
