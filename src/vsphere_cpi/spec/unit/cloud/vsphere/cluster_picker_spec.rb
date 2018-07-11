require 'spec_helper'

RSpec::Matchers.define :have_placement_with_gpus do |num_placements|
  match do |placements|
    num_placements == actual.inject(0) do |acc, placement|
      acc += placement.last[:host_array].size
      acc
    end
  end
end

module VSphereCloud
  describe ClusterPicker do
    def fake_datastore(name, free_space, mob = nil)
      VSphereCloud::Resources::Datastore.new(
        name, mob, true, free_space, free_space
      )
    end

    describe '#best_cluster_placement' do
      context 'when one cluster fits' do
        before do
          allow(target_ds.mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
        end
        let(:available_clusters) { [cluster_1] }
        let(:target_ds) do
          fake_datastore(
            'target-ds',
            512,
            instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount),
          )
        end
        let(:cluster_1) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-1',
            free_memory: 2048,
            accessible_datastores: {
              'target-ds' => target_ds,
            },
            mob: cluster1_mob
          )
        end
        let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
        let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
        let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
        let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
        let(:disks) {
          [
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              target_datastore_pattern: 'target-ds',
              existing_datastore_name: nil
            ),
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              ephemeral?: true,
              target_datastore_pattern: 'target-ds',
              existing_datastore_name: nil
            ),
          ]
        }

        describe 'Test calling placements_with_gpu_attached_hosts' do
          context 'when gpu_config is nil' do
            it 'does not call placements_with_gpu_attached_hosts' do
              picker = ClusterPicker.new(0, 0)
              picker.update(available_clusters)
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
              expect(picker).not_to receive(:placements_with_gpu_attached_hosts)
            end
          end

          context 'when gpu_config has no key with the name number_of_gpus' do
            let(:gpu_config) do
              {'type' => 'vgpu'}
            end
            it 'does not call placements_with_gpu_attached_hosts' do
              picker = ClusterPicker.new(0, 0)
              picker.update(available_clusters)
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks, gpu_config: gpu_config)
              expect(picker).not_to receive(:placements_with_gpu_attached_hosts)
            end
          end

          context 'when gpu_config has 0 gpus' do
            let(:gpu_config) do
              {'number_of_gpus' => 0}
            end
            it 'does not call placements_with_gpu_attached_hosts' do
              picker = ClusterPicker.new(0, 0)
              picker.update(available_clusters)
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks, gpu_config: gpu_config)
              expect(picker).not_to receive(:placements_with_gpu_attached_hosts)
            end
          end

          context 'when gpu_config has 1 gpu' do
            let(:gpu_config) do
              {'number_of_gpus' => 1}
            end
            before do
              allow_any_instance_of(ClusterPicker).to receive(:placements_with_gpu_attached_hosts).with(any_args).and_return([])
            end
            it 'does not call placements_with_gpu_attached_hosts' do
              picker = ClusterPicker.new(0, 0)
              picker.update(available_clusters)
              expect do
                picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks, gpu_config: gpu_config)
              end.to raise_error(/No valid placement found due to no active host/)
            end
          end
        end

        context 'when at least few hosts are not in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:disks) {
            [
              instance_double(VSphereCloud::DiskConfig,
                              size: 256,
                              target_datastore_pattern: 'target-ds',
                              existing_datastore_name: nil
              ),
              instance_double(VSphereCloud::DiskConfig,
                              size: 256,
                              ephemeral?: true,
                              target_datastore_pattern: 'target-ds',
                              existing_datastore_name: nil
              ),
            ]
          }
          it 'returns the first placement option' do
            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            placement_option = picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            expect(placement_option).to eq({
              'cluster-1' => {
                disks[0] => 'target-ds',
                disks[1] => 'target-ds',
              }
            })
          end
          context 'when all datastores are not accessible' do
            it 'raises an error' do
              expect(target_ds).to receive(:accessible_from?).with(cluster_1).and_return(false)
              picker = ClusterPicker.new(0, 0)
              picker.update(available_clusters)

              expect {
                picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
              }.to raise_error(/No valid placement found/)
            end
          end
        end

        context 'when all hosts are in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: true) }
          it 'raises the error' do
            disks = [
                instance_double(VSphereCloud::DiskConfig,
                                size: 256,
                                target_datastore_pattern: 'target-ds',
                                existing_datastore_name: nil
                ),
                instance_double(VSphereCloud::DiskConfig,
                                size: 256,
                                ephemeral?: true,
                                target_datastore_pattern: 'target-ds',
                                existing_datastore_name: nil
                ),
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            }.to raise_error(/No valid placement found/)
          end
        end

        context 'when all hosts are in maintenance mode but datastore can access hosts outside cluster which are in not in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: true) }
          let(:active_host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:active_host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: active_host_runtime_info)}
          let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: active_host_system),
                                        instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
          it 'raises the error' do
            disks = [
                instance_double(VSphereCloud::DiskConfig,
                                size: 256,
                                target_datastore_pattern: 'target-ds',
                                existing_datastore_name: nil
                ),
                instance_double(VSphereCloud::DiskConfig,
                                size: 256,
                                ephemeral?: true,
                                target_datastore_pattern: 'target-ds',
                                existing_datastore_name: nil
                ),
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            }.to raise_error(/No valid placement found for disks/)
          end
        end

      end

      context 'when no cluster fits' do
        before do
          allow(not_matching_ds.mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          allow(not_matching_ds).to receive(:accessible_from?).with(any_args).and_return(true)
        end
        let(:available_clusters) { [cluster_1] }
        let(:cluster_1) do
          instance_double(VSphereCloud::Resources::Cluster,
            name: 'cluster-1',
            free_memory: 2048,
            accessible_datastores: {
              'not-matching-ds' => not_matching_ds,
            }
          )
        end
        let(:not_matching_ds) {
          fake_datastore('fake-target-ds',
            1024,
            instance_double('VimSdk::Vim::Datastore'))
        }

        context 'based upon available memory' do
          it 'raises a CloudError when mem_headroom is provided' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 0,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 4096, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for requested memory/)
          end

          it 'raises a CloudError when mem_headroom is default' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 0,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 2048 - ClusterPicker::DEFAULT_MEMORY_HEADROOM + 1, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for requested memory/)
          end
        end

        context 'based upon available free space' do
          it 'raises a CloudError when disk_headroom is provided' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 2048,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 0, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for disks/)
          end

          it 'raises a CloudError when disk_headroom is default' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 1024 - DatastorePicker::DEFAULT_DISK_HEADROOM + 1,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 0, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for disks/)
          end
        end

        context 'based upon target datastore pattern' do
          it 'raises a CloudError' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 0,
                target_datastore_pattern: 'target-ds',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 0, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for disks/)
          end
        end
      end

      context 'when multiple clusters fit' do
        context 'when disk migration burden provides a decision' do
          before do
            allow(current_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
            allow(other_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          end
          let(:available_clusters) { [cluster_1, cluster_2] }
          let(:cluster_1) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-1',
              free_memory: 2048,
              accessible_datastores: {
                'other-ds' => other_ds,
              },
              mob: cluster1_mob
            )
          end
          let(:cluster_2) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-2',
              free_memory: 2048,
              accessible_datastores: {
                'current-ds' => current_ds,
              },
              mob: cluster2_mob
            )
          end
          let(:other_ds) { fake_datastore('other-ds', 512, other_ds_mob) }
          let(:current_ds) { fake_datastore('current-ds', 512, current_ds_mob) }
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
          let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
          let(:current_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
          let(:other_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
          let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
          let(:cluster2_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }

          it 'returns the cluster' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 256,
                target_datastore_pattern: '.*',
                existing_datastore_name: 'current-ds',
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            placement_option = picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            expect(placement_option).to eq({
              'cluster-2' => {
                disks[0] => 'current-ds',
              }
            })
          end
        end

        context 'when max free space provides a decision' do
          before do
            allow(smaller_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
            allow(larger_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          end
          let(:available_clusters) { [cluster_1, cluster_2] }
          let(:cluster_1) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-1',
              free_memory: 2048,
              accessible_datastores: {
                'smaller-ds' => smaller_ds,
              },
              mob: cluster1_mob
            )
          end
          let(:cluster_2) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-2',
              free_memory: 2048,
              accessible_datastores: {
                'larger-ds' => larger_ds,
              },
              mob: cluster2_mob
            )
          end
          let(:smaller_ds) { fake_datastore('smaller-ds', 512, smaller_ds_mob) }
          let(:larger_ds) { fake_datastore('larger-ds', 1024, larger_ds_mob) }
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
          let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
          let(:larger_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
          let(:smaller_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
          let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
          let(:cluster2_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }

          it 'returns the cluster' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 256,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            placement_option = picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            expect(placement_option).to eq({
              'cluster-2' => {
                disks[0] => 'larger-ds',
              }
            })
          end
        end

        context 'when max free memory provides a decision' do
          before do
            allow(same_ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
          end
          let(:available_clusters) { [cluster_1, cluster_2] }
          let(:cluster_1) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-1',
              free_memory: 4096,
              accessible_datastores: {
                'same-ds' => same_ds,
              },
              mob: cluster1_mob

            )
          end
          let(:cluster_2) do
            instance_double(VSphereCloud::Resources::Cluster,
              name: 'cluster-2',
              free_memory: 2048,
              accessible_datastores: {
                'same-ds' => same_ds,
              },
              mob: cluster2_mob
            )
          end
          let(:same_ds) { fake_datastore('same-ds', 1024, same_ds_mob) }
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
          let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
          let(:same_ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
          let(:cluster1_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }
          let(:cluster2_mob) { instance_double(VimSdk::Vim::ClusterComputeResource, host: [host_system]) }

          it 'returns the cluster' do
            disks = [
              instance_double(VSphereCloud::DiskConfig,
                size: 256,
                target_datastore_pattern: '.*',
                existing_datastore_name: nil
              )
            ]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            placement_option = picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            expect(placement_option).to eq({
              'cluster-1' => {
                disks[0] => 'same-ds',
              }
            })
          end
        end
      end
    end

    describe '#placements_with_gpu_attached_hosts' do
      let(:gpu_config) do
        {'number_of_gpus' => 1}
      end
      let(:req_memory) do
        1024
      end
      let(:runtime) do
        instance_double('VimSdk::Vim::Host::RuntimeInfo', :in_maintenance_mode => false,
          :connection_state => 'connexted', :power_state => 'poweredOn')
      end
      let(:host_mob_1) {instance_double(VimSdk::Vim::HostSystem, runtime: runtime)}
      let(:host_1) do
        VSphereCloud::Resources::Host.new('host_1', host_mob_1, [1,2,3], [1,2,3], runtime)
      end
      let(:host_mob_2) {instance_double(VimSdk::Vim::HostSystem, runtime: runtime)}
      let(:host_2) do
        VSphereCloud::Resources::Host.new('host_2', host_mob_2, [1,2,3], [1,2,3], runtime)
      end
      let(:host_mob_3) {instance_double(VimSdk::Vim::HostSystem, runtime: runtime)}
      let(:host_3) do
        VSphereCloud::Resources::Host.new('host_3', host_mob_3, [1,2,3], [1,2,3], runtime)
      end
      let(:cluster_1) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'cluster-1',
          :active_hosts => {"host_1": host_1, "host_2": host_2})
      end
      let(:cluster_2) do
        instance_double(VSphereCloud::Resources::Cluster,
          name: 'cluster-2',
          :active_hosts => {"host_3": host_3})
      end

      context 'when one cluster is present' do
        let(:clusters) { [cluster_1] }

        context 'when filtered placements after datastore constraint satisfaction are empty' do
          let(:placements) {{}}
          it 'raises error' do
            picker = ClusterPicker.new(0,0)
            expect do
              picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
            end.to raise_error(/no active host found.*free gpus/)
          end
        end

        context 'when filtered placements after datastore constraint satisfaction contains the cluster' do
          let(:placements) do
            placements = {
              'cluster-1' => {}
            }
            placements
          end
          context 'when cluster has two hosts of which one has gpus' do
            before do
              allow(host_1).to receive(:available_gpus).and_return(['1'])
              allow(host_1).to receive(:raw_available_memory).and_return(8192)
              allow(host_2).to receive(:available_gpus).and_return([])
            end
            it 'returns the placement list with one host satisfying gpu' do
              picker = ClusterPicker.new(0,0)
              expect(picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)).to have_placement_with_gpus(1)
            end
            context 'when host with the gpu does not have enough free memory' do
              let(:req_memory) { 16384 }
              it 'raises error' do
                picker = ClusterPicker.new(0,0)
                expect do
                  picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
                end.to raise_error(/no active host found.*free gpus/)
              end
            end
            context 'when host with the gpu does not have enough free gpus' do
              let(:gpu_config) do
                {'number_of_gpus' => 4}
              end
              it 'raises error' do
                picker = ClusterPicker.new(0,0)
                expect do
                  picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
                end.to raise_error(/no active host found.*free gpus/)
              end
            end
          end
          context 'when cluster has two hosts of which both have gpus' do
            before do
              allow(host_1).to receive(:available_gpus).and_return(['1','2'])
              allow(host_1).to receive(:raw_available_memory).and_return(8192)
              allow(host_2).to receive(:raw_available_memory).and_return(32192)
              allow(host_2).to receive(:available_gpus).and_return(['1', '2', '3'])
            end
            it 'returns the placement list with two host satisfying gpu' do
              picker = ClusterPicker.new(0,0)
              placement_found = picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
              expect(placement_found).to have_placement_with_gpus(2)
              # Check sorting of the list.
              expect(placement_found.first.last[:host_array].first.name).to eq('host_1')
            end
            context 'when one of the host with the gpu does not have enough free memory' do
              let(:req_memory) { 16384 }
              it 'returns the placement list with one host satisfying gpu' do
                picker = ClusterPicker.new(0,0)
                expect(picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)).to have_placement_with_gpus(1)
              end
            end
            context 'when no host with the gpu does not have enough free gpus' do
              let(:gpu_config) do
                {'number_of_gpus' => 4}
              end
              it 'raises error' do
                picker = ClusterPicker.new(0,0)
                expect do
                  picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
                end.to raise_error(/no active host found.*free gpus/)
              end
            end
          end
        end
      end

      context 'when two clusters are present' do
        let(:clusters) { [cluster_1, cluster_2] }

        context 'when filtered placements after datastore constraint satisfaction are empty' do
          let(:placements) {{}}
          it 'raises error' do
            picker = ClusterPicker.new(0,0)
            expect do
              picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
            end.to raise_error(/no active host found.*free gpus/)
          end
        end

        context 'when filtered placements after datastore constraint satisfaction contains only cluster 2' do
          let(:placements) do
            placements = {
              'cluster-2' => {}
            }
            placements
          end
          context 'when cluster-2 has no hosts with gpus' do
            before do
              allow(host_3).to receive(:available_gpus).and_return([])
            end
            it 'raises error' do
              picker = ClusterPicker.new(0,0)
              expect do
                picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
              end.to raise_error(/no active host found.*free gpus/)
            end
          end
          context 'when cluster-2 has a host with gpus' do
            before do
              allow(host_3).to receive(:available_gpus).and_return(['1'])
              allow(host_3).to receive(:raw_available_memory).and_return(8192)
            end
            it 'returns the placement list with one host satisfying gpu' do
              picker = ClusterPicker.new(0,0)
              expect(picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)).to have_placement_with_gpus(1)
            end
          end
        end

        context 'when filtered placements after datastore constraint satisfaction contains both the clusters' do
          let(:placements) do
            placements = {
              'cluster-2' => {},
              'cluster-1' => {}
            }
            placements
          end
          context 'when both clusters have no hosts with gpus' do
            before do
              allow(host_3).to receive(:available_gpus).and_return([])
              allow(host_1).to receive(:available_gpus).and_return([])
              allow(host_2).to receive(:available_gpus).and_return([])
            end
            it 'raises error' do
              picker = ClusterPicker.new(0,0)
              expect do
                picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)
              end.to raise_error(/no active host found.*free gpus/)
            end
          end
          context 'when both clusters have hosts with gpus' do
            before do
              allow(host_3).to receive(:available_gpus).and_return(['1'])
              allow(host_3).to receive(:raw_available_memory).and_return(8192)
              allow(host_1).to receive(:available_gpus).and_return(['1'])
              allow(host_1).to receive(:raw_available_memory).and_return(8192)
              allow(host_2).to receive(:available_gpus).and_return(['1'])
              allow(host_2).to receive(:raw_available_memory).and_return(8192)
            end
            it 'returns the placement list with one host satisfying gpu' do
              picker = ClusterPicker.new(0,0)
              expect(picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)).to have_placement_with_gpus(3)
            end
          end
          context 'when both clusters have hosts with gpus but cluster-1 hosts don\'t have enough memory' do
            before do
              allow(host_3).to receive(:available_gpus).and_return(['1'])
              allow(host_3).to receive(:raw_available_memory).and_return(8192)
              allow(host_1).to receive(:available_gpus).and_return(['1'])
              allow(host_1).to receive(:raw_available_memory).and_return(192)
              allow(host_2).to receive(:available_gpus).and_return(['1'])
              allow(host_2).to receive(:raw_available_memory).and_return(192)
            end
            it 'returns the placement list with one host satisfying gpu' do
              picker = ClusterPicker.new(0,0)
              expect(picker.send(:placements_with_gpu_attached_hosts, placements, clusters, gpu_config, req_memory)).to have_placement_with_gpus(1)
            end
          end
        end
      end
    end
  end
end

