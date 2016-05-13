require 'spec_helper'

module VSphereCloud
  describe VmConfig do
    describe '#name' do
      let(:input) { {} }
      it 'returns a valid VM name' do
        vm_config = VmConfig.new(manifest_params: input)
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(name.size).to eq 39
      end
      it 'is idempotent' do
        vm_config = VmConfig.new(manifest_params: input)
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(vm_config.name).to eq name
      end
    end

    describe '#stemcell_cid' do
      let(:input) { { stemcell: { cid: "fake-stemcell" } } }
      it 'returns the provided stemcell_cid' do
        vm_config = VmConfig.new(manifest_params: input)
        expect(vm_config.stemcell_cid).to eq("fake-stemcell")
      end
    end

    describe '#agent_id' do
      let(:input) { { agent_id: "fake-agent" } }
      it 'returns the provided agent_id' do
        vm_config = VmConfig.new(manifest_params: input)
        expect(vm_config.agent_id).to eq("fake-agent")
      end
    end

    describe '#agent_env' do
      let(:input) { { agent_env: {"fake-key" => "fake-value"} } }
      it 'returns the provided agent_env' do
        vm_config = VmConfig.new(manifest_params: input)
        expect(vm_config.agent_env).to eq({"fake-key" => "fake-value"})
      end
    end

    describe '#vsphere_networks' do
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
              },
              "net2_second_ip" => {
                "ip" => "9.9.9.9",
                "cloud_properties" => {"name" => "network-2"}
              }
            }
          }
        end
        let(:output) do
          {
            "network-1" => ["1.2.3.4"],
            "network-2" => ["5.6.7.8", "9.9.9.9"]
          }
        end

        it 'returns a list of vSphere networks' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.vsphere_networks).to eq(output)
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
            "network-3" => ["9.9.9.9"]
          }
        end

        it 'returns a list of valid vSphere networks' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.vsphere_networks).to eq(output)
        end
      end

      context 'when networks_spec is not provided' do
        let(:input) { {} }
        let(:output) { {} }

        it 'returns an empty hash' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.vsphere_networks).to eq(output)
        end
      end
    end

    describe '#networks_spec' do
      let(:input) { { networks_spec: {"fake-key" => "fake-value"} } }
      it 'returns the provided networks_spec' do
        vm_config = VmConfig.new(manifest_params: input)
        expect(vm_config.networks_spec).to eq({"fake-key" => "fake-value"})
      end
    end

    describe '#ephemeral_disk_size' do
      let(:input) { { resource_pool: { "disk" => 1234 } } }
      it 'returns the provided disk size' do
        vm_config = VmConfig.new(manifest_params: input)
        expect(vm_config.ephemeral_disk_size).to eq(1234)
      end
    end

    describe '#cluster_name' do

      context 'when datacenters and clusters are specified in resource_pool' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  { "fake-cluster-name" => {} }
                ]
              ]
            },
            available_clusters: available_clusters,
          }
        end
        let(:available_clusters) do
          {
            "fake-cluster-name" => {},
          }
        end

        it 'returns the provided cluster name' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.cluster_name).to eq("fake-cluster-name")
        end

        context 'when a non-existent cluster is specified in resource_pool' do
          let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  { "fake-cluster-name" => {} }
                ]
              ]
            },
            available_clusters: available_clusters
          }
          end
          let(:available_clusters) do
            {
              "some-cluster" => {},
              "some-other-cluster" => {},
            }
          end

          it 'raises an error' do
            vm_config = VmConfig.new(manifest_params: input)
            expect {
              vm_config.cluster_name
            }.to raise_error Bosh::Clouds::CloudError, "Cluster 'fake-cluster-name' does not match provided clusters [some-cluster, some-other-cluster]"
          end
        end
      end

      context 'when datacenters and clusters are not specified in resource_pool' do
        let(:input) do
          {
            resource_pool: {
              "ram" => 1024,
              "disk" => 4096
            },
            stemcell: {
              cid: "fake-stemcell-id",
              size: 2048
            },
            disk_configurations: disk_configurations,
            available_clusters: available_clusters,
            global_ephemeral_datastore_pattern: /anything/,
            global_persistent_datastore_pattern: /something/,
          }
        end
        let(:available_clusters) do
          {
            "fake-cluster" => {}
          }
        end
        let(:disk_configurations) do
          [{
            size: 20_000,
            cid: 'fake-cid',
            metadata: {},
          }]
        end
        let (:cluster_picker) { instance_double(ClusterPicker) }

        it 'returns the picked cluster' do
          expect(cluster_picker).to receive(:update)
            .with(available_clusters)
          expect(cluster_picker).to receive(:pick_cluster)
            .with(
              req_memory: 1024,
              req_ephemeral_size: 1024 + 4096 + 2048,
              disk_configurations: disk_configurations,
              ephemeral_datastore_pattern: /anything/,
              persistent_datastore_pattern: /something/
            )
            .and_return("fake-cluster")

          vm_config = VmConfig.new(
            cluster_picker: cluster_picker,
            manifest_params: input
          )
          expect(vm_config.cluster_name).to eq("fake-cluster")
        end

        it 'is idempotent' do
          expect(cluster_picker).to receive(:update)
            .with(available_clusters).once
          expect(cluster_picker).to receive(:pick_cluster)
            .once
            .with(
              req_memory: 1024,
              req_ephemeral_size: 1024 + 4096 + 2048,
              disk_configurations: disk_configurations,
              ephemeral_datastore_pattern: /anything/,
              persistent_datastore_pattern: /something/
            )
            .and_return("fake-cluster")

          vm_config = VmConfig.new(
            cluster_picker: cluster_picker,
            manifest_params: input
          )
          expect(vm_config.cluster_name).to eq("fake-cluster")
          expect(vm_config.cluster_name).to eq("fake-cluster")
        end

        context 'when cluster picking information is not provided' do
          let(:input) { {} }

          it 'returns nil' do
            vm_config = VmConfig.new(manifest_params: input)
            expect(vm_config.cluster_name).to eq(nil)
          end
        end

        context 'when datastores are provided with the resource_pool' do
          let(:input) do
            {
              resource_pool: {
                "ram" => 1024,
                "disk" => 4096,
                "datastores" => ['fake-cluster2-ds']
              },
              stemcell: {
                cid: "fake-stemcell-id",
                size: 2048
              },
              disk_configurations: disk_configurations,
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /anything/,
              global_persistent_datastore_pattern: /something/
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster1" => {
                datastores: { "fake-cluster1-ds" => 1024 }
              },
              "fake-cluster2" => {
                datastores: { "fake-cluster2-ds" => 1024}
              }
            }
          end
          it 'uses an ephemeral datastore pattern specified in resource_pool["datastores"]' do
            allow(cluster_picker).to receive(:update)
              .with(available_clusters)
            expect(cluster_picker).to receive(:pick_cluster)
                .with(
                  req_memory: 1024,
                  req_ephemeral_size: 1024 + 4096 + 2048,
                  disk_configurations: disk_configurations,
                  ephemeral_datastore_pattern: /^(fake\-cluster2\-ds)$/,
                  persistent_datastore_pattern: /something/
                )
                .once
                .and_return("fake-cluster2")

            vm_config = VmConfig.new(
              cluster_picker: cluster_picker,
              manifest_params: input
            )

            expect(vm_config.cluster_name).to eq("fake-cluster2")
          end
        end

        context 'when disk_metadata is provided' do
          let(:input) do
            {
              resource_pool: {
                "ram" => 1024,
                "disk" => 4096
              },
              stemcell: {
                cid: "fake-stemcell-id",
                size: 2048
              },
              disk_configurations: disk_configurations,
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /anything/,
              global_persistent_datastore_pattern: /not\-used/,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster1" => {
                datastores: { "fake-cluster1-ds" => 1024 }
              },
              "fake-cluster2" => {
                datastores: { "fake-cluster2-ds" => 1024}
              }
            }
          end
          let(:disk_configurations) do
            [{
              size: 20_000,
              cid: 'fake-cid',
              metadata: { 'persistent_datastores_pattern' => '^(fake\\-cluster1\\-ds)$' },
            }]
          end

          it 'uses the persistent datastore pattern specified in disk_metadata' do
            allow(cluster_picker).to receive(:update)
              .with(available_clusters)
            expect(cluster_picker).to receive(:pick_cluster)
              .with(
                req_memory: 1024,
                req_ephemeral_size: 1024 + 4096 + 2048,
                disk_configurations: disk_configurations,
                ephemeral_datastore_pattern: /anything/,
                persistent_datastore_pattern: /^(fake\-cluster1\-ds)$/
              )
              .once
              .and_return("fake-cluster2")

            vm_config = VmConfig.new(
              cluster_picker: cluster_picker,
              manifest_params: input
            )

            expect(vm_config.cluster_name).to eq("fake-cluster2")
          end
        end
      end
    end

    describe '#datastore_name' do
      context 'when clusters and datastore are provided' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  { "fake-cluster" => {} }
                ]
              ],
              "disk" => 4096
            },
            available_clusters: available_clusters,
            global_ephemeral_datastore_pattern: /fake-pattern/,
          }
        end
        let(:available_clusters) do
          {
            "fake-cluster" => {
              datastores: { "fake-ds" => "hash" }
            }
          }
        end
        let (:datastore_picker) { instance_double(DatastorePicker) }

        it 'returns the picked datastore' do
          expect(datastore_picker).to receive(:update)
            .with({ "fake-ds" => "hash" })
          expect(datastore_picker).to receive(:pick_datastore)
            .with(4096, /fake-pattern/)
            .and_return("fake-ds")

          vm_config = VmConfig.new(
            datastore_picker: datastore_picker,
            manifest_params: input
          )
          expect(vm_config.datastore_name).to eq("fake-ds")
        end

        it 'is idempotent' do
          expect(datastore_picker).to receive(:update)
            .once
            .with({ "fake-ds" => "hash" })
          expect(datastore_picker).to receive(:pick_datastore)
            .once
            .with(4096, /fake-pattern/)
            .and_return("fake-ds")

          vm_config = VmConfig.new(
            datastore_picker: datastore_picker,
            manifest_params: input
          )

          expect(vm_config.datastore_name).to eq("fake-ds")
          expect(vm_config.datastore_name).to eq("fake-ds")
        end

        context 'when datastore picking information is not provided' do
          let(:input) { {} }

          it 'returns nil' do
            vm_config = VmConfig.new(manifest_params: input)
            expect(vm_config.datastore_name).to eq(nil)
          end
        end

        context 'when the resource_pool cluster does not exist in available_clusters' do
          let(:input) do
            {
              resource_pool: {
                "datacenters" => [
                  "clusters" => [
                    { "other-cluster" => {} }
                  ]
                ],
                "disk" => 4096,
              },
              available_clusters: available_clusters,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster1" => {
                datastores: { "fake-ds1" => "hash" }
              },
              "fake-cluster2" => {
                datastores: { "fake-ds2" => "hash" }
              }
            }
          end
          let (:datastore_picker) { instance_double(DatastorePicker) }
          it 'raises an error' do
            vm_config = VmConfig.new(
              datastore_picker: datastore_picker,
              manifest_params: input
            )
            expect {
              vm_config.datastore_name
            }.to raise_error Bosh::Clouds::CloudError, "Cluster 'other-cluster' does not match provided clusters [fake-cluster1, fake-cluster2]"
          end
        end
      end

      context 'when a list of datastores is provided in resource_pool' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  { "fake-cluster" => {} }
                ]
              ],
              "disk" => 4096,
              'datastores' => ['fake-ds', 'other.*ds']
            },
            available_clusters: available_clusters,
            global_ephemeral_datastore_pattern: /unused-pattern/,
          }
        end
        let(:available_clusters) do
          {
            "fake-cluster" => {
              datastores: { "fake-ds" => "hash" }
            }
          }
        end
        let (:datastore_picker) { instance_double(DatastorePicker) }

        it 'returns the picked datastore' do
          expect(datastore_picker).to receive(:update)
            .with({ "fake-ds" => "hash" })
          expect(datastore_picker).to receive(:pick_datastore)
            .with(4096, /^(fake\-ds|other\.\*ds)$/)
            .and_return("fake-ds")

          vm_config = VmConfig.new(
            datastore_picker: datastore_picker,
            manifest_params: input
          )
          ds_name = vm_config.datastore_name
          expect(ds_name).to eq("fake-ds")
        end

        context 'when multiple clusters have different datastores with the same name' do
          let(:input) do
            {
              resource_pool: {
                "datacenters" => [
                  "clusters" => [
                    { "fake-cluster2" => {} }
                  ]
                ],
                "disk" => 4096,
                'datastores' => ['fake-ds', 'other.*ds']
              },
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /unused-pattern/,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster1" => {
                datastores: { "fake-ds" => 16384 }
              },
              "fake-cluster2" => {
                datastores: { "fake-ds" => 8192 }
              }
            }
          end
          let (:datastore_picker) { instance_double(DatastorePicker) }

          it "returns the correct cluster's datastore" do
            expect(datastore_picker).to receive(:update)
              .with({ "fake-ds" => 8192 })
            expect(datastore_picker).to receive(:pick_datastore)
              .with(4096, /^(fake\-ds|other\.\*ds)$/)
              .and_return("fake-ds")

            vm_config = VmConfig.new(
              datastore_picker: datastore_picker,
              manifest_params: input
            )
            ds_name = vm_config.datastore_name
            expect(ds_name).to eq("fake-ds")
          end
        end

        context "when resource_pool datastores and datacenter params don't match" do
          let(:input) do
            {
              resource_pool: {
                "datacenters" => [
                  "clusters" => [
                    { "fake-cluster" => {} }
                  ]
                ],
                "disk" => 4096,
                'datastores' => ['other-ds']
              },
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /unused-pattern/,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster" => {
                datastores: { "fake-ds" => "hash" }
              }
            }
          end

          it 'raises a CloudError' do
          expect(datastore_picker).to receive(:update)
            .with({ "fake-ds" => "hash" })
            expect(datastore_picker).to receive(:pick_datastore)
              .with(4096, /^(other\-ds)$/)
              .and_raise(Bosh::Clouds::CloudError)

            vm_config = VmConfig.new(
              datastore_picker: datastore_picker,
              manifest_params: input
            )

            expect { vm_config.datastore_name }.to raise_error
          end
        end

        context "when the datastores list is empty" do
          let(:input) do
            {
              resource_pool: {
                "datacenters" => [
                  "clusters" => [
                    { "fake-cluster" => {} }
                  ]
                ],
                "disk" => 4096,
                'datastores' => []
              },
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /fallback-ds/,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster" => {
                datastores: { "fallback-ds" => "hash" }
              }
            }
          end
          let (:datastore_picker) { instance_double(DatastorePicker) }

          it 'returns the datastore from global properties' do
            expect(datastore_picker).to receive(:update)
              .with({ "fallback-ds" => "hash" })
            expect(datastore_picker).to receive(:pick_datastore)
              .with(4096, /fallback-ds/)
              .and_return("fallback-ds")

            vm_config = VmConfig.new(
              datastore_picker: datastore_picker,
              manifest_params: input
            )
            ds_name = vm_config.datastore_name
            expect(ds_name).to eq("fallback-ds")
          end
        end

        context "when the datastores list is nil" do
          let(:input) do
            {
              resource_pool: {
                "datacenters" => [
                  "clusters" => [
                    { "fake-cluster" => {} }
                  ]
                ],
                "disk" => 4096,
                'datastores' => nil,
              },
              available_clusters: available_clusters,
              global_ephemeral_datastore_pattern: /fallback-ds/,
            }
          end
          let(:available_clusters) do
            {
              "fake-cluster" => {
                datastores: { "fallback-ds" => "hash" }
              }
            }
          end
          let (:datastore_picker) { instance_double(DatastorePicker) }

          it 'returns the datastore from global properties' do
            expect(datastore_picker).to receive(:update)
              .with({ "fallback-ds" => "hash" })
            expect(datastore_picker).to receive(:pick_datastore)
              .with(4096, /fallback-ds/)
              .and_return("fallback-ds")

            vm_config = VmConfig.new(
              datastore_picker: datastore_picker,
              manifest_params: input
            )
            ds_name = vm_config.datastore_name
            expect(ds_name).to eq("fallback-ds")
          end

        end
      end
    end

    describe '#drs_rule' do
      context 'when drs_rules are specified under cluster' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {
                      "drs_rules" => [
                        { "name" => "fake-rule", "type" => "fake-type" }
                      ]
                    }
                  }
                ]
              ]
            }
          }
        end

        it 'returns the provided drs_rule' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.drs_rule).to eq({ "name" => "fake-rule", "type" => "fake-type" })
        end
      end

      context 'when drs_rules are not provided' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {
                      "drs_rules" => []
                    }
                  }
                ]
              ]
            }
          }
        end

        it 'returns nil' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.drs_rule).to be_nil
        end
      end

      context 'when drs_rules are not provided' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {}
                  }
                ]
              ]
            }
          }
        end

        it 'returns nil' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.drs_rule).to be_nil
        end
      end
    end

    describe '#config_spec_params' do
      context 'when number of CPUs is provided' do
        let(:input) { { resource_pool: { "cpu" => 2 } } }
        let(:output) { { num_cpus: 2 } }
        it 'maps to num_cpus' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory in MB is provided' do
        let(:input) { { resource_pool: { "ram" => 4096 } } }
        let(:output) { { memory_mb: 4096 } }
        it 'maps to memory_mb' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is true' do
        let(:input) { { resource_pool: { "nested_hardware_virtualization" => true } } }
        let(:output) { { nested_hv_enabled: true } }
        it 'maps to num_cpus' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is false' do
        let(:input) { { resource_pool: { "nested_hardware_virtualization" => false } } }
        let(:output) { {} }
        it 'does not set any value in the config spec params' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when cpu_hot_add_enabled is true' do
        let(:input) { { resource_pool: { "cpu_hot_add_enabled" => true } } }
        let(:output) { { cpu_hot_add_enabled: true } }
        it 'sets it to true' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory_hot_add_enabled is true' do
        let(:input) { { resource_pool: { "memory_hot_add_enabled" => true } } }
        let(:output) { { memory_hot_add_enabled: true }  }
        it 'sets it to true' do
          vm_config = VmConfig.new(manifest_params: input)
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

    end

    describe '#validate_drs_rules' do
      context 'when no DRS rules are specified' do
        let(:input) { {} }

        it 'validation passes' do
          vm_config = VmConfig.new(manifest_params: input)
          expect{
            vm_config.validate_drs_rules
          }.to_not raise_error
        end
      end

      context 'when a cluster is specified but no DRS rules are specified' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {}
                  }
                ]
              ]
            }
          }
        end

        it 'validation passes' do
          vm_config = VmConfig.new(manifest_params: input)
          expect{
            vm_config.validate_drs_rules
          }.to_not raise_error
        end
      end

      context 'when several DRS rules are specified in cloud properties' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {
                      "drs_rules" => [
                        { "name" => "fake-rule-1", "type" => drs_rule_type },
                        { "name" => "fake-rule-2", "type" => drs_rule_type }
                      ]
                    }
                  }
                ]
              ]
            }
          }
        end
        let(:drs_rule_type) { 'separate_vms' }

        it 'raises an error' do
          vm_config = VmConfig.new(manifest_params: input)
          expect{
            vm_config.validate_drs_rules
          }.to raise_error /vSphere CPI supports only one DRS rule per resource pool/
        end
      end

      context 'when one DRS rule is specified' do
        let(:input) do
          {
            resource_pool: {
              "datacenters" => [
                "clusters" => [
                  {
                    "fake-cluster-name" => {
                      "drs_rules" => [
                        { "name" => "fake-rule", "type" => drs_rule_type}
                      ]
                    }
                  }
                ]
              ]
            }
          }
        end

        context 'when DRS rule type is separate_vms' do
          let(:drs_rule_type) { 'separate_vms' }

          it 'validation passes' do
            vm_config = VmConfig.new(manifest_params: input)
            expect{
              vm_config.validate_drs_rules
            }.to_not raise_error
          end
        end

        context 'when DRS rule type is not separate_vms' do
          let(:drs_rule_type) { 'bad_type' }

          it 'raises an error' do
            vm_config = VmConfig.new(manifest_params: input)
            expect{
              vm_config.validate_drs_rules
            }.to raise_error /vSphere CPI only supports DRS rule of 'separate_vms' type/
          end
        end
      end
    end

  end
end
