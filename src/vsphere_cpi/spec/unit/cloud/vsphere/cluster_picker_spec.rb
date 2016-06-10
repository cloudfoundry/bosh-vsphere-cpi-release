require 'spec_helper'

module VSphereCloud
  describe ClusterPicker do
    describe '#best_cluster_placement' do
      context 'when one cluster fits' do
        let(:available_clusters) do
          {
            'cluster-1' => {
              memory: 2048,
              datastores: {
                'target-ds' => {
                  free_space: 512,
                }
              }
            }
          }
        end

        it 'returns the first placement option' do
          disks = [
            {
              size: 256,
              target_datastore_pattern: 'target-ds'
            },
            {
              size: 256,
              ephemeral: true,
              target_datastore_pattern: 'target-ds'
            },
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

      context 'when no cluster fits' do
        let(:available_clusters) do
          {
            'cluster-1' => {
              memory: 2048,
              datastores: {
                'not-matching-ds' => {
                  free_space: 1024,
                }
              }
            }
          }
        end

        context 'based upon available memory' do
          it 'raises a CloudError when mem_headroom is provided' do
            disks = [{
              size: 0,
              target_datastore_pattern: '.*',
            }]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 4096, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for requested memory/)
          end

          it 'raises a CloudError when mem_headroom is default' do
            disks = [{
              size: 0,
              target_datastore_pattern: '.*',
            }]

            picker = ClusterPicker.new
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 2048 - ClusterPicker::DEFAULT_MEMORY_HEADROOM + 1, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for requested memory/)
          end
        end

        context 'based upon available free space' do
          it 'raises a CloudError when disk_headroom is provided' do
            disks = [{
              size: 2048,
              target_datastore_pattern: '.*',
            }]

            picker = ClusterPicker.new(0, 0)
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 0, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for disks/)
          end

          it 'raises a CloudError when disk_headroom is default' do
            disks = [{
              size: 1024 - DatastorePicker::DEFAULT_DISK_HEADROOM + 1,
              target_datastore_pattern: '.*',
            }]

            picker = ClusterPicker.new
            picker.update(available_clusters)

            expect {
              picker.best_cluster_placement(req_memory: 0, disk_configurations: disks)
            }.to raise_error(Bosh::Clouds::CloudError, /No valid placement found for disks/)
          end
        end

        context 'based upon target datastore pattern' do
          it 'raises a CloudError' do
            disks = [{
              size: 0,
              target_datastore_pattern: 'target-ds'
            }]

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
          let(:available_clusters) do
            {
              'cluster-1' => {
                memory: 2048,
                datastores: {
                  'other-ds' => {
                    free_space: 512,
                  }
                }
              },
              'cluster-2' => {
                memory: 2048,
                datastores: {
                  'current-ds' => {
                    free_space: 512,
                  }
                }
              }
            }
          end

          it 'returns the cluster' do
            disks = [{
              size: 256,
              target_datastore_pattern: '.*',
              existing_datastore_name: 'current-ds',
            }]

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
          let(:available_clusters) do
            {
              'cluster-1' => {
                memory: 2048,
                datastores: {
                  'smaller-ds' => {
                    free_space: 512,
                  }
                }
              },
              'cluster-2' => {
                memory: 2048,
                datastores: {
                  'larger-ds' => {
                    free_space: 1024,
                  }
                }
              }
            }
          end

          it 'returns the cluster' do
            disks = [{
              size: 256,
              target_datastore_pattern: '.*',
            }]

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
          let(:available_clusters) do
            {
              'cluster-1' => {
                memory: 4096,
                datastores: {
                  'same-ds' => {
                    free_space: 1024,
                  }
                }
              },
              'cluster-2' => {
                memory: 2048,
                datastores: {
                  'same-ds' => {
                    free_space: 1024,
                  }
                }
              }
            }
          end

          it 'returns the cluster' do
            disks = [{
              size: 256,
              target_datastore_pattern: '.*',
            }]

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
