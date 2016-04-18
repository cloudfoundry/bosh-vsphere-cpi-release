require 'spec_helper'

module VSphereCloud
  describe VmConfig do
    describe '#name' do
      it 'returns a valid VM name' do
        vm_config = VmConfig.new
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(name.size).to eq 39
      end
      it 'is idempotent' do
        vm_config = VmConfig.new
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(vm_config.name).to eq name
      end
    end

    describe '#cluster' do
      let(:input) { { cluster: "fake-cluster" } }
      it 'returns a selected cluster name' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.cluster).to eq("fake-cluster")
      end
    end

    describe '#datastore' do
      let(:input) { { datastore: "fake-datastore" } }
      it 'returns a selected datastore' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.datastore).to eq("fake-datastore")
      end
    end

    describe '#network_names' do
      context 'when networks_spec is provided' do
        let(:input) do
          {
            networks_spec: {
              "net1" => {"cloud_properties" => {"name" => "network-1"}},
              "net2" => {"cloud_properties" => {"name" => "network-2"}}
            }
          }
        end
        let(:output) { ["network-1", "network-2"] }

        it 'returns a list of vSphere networks' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.network_names).to eq(output)
        end
      end

      context 'when networks_spec is partially provided' do
        let(:input) do
          {
            networks_spec: {
              "net1" => {"other" => "values"},
              "net2" => {"cloud_properties" => {"other" => "properties"}},
              "net3" => {"cloud_properties" => {"name" => "network-3"}}
            }
          }
        end
        let(:output) { ["network-3"] }

        it 'returns a list of valid vSphere networks' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.network_names).to eq(output)
        end
      end

      context 'when networks_spec is not provided' do
        let(:input) { {} }
        let(:output) { [] }

        it 'returns an empty list' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.network_names).to eq(output)
        end
      end
    end

    describe '#config_spec_params' do
      context 'when number of CPUs is provided' do
        let(:input) { { resource_pool: { "cpu" => 2 } } }
        let(:output) { { num_cpus: 2 } }
        it 'maps to num_cpus' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory in MB is provided' do
        let(:input) { { resource_pool: { "memory" => 4096 } } }
        let(:output) { { memory_mb: 4096 } }
        it 'maps to memory_mb' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is true' do
        let(:input) { { resource_pool: { "nested_hardware_virtualization" => true } } }
        let(:output) { { nested_hv_enabled: true } }
        it 'maps to num_cpus' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is false' do
        let(:input) { { resource_pool: { "nested_hardware_virtualization" => false } } }
        let(:output) { {} }
        it 'does not set any value in the config spec params' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.config_spec_params).to eq(output)
        end
      end
    end

  end
end
