require 'integration/spec_helper'
require 'securerandom'
require 'tempfile'
require 'yaml'

describe 'set_vm_metadata' do
  context 'when called with duplicate keys with multiple threads' do
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    let(:metadata) { { "bosh-#{SecureRandom.uuid}-key" => "test value" } }
    let(:network_spec) do
      {
        'static' => {
          'ip' => "169.254.1.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => { 'name' => @vlan },
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        }
      }
    end
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end

    after do
      cpi.delete_vm(@vm_cid) if @vm_cid
      cpi.client.remove_custom_field_def(metadata.keys.first, VimSdk::Vim::VirtualMachine)
    end

    it 'succeeds' do
      @vm_cid = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )
      threads = []
      cpis = []
      pool_size = 5
      pool_size.times do
        cpis << VSphereCloud::Cloud.new(cpi_options)
      end

      pool_size.times do |i|
        threads << Thread.new do
          cpis[i].set_vm_metadata(@vm_cid, metadata)
        end
      end

      expect {
        threads.map(&:join)
      }.to_not raise_error
    end
  end
end
