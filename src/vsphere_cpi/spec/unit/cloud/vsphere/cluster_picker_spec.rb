require 'spec_helper'

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

        context 'when at least few hosts are not in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          it 'returns the first placement option' do
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

            placement_option = picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            expect(placement_option).to eq({
              'cluster-1' => {
                disks[0] => 'target-ds',
                disks[1] => 'target-ds',
              }
            })
          end
        end

        context 'when all hosts are in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: true) }
          it 'returns the no active host exception' do
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

            expect do
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks)
            end.to raise_error(/No valid placement found due to no active host/)
          end
        end

        context 'when all hosts are in maintenance mode but datastore can access hosts outside cluster which are in not in maintenance mode' do
          let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: true) }
          let(:active_host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
          let(:active_host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: active_host_runtime_info)}
          let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: active_host_system),
                                        instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
          it 'returns the no active host exception' do
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

            expect do
              picker.best_cluster_placement(req_memory: 1024, disk_configurations: disks).to
                raise_error(/No valid placement found due to no active host /)
            end

          end
        end

      end

      context 'when no cluster fits' do
        before do
          allow(not_matching_ds.mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
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
  end
end
