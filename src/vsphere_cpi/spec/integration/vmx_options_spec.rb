require 'integration/spec_helper'

describe 'vmx_options' do
  let(:vmx_option_key) { 'some_key' }

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

  context 'when vmx_options are provided as a Hash' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'vmx_options' => {
          vmx_option_key => 'some_value'
        }
      }
    end

    it 'can set the defined vmx_options as configuration properties' do
      begin
        vm_id, _ = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec
        )
        vm = @cpi.vm_provider.find(vm_id)

        found_vmx_option = vm.mob.config.extra_config.find {|c| c.key == vmx_option_key}
        expect(found_vmx_option).not_to be_nil
        expect(found_vmx_option.value).to eq('some_value')
      ensure
        delete_vm(@cpi, vm_id)
      end
    end
  end

  context 'when vmx_options are NOT a Hash' do
    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'vmx_options' => [
          vmx_option_key => 'some_value'
        ]
      }
    end

    it 'can set the defined vmx_options as configuration properties' do
      expect {
        vm_id, _ = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec
        )
      }.to raise_error(/Unable to parse vmx options/)
    end
  end
end
