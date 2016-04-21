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

    describe '#stemcell_cid' do
      let(:input) { { stemcell_cid: "fake-stemcell" } }
      it 'returns the provided stemcell_cid' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.stemcell_cid).to eq("fake-stemcell")
      end
    end

    describe '#agent_id' do
      let(:input) { { agent_id: "fake-agent" } }
      it 'returns the provided agent_id' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.agent_id).to eq("fake-agent")
      end
    end

    describe '#agent_env' do
      let(:input) { { agent_env: {"fake-key" => "fake-value"} } }
      it 'returns the provided agent_env' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.agent_env).to eq({"fake-key" => "fake-value"})
      end
    end

    describe '#persistent_disk_cids' do
      let(:input) { { persistent_disk_cids: ["1234", "5678"] } }
      it 'returns the provided persistent_disk_cids' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.persistent_disk_cids).to eq(["1234", "5678"])
      end
    end

    describe '#networks' do
      context 'when networks_spec is provided' do
        let(:input) do
          {
            networks_spec: {
              "net1" => {
                "ip" => "1.2.3.4",
                "cloud_properties" => {"name" => "network-1"}
              },
              "net2" => {
                "ip" => "5.6.7.8",
                "cloud_properties" => {"name" => "network-2"}
              }
            }
          }
        end
        let(:output) do
          {
            "network-1" => "1.2.3.4",
            "network-2" => "5.6.7.8"
          }
        end

        it 'returns a list of vSphere networks' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.networks).to eq(output)
        end
      end

      context 'when networks_spec is partially provided' do
        let(:input) do
          {
            networks_spec: {
              "net1" => {
                "ip" => "1.2.3.4",
                "other" => "values"
              },
              "net2" => {
                "ip" => "5.6.7.8",
                "cloud_properties" => {"other" => "some-value"}
              },
              "net3" => {
                "ip" => "9.9.9.9",
                "cloud_properties" => {"name" => "network-3"}
              }
            }
          }
        end
        let(:output) do
          {
            "network-3" => "9.9.9.9"
          }
        end

        it 'returns a list of valid vSphere networks' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.networks).to eq(output)
        end
      end

      context 'when networks_spec is not provided' do
        let(:input) { {} }
        let(:output) { {} }

        it 'returns an empty hash' do
          vm_config = VmConfig.new
          vm_config.manifest_params = input
          expect(vm_config.networks).to eq(output)
        end
      end
    end

    describe '#ephemeral_disk_size' do
      let(:input) { { resource_pool: { "disk" => 1234 } } }
      it 'returns the provided disk size' do
        vm_config = VmConfig.new
        vm_config.manifest_params = input
        expect(vm_config.ephemeral_disk_size).to eq(1234)
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
        let(:input) { { resource_pool: { "ram" => 4096 } } }
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
