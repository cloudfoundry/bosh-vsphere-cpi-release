require 'spec_helper'

module VSphereCloud
  describe VmConfig do
    def fake_datastore(name, free_space, mob = nil)
      VSphereCloud::Resources::Datastore.new(
          name, mob, true, free_space, free_space
      )
    end

    let(:input) { {} }

    let(:vm_config) do
      VmConfig.new(
        manifest_params: input,
        cluster_provider: cluster_provider
      )
    end
    let(:pbm) { double('Pbm') }
    let(:datacenter) { double(name: 'fake-dc') }
    let(:vm_type) { VmType.new(datacenter, cloud_properties, pbm)}
    let(:cluster_provider) { nil }

    describe '#upgrade_hw_version?' do
      let(:input) { { vm_type: vm_type } }
      context 'when upgrade hardware version is nil (not specified) in both vm_type and global config' do
        let(:cloud_properties) {{}}
        it 'should return nil' do
          expect(vm_config.upgrade_hw_version?(vm_type.upgrade_hw_version, nil)).to be(nil)
        end
      end
      context 'when upgrade hardware version is nil (not specified) in vm_type and false in global config' do
        let(:cloud_properties) {{}}
        it 'should return false' do
          expect(vm_config.upgrade_hw_version?(vm_type.upgrade_hw_version, false)).to be(false)
        end
      end
      context 'when upgrade hardware version is false  in vm_type and true in global config' do
        let(:cloud_properties) {{'upgrade_hw_version' => false,}}
        it 'should return false' do
          expect(vm_config.upgrade_hw_version?(vm_type.upgrade_hw_version, true)).to be(false)
        end
      end
      context 'when upgrade hardware version is true  in vm_type and false in global config' do
        let(:cloud_properties) {{'upgrade_hw_version' => true,}}
        it 'should return true' do
          expect(vm_config.upgrade_hw_version?(vm_type.upgrade_hw_version, false)).to be(true)
        end
      end
    end

    describe '#name' do
      let(:input) { {} }

      context 'when vm_cid already exists' do
        let(:vm_cid) { 'vm-82476bf0-4f54-11e9-8647-d663bd873d93' }
        before do
          vm_config.instance_variable_set(:@vm_cid, vm_cid)
        end
        it 'returns the same name' do
          expect(vm_config.name).to eq(vm_cid)
        end
      end

      context 'when vm_cid does not exists' do
        context 'when human readable name enabled set to false' do
          it 'returns a valid UUID based VM name' do
            allow(vm_config).to receive(:human_readable_name_enabled?).and_return(false)
            name = vm_config.name
            expect(name).to match /vm-.*/
            expect(name.size).to eq 39
          end
        end

        context 'when human readable name enabled is set to true' do
          context 'when human readable name information contains ASCII characters only' do
            context 'when human readable name information has both instance group name and deployment name' do


              let(:input){ { human_readable_name_info: OpenStruct.new(inst_grp: 'fake-instance-group-name', deployment: 'fake-deployment-name') } }
              it 'returns a valid human readable name' do
                allow(vm_config).to receive(:generate_human_readable_name).with('fake-instance-group-name', 'fake-deployment-name').and_return('fake-instance-group-name_fake-deployment-name_13197a1f437e')
                allow(vm_config).to receive(:human_readable_name_enabled?).and_return(true)
                name = vm_config.name
                expect(name).to eq('fake-instance-group-name_fake-deployment-name_13197a1f437e')
              end
            end
            context 'when human readable name info is nil' do
              let(:input){ { human_readable_name_info: nil } }
              it 'returns a UUID based VM name' do
                allow(vm_config).to receive(:human_readable_name_enabled?).and_return(true)
                name = vm_config.name
                expect(name).to match /vm-.*/
                expect(name.size).to eq 39
              end
            end
          end
          context 'when human readable name info contains non-ASCII characters' do
            let(:input){ { human_readable_name_info: OpenStruct.new(inst_grp: 'fake-instance-group-αβ', deployment: 'fake-deployment-name') } }
            it 'returns a UUID based VM name' do
              allow(vm_config).to receive(:generate_human_readable_name).with('fake-instance-group-αβ', 'fake-deployment-name').and_return('fake-instance-group-αβ1_fake-deployment-name_13197a1f437e')
              allow(vm_config).to receive(:human_readable_name_enabled?).and_return(true)
              name = vm_config.name
              expect(name).to match /vm-.*/
              expect(name.size).to eq 39
            end
          end
        end
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

    describe '#human_readable_name_enabled?' do
      context 'when enable human readable name set to false' do
        let(:input) { { enable_human_readable_name: false } }
        it 'returns value false' do
          expect(vm_config.human_readable_name_enabled?).to eq(false)
        end
      end

      context 'when enable human readable name set to true' do
        let(:input) { { enable_human_readable_name: true } }
        it 'returns value true' do
          expect(vm_config.human_readable_name_enabled?).to eq(true)
        end
      end
    end

    describe '#human_readable_name_info' do
      context 'when human readable name info is empty' do
        let(:input) { { human_readable_name_info: nil } }
        it 'returns nil' do
          expect(vm_config.human_readable_name_info).to be_nil
        end
      end

      context 'when human readable name info is set' do
        let(:input) { { human_readable_name_info: ['fake_instance_group_name', 'fake_deployment_name'] } }
        it 'returns name info' do
          expect(vm_config.human_readable_name_info).to eq( ['fake_instance_group_name', 'fake_deployment_name'] )
        end
      end
    end

    describe '#networks_spec' do
      let(:input) { { networks_spec: { 'fake-key' => 'fake-value' } } }
      it 'returns the provided networks_spec' do
        expect(vm_config.networks_spec).to eq({ 'fake-key' => 'fake-value' })
      end
    end

    describe '#generate_human_readable_name' do
      context 'when names are short enough' do
        let(:instance_name) { 'i-name-length-16' }
        let(:deployment_name) { 'd-name-length-16' }
        it 'returns the generated name' do
          human_readable_name = vm_config.generate_human_readable_name(
              instance_name, deployment_name
          )
          expect(human_readable_name.length).to be < 80 # vCenter VM naming limit
          expect(human_readable_name).to start_with("#{instance_name}_#{deployment_name}_")
        end
      end


      context 'when deployment name is longer than expected' do
        let(:instance_name) { 'i-name-length-27-0123456789' } # name size 27
        let(:deployment_name) { 'd-name-length-57-0123456789-abcdefg-hijklmn-opqrst-uvwxyz' } # name size 57
        it 'returned the generated name' do
          expected_prefix = "#{instance_name}_#{deployment_name[0,38]}" # 65 - 27 = 38 , 65 is max_prefix in vm_config
          human_readable_name = vm_config.generate_human_readable_name(
              instance_name, deployment_name
          )
          expect(human_readable_name.length).to be < 80
          expect(human_readable_name).to start_with("#{expected_prefix}_")
        end
      end

      context 'when instance group name is longer than expected' do
        let(:instance_name) { 'i-name-length-57-0123456789-abcdefg-hijklmn-opqrst-uvwxyz' } # name size 57
        let(:deployment_name) { 'd-name-length-20-012' } # name size 20
        it 'returned the generated name' do
          expected_prefix = "#{instance_name[0,45].unicode_normalize}_#{deployment_name.unicode_normalize}" # 65 - 20 = 45
          human_readable_name = vm_config.generate_human_readable_name(
              instance_name, deployment_name
          )
          expect(human_readable_name.length).to be < 80
          expect(human_readable_name).to start_with("#{expected_prefix}_")
        end
      end


      context 'when both names are longer than expected' do
        let(:instance_name) { 'i-name-length-57-0123456789-abcdefg-hijklmn-opqrst-uvwxyz' } # name size 57
        let(:deployment_name) { 'd-name-length-57-0123456789-abcdefg-hijklmn-opqrst-uvwxyz' } # name size  57
        it 'returned the generated name' do
          expected_prefix = "#{instance_name[0,40]}_#{deployment_name[0,25]}" # 25 , 40 ideal length defined
          human_readable_name = vm_config.generate_human_readable_name(
              instance_name, deployment_name
          )
          expect(human_readable_name.length).to be < 80
          expect(human_readable_name).to start_with("#{expected_prefix}_")
        end
      end
    end

    describe '#ephemeral_disk_size' do
      let(:cloud_properties) { { 'disk' => 1234 } }
      let(:input) { { vm_type: vm_type } }
      it 'returns the provided disk size' do
        expect(vm_config.ephemeral_disk_size).to eq(1234)
      end
    end

    describe '#cluster_placements' do
      let(:datastore_mob) { instance_double('VimSdk::Vim::Datastore') }
      let(:cluster_provider) { instance_double(VSphereCloud::Resources::ClusterProvider) }
      let(:cluster_config) { instance_double(VSphereCloud::ClusterConfig, name: 'fake-cluster-name') }
      let(:cluster_config_2) { instance_double(VSphereCloud::ClusterConfig, name: 'fake-cluster-name-2') }
      let(:small_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob: datastore_mob, maintenance_mode?: false) }
      let(:large_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 2048, mob: datastore_mob, maintenance_mode?: false) }
      let(:huge_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 10240, mob: datastore_mob, maintenance_mode?: false) }
      let(:fake_cluster) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'fake-cluster-name',
          free_memory: VSphereCloud::Resources::Cluster::FreeMemory.new(2048),
          accessible_datastores: {
            'small-ds' => small_ds,
            'large-ds' => large_ds
          },
        )
      end
      let(:fake_cluster_2) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'fake-cluster-name-2',
          free_memory: VSphereCloud::Resources::Cluster::FreeMemory.new(4096),
          accessible_datastores: {
              'small-ds' => small_ds,
              'huge-ds' => huge_ds
          }
        )
      end
      let(:global_clusters) { [fake_cluster] }

      context 'when multiple clusters are specified within vm_type' do
        let(:datacenter_name) { 'fake-dc' }
        let(:cloud_properties) {
          {
            'datacenters' => [
              {
                'name' => datacenter_name,
                'clusters' => [
                  { 'fake-cluster-name' => {} },
                  { 'fake-cluster-name-2' => {} }
                ]
              }
            ],
            'ram' => ram,
          }
        }
        let(:input) do
          {
            vm_type: vm_type,
            global_clusters: global_clusters,
          }
        end
        let(:ram) { 512 }

        it 'returns the vm_type cluster' do
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name', {}).and_return(cluster_config)
          expect(VSphereCloud::ClusterConfig).to receive(:new).with('fake-cluster-name-2', {}).and_return(cluster_config_2)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name', cluster_config, datacenter_name).and_return(fake_cluster)
          expect(cluster_provider).to receive(:find).with('fake-cluster-name-2', cluster_config_2, datacenter_name).and_return(fake_cluster_2)
          cluster_placement = vm_config.cluster_placements
          expect(cluster_placement.take(10).size).to eql(2)
        end
      end

      context 'when datacenters and clusters are not specified in vm_type' do
        before do
          allow(larger_datastore_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          allow(smaller_datastore_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
        end
        let(:cloud_properties) {
          {
            'ram' => 512,
            'disk' => 4096,
          }
        }
        let(:input) do
          {
            vm_type: vm_type,
            disk_configurations: disk_configurations,
            global_clusters: global_clusters,
          }
        end
        let(:global_clusters) { [cluster_1, cluster_2] }
        let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
        let(:host_mount_info) { instance_double(VimSdk::Vim::Host::MountInfo, accessible: true) }
        let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
        let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system, mount_info: host_mount_info)]}
        let(:smaller_datastore_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:larger_datastore_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:smaller_ds) { fake_datastore( 'smaller-ds', 512, smaller_datastore_mob) }
        let(:larger_ds) { fake_datastore('larger-ds', 4096, larger_datastore_mob) }
        let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
        let(:cluster2_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
        let(:cluster_1) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-1',
            free_memory: VSphereCloud::Resources::Cluster::FreeMemory.new(1024),
            accessible_datastores: {
              'smaller-ds'=> smaller_ds,
            },
            mob: cluster1_mob,
            host: [host_system],
          )
        end
        let(:cluster_2) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-2',
            free_memory: VSphereCloud::Resources::Cluster::FreeMemory.new(1024),
            accessible_datastores: {
              'larger-ds' => larger_ds,
            },
            mob: cluster2_mob,
            host: [host_system]
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
          cluster_placement = vm_config.cluster_placements.take(10)
          expect(cluster_placement.size).to eql(1)
          expect(cluster_placement.first.cluster).to eq(cluster_2)
        end

        context 'when cluster picking information is not provided' do
          let(:input) { {} }

          it 'raises an error' do
            expect {
              expect(vm_config.cluster_placements)
            }.to raise_error(Bosh::Clouds::CloudError, 'No valid clusters were provided')
          end
        end
      end
    end

    describe '#drs_rule' do
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

      context 'when drs_rules are specified under cluster' do
        let(:ram) { 512 }
        let(:cloud_properties) {
          {
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
        let(:input) { { vm_type: vm_type } }

        it 'returns the provided drs_rule' do
          expect(vm_config.drs_rule(fake_cluster)).to eq({ 'name' => 'fake-rule', 'type' => 'fake-type' })
        end
      end

      context 'when drs_rules are not provided' do
        let(:cloud_properties) {
          {
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
        let(:input) { { vm_type: vm_type } }

        it 'returns nil' do
          expect(vm_config.drs_rule(fake_cluster)).to be_nil
        end
      end

      context 'when drs_rules are not provided' do
        let(:cloud_properties) {
          {
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
        let(:input) { { vm_type: vm_type } }

        it 'returns nil' do
          expect(vm_config.drs_rule(fake_cluster)).to be_nil
        end
      end
    end

    describe '#config_spec_params' do
      context 'when number of CPUs is provided' do
        let(:cloud_properties){ { 'cpu' => 2 } }
        let(:input) { { vm_type: vm_type } }
        let(:output) { { num_cpus: 2 } }

        it 'maps to num_cpus' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory in MB is provided' do
        let(:cloud_properties){ { 'ram' => 4096 } }
        let(:input) { { vm_type: vm_type } }
        let(:output) { { memory_mb: 4096 } }

        it 'maps to memory_mb' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is true' do
        let(:cloud_properties) { { 'nested_hardware_virtualization' => true } }
        let(:input) { { vm_type: vm_type } }

        let(:output) { { nested_hv_enabled: true } }

        it 'maps to num_cpus' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when nested_hardware_virtualization is false' do
        let(:cloud_properties) { { 'nested_hardware_virtualization' => false } }
        let(:input) { { vm_type: vm_type } }
        let(:output) { {} }

        it 'does not set any value in the config spec params' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when cpu_hot_add_enabled is true' do
        let(:cloud_properties) { { 'cpu_hot_add_enabled' => true } }
        let(:input) { { vm_type: vm_type } }
        let(:output) { { cpu_hot_add_enabled: true } }

        it 'sets it to true' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

      context 'when memory_hot_add_enabled is true' do
        let(:cloud_properties) { { 'memory_hot_add_enabled' => true } }
        let(:input) { { vm_type: vm_type } }
        let(:output) { { memory_hot_add_enabled: true }  }

        it 'sets it to true' do
          expect(vm_config.config_spec_params).to eq(output)
        end
      end

    end

    describe '#validate_drs_rules' do
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
            vm_config.validate_drs_rules(fake_cluster)
          }.to_not raise_error
        end
      end

      context 'when a cluster is specified but no DRS rules are specified' do
        let(:cloud_properties) {
          {
            'datacenters' => [
              'clusters' => [
                {
                  'fake-cluster-name' => {}
                }
              ]
            ]
          }
        }
        let(:input) { { vm_type: vm_type } }

        it 'validation passes' do
          expect{
            vm_config.validate_drs_rules(fake_cluster)
          }.to_not raise_error
        end
      end

      context 'when several DRS rules are specified in cloud properties' do
        let(:cloud_properties) {
          {
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
        let(:input) { { vm_type: vm_type } }

        let(:drs_rule_type) { 'separate_vms' }

        it 'raises an error' do
          expect{
            vm_config.validate_drs_rules(fake_cluster)
          }.to raise_error /vSphere CPI supports only one DRS rule per resource pool/
        end
      end

      context 'when one DRS rule is specified' do
        let(:cloud_properties) {
          {
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
        let(:input) { { vm_type: vm_type } }

        context 'when DRS rule type is separate_vms' do
          let(:drs_rule_type) { 'separate_vms' }

          it 'validation passes' do
            expect{
              vm_config.validate_drs_rules(fake_cluster)
            }.to_not raise_error
          end
        end

        context 'when DRS rule type is not separate_vms' do
          let(:drs_rule_type) { 'bad_type' }

          it 'raises an error' do
            expect{
              vm_config.validate_drs_rules(fake_cluster)
            }.to raise_error /vSphere CPI only supports DRS rule of 'separate_vms' type/
          end
        end
      end
    end

    describe '#vmx_options' do
      context 'vmx_options are specified' do
        let(:cloud_properties){
          {
            'vmx_options' => {
              'sched.mem.maxmemctl' => '0'
            }
          }
        }
        let(:input) { { vm_type: vm_type } }

        it 'should return the vmx_options' do
          expect(vm_config.vmx_options).to eq({ 'sched.mem.maxmemctl' => '0' })
        end
      end

      context 'vmx_options are NOT specified' do
        let(:cloud_properties) { {} }
        let(:input) { { vm_type: vm_type } }

        it 'should return empty hash' do
          expect(vm_config.vmx_options).to eq({})
        end
      end

    end
  end
end
