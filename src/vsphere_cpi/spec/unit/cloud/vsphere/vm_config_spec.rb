require 'spec_helper'

module VSphereCloud
  describe VmConfig do
    def fake_datastore(name, free_space, mob = nil)
      VSphereCloud::Resources::Datastore.new(
          name, mob, true, free_space, free_space
      )
    end

    let(:vm_config) do
      VmConfig.new(
        manifest_params: input,
        cluster_picker: cluster_picker,
        cluster_provider: cluster_provider
      )
    end
    let(:cluster_picker) { ClusterPicker.new(0, 0) }
    let(:cluster_provider) { nil }

    describe '#name' do
      let(:input) { {} }
      it 'returns a valid VM name' do
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(name.size).to eq 39
      end
      it 'is idempotent' do
        name = vm_config.name
        expect(name).to match /vm-.*/
        expect(vm_config.name).to eq name
      end
    end

    describe '#stemcell_cid' do
      let(:input) { { stemcell: { cid: 'fake-stemcell' } } }
      it 'returns the provided stemcell_cid' do
        expect(vm_config.stemcell_cid).to eq('fake-stemcell')
      end
    end

    describe '#agent_id' do
      let(:input) { { agent_id: 'fake-agent' } }
      it 'returns the provided agent_id' do
        expect(vm_config.agent_id).to eq('fake-agent')
      end
    end

    describe '#agent_env' do
      let(:input) { { agent_env: { 'fake-key' => 'fake-value' } } }
      it 'returns the provided agent_env' do
        expect(vm_config.agent_env).to eq({ 'fake-key' => 'fake-value' })
      end
    end

    describe '#vsphere_networks' do
      context 'when networks_spec is provided' do
        let(:input) do
          {
            networks_spec: {
              'net1' => {
                'ip' => '1.2.3.4',
                'cloud_properties' => { 'name' => 'network-1' }
              },
              'net2' => {
                'ip' => '5.6.7.8',
                'cloud_properties' => { 'name' => 'network-2' }
              },
              'net2_second_ip' => {
                'ip' => '9.9.9.9',
                'cloud_properties' => { 'name' => 'network-2' }
              }
            }
          }
        end
        let(:output) do
          {
            'network-1' => ['1.2.3.4'],
            'network-2' => ['5.6.7.8', '9.9.9.9']
          }
        end

        it 'returns a list of vSphere networks' do
          expect(vm_config.vsphere_networks).to eq(output)
        end
      end

      context 'when networks_spec is partially provided' do
        let(:input) do
          {
            networks_spec: {
              'net1' => {
                'ip' => '1.2.3.4',
                'other' => 'values'
              },
              'net2' => {
                'ip' => '5.6.7.8',
                'cloud_properties' => { 'other' => 'some-value' }
              },
              'net3' => {
                'ip' => '9.9.9.9',
                'cloud_properties' => { 'name' => 'network-3' }
              }
            }
          }
        end
        let(:output) do
          {
            'network-3' => ['9.9.9.9']
          }
        end

        it 'returns a list of valid vSphere networks' do
          expect(vm_config.vsphere_networks).to eq(output)
        end
      end

      context 'when networks_spec is not provided' do
        let(:input) { {} }
        let(:output) { {} }

        it 'returns an empty hash' do
          expect(vm_config.vsphere_networks).to eq(output)
        end
      end
    end

    describe '#networks_spec' do
      let(:input) { { networks_spec: { 'fake-key' => 'fake-value' } } }
      it 'returns the provided networks_spec' do
        expect(vm_config.networks_spec).to eq({ 'fake-key' => 'fake-value' })
      end
    end

    describe '#ephemeral_disk_size' do
      let(:input) { { vm_type: { 'disk' => 1234 } } }
      it 'returns the provided disk size' do
        expect(vm_config.ephemeral_disk_size).to eq(1234)
      end
    end

    describe '#cluster' do
      before do
        allow(datastore_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
      end
      let(:datastore_mob) { instance_double('VimSdk::Vim::Datastore') }
      let(:cluster_provider) { instance_double(VSphereCloud::Resources::ClusterProvider) }
      let(:cluster_config) { instance_double(VSphereCloud::ClusterConfig) }
      let(:cluster_config_2) { instance_double(VSphereCloud::ClusterConfig) }
      let(:small_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob: datastore_mob) }
      let(:large_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 2048, mob: datastore_mob) }
      let(:huge_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 10240, mob: datastore_mob) }
      let(:fake_cluster) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'fake-cluster-name',
          free_memory: 2048,
          accessible_datastores: {
            'small-ds' => small_ds,
            'large-ds' => large_ds
          }
        )
      end
      let(:fake_cluster_2) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'fake-cluster-name-2',
          free_memory: 4096,
          accessible_datastores: {
              'small-ds' => small_ds,
              'huge-ds' => huge_ds
          }
        )
      end
      let(:global_clusters) { [fake_cluster] }

      context 'when multiple clusters are specified within vm_type' do
        let(:input) do
          {
            vm_type: {
              'datacenters' => [
                {
                  'name' => 'datacenter-1',
                  'clusters' => [
                    { 'fake-cluster-name' => {} },
                    { 'fake-cluster-name-2' => {} }
                  ]
                }
              ],
              'ram' => ram,
            },
            global_clusters: global_clusters,
          }
        end
        let(:ram) { 512 }

        it 'returns the vm_type cluster' do
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name', {}).and_return(cluster_config)
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name-2', {}).and_return(cluster_config_2)
          
          expect(cluster_provider).to receive(:find).with('fake-cluster-name', cluster_config).and_return(fake_cluster)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name-2', cluster_config_2).and_return(fake_cluster_2)
          
          expect(cluster_picker).to receive(:update).with([fake_cluster, fake_cluster_2])
          expect(cluster_picker).to receive(:best_cluster_placement).with(
            req_memory: ram,
            disk_configurations: anything,
          ).and_return(
            {
              'fake-cluster-name-2' => {
                { 'disk' => 'whatever'} => 'huge-ds'
              }
            }
          )
          expect(vm_config.cluster).to eq(fake_cluster_2)
        end
      end

      context 'when datacenters and clusters are not specified in vm_type' do
        before do
          allow(larger_datastore_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          allow(smaller_datastore_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
        end
        let(:input) do
          {
            vm_type: {
              'ram' => 1024,
              'disk' => 4096
            },
            disk_configurations: disk_configurations,
            global_clusters: global_clusters,
          }
        end
        let(:global_clusters) { [cluster_1, cluster_2] }
        let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
        let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
        let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
        let(:smaller_datastore_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:larger_datastore_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:smaller_ds) { fake_datastore( 'smaller-ds', 512, smaller_datastore_mob) }
        let(:larger_ds) { fake_datastore('larger-ds', 2048, larger_datastore_mob) }
        let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
        let(:cluster2_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
        let(:cluster_1) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-1',
            free_memory: 1024,
            accessible_datastores: {
              'smaller-ds'=> smaller_ds,
            },
            mob: cluster1_mob
          )
        end
        let(:cluster_2) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-2',
            free_memory: 1024,
            accessible_datastores: {
              'larger-ds' => larger_ds,
            },
            mob: cluster2_mob
          )
        end
        let(:disk_configurations) do
          [
            instance_double(VSphereCloud::DiskConfig,
              size: 512,
              ephemeral?: true,
              existing_datastore_name: nil,
              target_datastore_pattern: '.*',
            )
          ]
        end

        it 'returns the picked global cluster' do
          expect(vm_config.cluster).to eq(cluster_2)
        end

        context 'when cluster picking information is not provided' do
          let(:input) { {} }

          it 'raises an error' do
            expect {
              expect(vm_config.cluster)
            }.to raise_error(Bosh::Clouds::CloudError, 'No valid clusters were provided')
          end
        end

        context 'when a disk configuration includes target_datastore_pattern' do
          let(:input) do
            {
              vm_type: {
                'ram' => 1024,
                'disk' => 4096
              },
              disk_configurations: disk_configurations,
              global_clusters: global_clusters,
            }
          end
          let(:disk_configurations) do
            [
              instance_double(VSphereCloud::DiskConfig,
                cid: 'disk-cid',
                size: 256,
                ephemeral?: true,
                existing_datastore_name: nil,
                target_datastore_pattern: '^(smaller-ds)$',
              )
            ]
          end

          it 'uses the pattern specified' do
            expect(vm_config.cluster).to eq(cluster_1)
          end
        end
      end
    end

    describe '#ephemeral_datastore_name' do
      before do
        allow(target_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
        allow(other_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
      end
      let(:input) do
        {
          vm_type: {
            'ram' => 512,
          },
          disk_configurations: disk_configurations,
          global_clusters: global_clusters,
        }
      end
      let(:global_clusters) { [cluster_1] }
      let(:target_ds) { fake_datastore('target-ds', 512, target_ds_mob) }
      let(:other_ds) { fake_datastore('other-ds', 512, other_ds_mob) }
      let(:cluster_1) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'cluster-1',
          free_memory: 2048,
          accessible_datastores: {
            'target-ds' => target_ds,
            'other-ds'=> other_ds,
          },
          mob: cluster1_mob
        )
      end
      let(:disk_configurations) do
        [
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            ephemeral?: true,
            existing_datastore_name: nil,
            target_datastore_pattern: 'target-ds',
          ),
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            cid: 'disk-1234',
            existing_datastore_name: 'other-ds',
            target_datastore_pattern: '.*',
          ),
        ]
      end
      let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
      let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
      let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
      let(:target_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
      let(:other_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
      let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
      it 'returns the datastore where the ephemeral disk was placed' do
        expect(vm_config.ephemeral_datastore_name).to eq('target-ds')
      end

      it 'is idempotent' do
        expect(cluster_picker).to receive(:update)
          .once.and_call_original

        expect(vm_config.ephemeral_datastore_name).to eq('target-ds')
        expect(vm_config.ephemeral_datastore_name).to eq('target-ds')
      end
    end

    describe '#drs_rule' do
      let(:cluster_provider) { instance_double(VSphereCloud::Resources::ClusterProvider) }
      let(:cluster_config) { instance_double(VSphereCloud::ClusterConfig) }
      let(:cluster_config_2) { instance_double(VSphereCloud::ClusterConfig) }
      let(:small_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024) }
      let(:large_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 2048) }
      let(:huge_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 10240) }
      let(:fake_cluster) do
        instance_double(VSphereCloud::Resources::Cluster,
                        name: 'fake-cluster-name',
                        free_memory: 2048,
                        accessible_datastores: {
                            'small-ds' => small_ds,
                            'large-ds' => large_ds
                        }
        )
      end
      let(:fake_cluster_2) do
        instance_double(VSphereCloud::Resources::Cluster,
                        name: 'fake-cluster-name-2',
                        free_memory: 4096,
                        accessible_datastores: {
                            'small-ds' => small_ds,
                            'huge-ds' => huge_ds
                        }
        )
      end


      context 'when drs_rules are specified under cluster' do
        let(:ram) { 512 }
        let(:input) do
          {
            vm_type: {
              'ram' => ram,
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {
                      'drs_rules' => [
                        { 'name' => 'fake-rule', 'type' => 'fake-type' }
                      ]
                    }
                  },
                  {
                    'fake-cluster-name-2' => {}
                  }
                ]
              ]
            }
          }
        end

        it 'returns the provided drs_rule' do
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name', {'drs_rules' =>[{'name' => 'fake-rule', 'type' => 'fake-type'}]}).and_return(cluster_config)
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name-2', {}).and_return(cluster_config_2)
  
          expect(cluster_provider).to receive(:find).with('fake-cluster-name', cluster_config).and_return(fake_cluster)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name-2', cluster_config_2).and_return(fake_cluster_2)
  
          expect(cluster_picker).to receive(:update).with([fake_cluster, fake_cluster_2])
          expect(cluster_picker).to receive(:best_cluster_placement).with(
            req_memory: ram,
            disk_configurations: anything,
          ).and_return(
            {
              'fake-cluster-name' => {
                { 'disk' => 'whatever'} => 'huge-ds'
              }
            }
          )
          expect(vm_config.drs_rule).to eq({ 'name' => 'fake-rule', 'type' => 'fake-type' })
        end
      end

      context 'when drs_rules are not provided' do
        let(:input) do
          {
            vm_type: {
              'ram' => 512,
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {
                      'drs_rules' => []
                    }
                  }
                ]
              ]
            }
          }
        end

        it 'returns nil' do
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name', {'drs_rules' =>[]}).and_return(cluster_config)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name', cluster_config).and_return(fake_cluster)
  
          expect(cluster_picker).to receive(:update).with([fake_cluster])
          expect(cluster_picker).to receive(:best_cluster_placement).with(
              req_memory: 512,
              disk_configurations: anything,
          ).and_return(
              {
                  'fake-cluster-name' => {
                      { 'disk' => 'whatever'} => 'huge-ds'
                  }
              }
          )
          
          expect(vm_config.drs_rule).to be_nil
        end
      end

      context 'when drs_rules are not provided' do
        let(:input) do
          {
            vm_type: {
              'ram' => 512,
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {}
                  }
                ]
              ]
            }
          }
        end

        it 'returns nil' do
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name', {}).and_return(cluster_config)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name', cluster_config).and_return(fake_cluster)
  
          expect(cluster_picker).to receive(:update).with([fake_cluster])
          expect(cluster_picker).to receive(:best_cluster_placement).with(
              req_memory: 512,
              disk_configurations: anything,
          ).and_return(
              {
                  'fake-cluster-name' => {
                      { 'disk' => 'whatever'} => 'huge-ds'
                  }
              }
          )
          
          expect(vm_config.drs_rule).to be_nil
        end
      end
    end

    describe '#config_spec_params' do
      context 'when number of CPUs is provided' do
        let(:input) { { vm_type: { 'cpu' => 2 } } }
        let(:output) { { num_cpus: 2 } }

        it 'maps to num_cpus' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory in MB is provided' do
        let(:input) { { vm_type: { 'ram' => 4096 } } }
        let(:output) { { memory_mb: 4096 } }

        it 'maps to memory_mb' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is true' do
        let(:input) { { vm_type: { 'nested_hardware_virtualization' => true } } }
        let(:output) { { nested_hv_enabled: true } }

        it 'maps to num_cpus' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is false' do
        let(:input) { { vm_type: { 'nested_hardware_virtualization' => false } } }
        let(:output) { {} }

        it 'does not set any value in the config spec params' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when cpu_hot_add_enabled is true' do
        let(:input) { { vm_type: { 'cpu_hot_add_enabled' => true } } }
        let(:output) { { cpu_hot_add_enabled: true } }

        it 'sets it to true' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory_hot_add_enabled is true' do
        let(:input) { { vm_type: { 'memory_hot_add_enabled' => true } } }
        let(:output) { { memory_hot_add_enabled: true }  }

        it 'sets it to true' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

    end

    describe '#validate' do
      let(:small_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024) }
      let(:large_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 2048) }
      let(:fake_cluster) do
        instance_double(VSphereCloud::Resources::Cluster,
                        name: 'fake-cluster-name',
                        free_memory: 2048,
                        accessible_datastores: {
                            'small-ds' => small_ds,
                            'large-ds' => large_ds
                        }
        )
      end
      
      before do
        allow(vm_config).to receive(:cluster).and_return(fake_cluster)
      end
      
      context 'when no DRS rules are specified' do
        let(:input) { {} }

        it 'validation passes' do
          expect{
            vm_config.validate
          }.to_not raise_error
        end
      end

      context 'when a cluster is specified but no DRS rules are specified' do
        let(:input) do
          {
            vm_type: {
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {}
                  }
                ]
              ]
            }
          }
        end

        it 'validation passes' do
          expect{
            vm_config.validate
          }.to_not raise_error
        end
      end

      context 'when several DRS rules are specified in cloud properties' do
        let(:input) do
          {
            vm_type: {
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {
                      'drs_rules' => [
                        { 'name' => 'fake-rule-1', 'type' => drs_rule_type },
                        { 'name' => 'fake-rule-2', 'type' => drs_rule_type }
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
          expect{
            vm_config.validate
          }.to raise_error /vSphere CPI supports only one DRS rule per resource pool/
        end
      end

      context 'when one DRS rule is specified' do
        let(:input) do
          {
            vm_type: {
              'datacenters' => [
                'clusters' => [
                  {
                    'fake-cluster-name' => {
                      'drs_rules' => [
                        { 'name' => 'fake-rule', 'type' => drs_rule_type}
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
            expect{
              vm_config.validate
            }.to_not raise_error
          end
        end

        context 'when DRS rule type is not separate_vms' do
          let(:drs_rule_type) { 'bad_type' }

          it 'raises an error' do
            expect{
              vm_config.validate
            }.to raise_error /vSphere CPI only supports DRS rule of 'separate_vms' type/
          end
        end
      end
    end

    describe '#vmx_options' do
      context 'vmx_options are specified' do
        let(:input) do
          {
            vm_type: {
              'vmx_options' => {
                'sched.mem.maxmemctl' => '0'
              }
            }
          }
        end

        it 'should return the vmx_options' do
          expect(vm_config.vmx_options).to eq({ 'sched.mem.maxmemctl' => '0' })
        end
      end

      context 'vmx_options are NOT specified' do
        let(:input) do
          {
            vm_type: {}
          }
        end

        it 'should return empty hash' do
          expect(vm_config.vmx_options).to eq({})
        end
      end

    end

    describe '#datastore_clusters' do
      context 'datastore_clusters are NOT specified' do
        let(:input) do
          {
            vm_type: {
              'datastores' => ['fake-datastore']
            }
          }
        end
        it 'should return empty array' do
          expect(vm_config.datastore_clusters).to eq([])
        end
      end
      context 'datastore_clusters are specified inside datastores' do
        before (:all) do
          @drs_enabled_atastore_cluster = 'fake-datastore1'
          @drs_disabled_datastore_cluster = 'fake-datastore2'
        end
        let(:datastore_cluster_1) do
          instance_double(VSphereCloud::Resources::StoragePod,
            name: @drs_enabled_atastore_cluster,
            free_space: 2048,
            capacity: 4096
          )
        end
        let(:input) do
          {
            vm_type: {
              'datastores' => ['fake-datastore', 'cluster' => [@drs_enabled_atastore_cluster, @drs_disabled_datastore_cluster]]
            }
          }
        end
        it 'should return array of datastore clusters which have drs enabled' do #TODO should we only return drs enabled datastore_clusters resource here?
          expect(vm_config.datastore_clusters).to eq([datastore_cluster_1])
        end
      end
    end
  end
end
