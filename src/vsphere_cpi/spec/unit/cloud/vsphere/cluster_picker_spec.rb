require 'spec_helper'

module VSphereCloud
  describe ClusterPicker do
    describe '#suitable_clusters' do
      let(:ephemeral_pattern) { /ephemeral-ds-.*/ }
      let(:persistent_pattern) { /persistent-ds-.*/ }

      context 'with clusters that have only ephemeral storage and no existing persistent disks' do
        let(:available_clusters) do
          {
            "cluster-1" => {
              memory: 2048,
              datastores: {
                "ephemeral-ds-1" => 1024,
                "ephemeral-ds-2" => 20480,
              }
            },
            "cluster-2" => {
              memory: 1024,
              datastores: {
                "ephemeral-ds-1" => 1024,
                "ephemeral-ds-2" => 20480,
              }
            },
            "cluster-3" => {
              memory: 2048,
              datastores: {
                "ephemeral-ds-3" => 1024,
                "ephemeral-ds-4" => 1024,
              }
            },
          }
        end

        it 'returns only the cluster that can match the provided requirements' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
          picker.update(available_clusters)
          existing_disks = {}

          expect(picker.suitable_clusters(2048, 20480, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"]
          })
        end

        it 'returns all the clusters that can match the provided requirements' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
          picker.update(available_clusters)
          existing_disks = {}

          expect(picker.suitable_clusters(1024, 20480, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"],
            "cluster-2" => available_clusters["cluster-2"]
          })
        end

        it 'returns an empty hash if no cluster can match the provided requirements' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
          picker.update(available_clusters)
          existing_disks = {}

          expect(picker.suitable_clusters(2048, 20481, existing_disks)).to eq({})
        end

        it 'returns a cluster considering the disk headroom' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 1024)
          picker.update(available_clusters)
          existing_disks = {}

          expect(picker.suitable_clusters(2048, 20480, existing_disks)).to eq({})
          expect(picker.suitable_clusters(2048, 20480-1024, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"],
          })
        end

        it 'returns a cluster considering the memory headroom' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 128, 0)
          picker.update(available_clusters)
          existing_disks = {}

          expect(picker.suitable_clusters(2048, 20480, existing_disks)).to eq({})
          expect(picker.suitable_clusters(2048-128, 20480, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"],
          })
        end
      end

      context 'with clusters that have existing persistent disks' do
        let(:available_clusters) do
          {
            "cluster-1" => {
              memory: 2048,
              datastores: {
                "ephemeral-ds-1" => 1024,
                "persistent-ds-1" => 1024,
              }
            },
            "cluster-2" => {
              memory: 2048,
              datastores: {
                "ephemeral-ds-1" => 1024,
                "persistent-ds-1" => 1024,
              }
            },
            "cluster-3" => {
              memory: 2048,
              datastores: {
                "ephemeral-ds-3" => 1024,
                "persistent-ds-3" => 1024,
              }
            },
          }
        end

        it 'returns all the clusters as they all match the provided requirements' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
          picker.update(available_clusters)
          existing_disks = {
            "persistent-ds-1" => {
              "disk-1" => 1024
            }
          }

          expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"],
            "cluster-2" => available_clusters["cluster-2"],
            "cluster-3" => available_clusters["cluster-3"]
          })
        end

        it 'returns only the clusters that match the provided requirements' do
          picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
          picker.update(available_clusters)
          existing_disks = {
            "persistent-ds-1" => {
              "disk-1" => 10240
            }
          }

          expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
            "cluster-1" => available_clusters["cluster-1"],
            "cluster-2" => available_clusters["cluster-2"]
          })
        end

        context 'with two existing disks in the same datastore' do
          let(:existing_disks) do
            {
              "persistent-ds-1" => {
                "disk-1" => 1024,
                "disk-2" => 512
              }
            }
          end

          it 'returns only the clusters that match the provided requirements' do
            picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
            picker.update(available_clusters)
            expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
              "cluster-1" => available_clusters["cluster-1"],
              "cluster-2" => available_clusters["cluster-2"]
            })
          end

          context 'when it is possible to fan disks out across multiple persistent datastores in a cluster' do
            let(:available_clusters) do
              {
                "cluster-1" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-1" => 1024,
                    "persistent-ds-a" => 1024,
                    "persistent-ds-b" => 512,
                  }
                },
                "cluster-2" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-2" => 1024,
                    "persistent-ds-c" => 1024,
                  }
                },
              }
            end
            it 'returns the cluster with the multiple persistent datastores' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)
              expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
                "cluster-1" => available_clusters["cluster-1"],
              })
            end
          end
        end

        context 'with two existing disks in different datastores' do
          let(:available_clusters) do
            {
              "cluster-1" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-1" => 1024,
                  "persistent-ds-a" => 2048,
                }
              },
              "cluster-2" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-1" => 1024,
                  "persistent-ds-b" => 1024,
                }
              }
            }
          end

          context 'with existing disks in entirely separate datastores' do
            let(:existing_disks) do
              {
                "persistent-ds-1" => {
                  "disk-1" => 1024,
                },
                "persistent-ds-2" => {
                  "disk-2" => 1024,
                }
              }
            end

            it 'returns only the clusters that match the provided requirements' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)
              expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
                "cluster-1" => available_clusters["cluster-1"],
              })
            end
          end

          context 'with one existing disk in a datastore attached to a cluster' do
            context 'with a small disk in a datastore separate from the provided clusters' do
              let(:existing_disks) do
                {
                  "persistent-ds-a" => {
                    "disk-1" => 1024,
                  },
                  "persistent-ds-2" => {
                    "disk-2" => 2048,
                  }
                }
              end

              it 'returns the only cluster that can accomodate the disk from the separate datastore' do
                picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
                picker.update(available_clusters)
                expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({
                  "cluster-1" => available_clusters["cluster-1"],
                })
              end
            end
            context 'with a too-large disk in a datastore separate from the provided clusters' do
              let(:existing_disks) do
                {
                  "persistent-ds-a" => {
                    "disk-1" => 1024,
                  },
                  "persistent-ds-2" => {
                    "disk-2" => 4096,
                  }
                }
              end

              it 'returns no clusters' do
                picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
                picker.update(available_clusters)
                expect(picker.suitable_clusters(2048, 1024, existing_disks)).to eq({})
              end
            end
          end
        end
      end

    end
  end
end
