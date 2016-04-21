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

        context 'with datastores acting as both persistent and ephemeral datastores' do
          let(:ephemeral_pattern) { /datastore-.*/ }
          let(:persistent_pattern) { /datastore-.*/ }

          let(:available_clusters) do
            {
              "cluster-1" => {
                memory: 2048,
                datastores: {
                  "datastore-1" => 5120,
                }
              },
              "cluster-2" => {
                memory: 2048,
                datastores: {
                  "datastore-2" => 10240,
                }
              },
            }
          end
          let(:existing_disks) do
            {
              "persistent-ds-1" => {
                "disk-1" => 1024,
              }
            }
          end
          it 'returns the only cluster with suitable storage for both the ephemeral disk and persistent disk' do
            picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
            picker.update(available_clusters)
            expect(picker.suitable_clusters(2048, 5120, existing_disks)).to eq({
              "cluster-2" => available_clusters["cluster-2"],
            })
          end
        end
      end

    end

    describe '#pick_clusters' do
      let(:ephemeral_pattern) { /ephemeral-ds-.*/ }
      let(:persistent_pattern) { /persistent-ds-.*/ }

      context 'with scoring function picking most free space and memory' do
        context 'with clusters that have only ephemeral storage and no existing persistent disks' do
          let(:available_clusters) do
            {
              "cluster-1" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-1" => 1024,
                  "ephemeral-ds-2" => 1024,
                  "unused-ds-1" => 102400,
                }
              },
              "cluster-2" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-3" => 1024,
                  "ephemeral-ds-4" => 20480,
                }
              },
              "cluster-3" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-5" => 1024,
                }
              },
            }
          end

          it 'picks the one cluster that matches the provided requirements' do
            picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
            picker.update(available_clusters)
            existing_disks = {}

            expect(picker.pick_cluster(2048, 20480, existing_disks)).to eq("cluster-2")
          end

          it 'picks the one cluster that matches the provided requirements' do
            picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
            picker.update(available_clusters)
            existing_disks = {}

            expect(picker.pick_cluster(2048, 1024, existing_disks)).to eq("cluster-2")
          end

          context 'when clusters have the same disk space but different memory capacities' do
            let(:available_clusters) do
              {
                "cluster-1" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-1" => 1024,
                    "ephemeral-ds-2" => 1024,
                    "unused-ds-1" => 102400,
                  }
                },
                "cluster-2" => {
                  memory: 4096,
                  datastores: {
                    "ephemeral-ds-1" => 1024,
                    "ephemeral-ds-2" => 1024,
                  }
                },
                "cluster-3" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-1" => 1024,
                    "ephemeral-ds-2" => 1024,
                  }
                },
              }
            end
            it 'picks the cluster with the highest memory capacity' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)
              existing_disks = {}

              expect(picker.pick_cluster(2048, 1024, existing_disks)).to eq("cluster-2")
            end
          end

          context 'when there is no matching/available cluster' do
            it 'raises an error' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)
              existing_disks = {}
              expect {
                picker.pick_cluster(4096, 1024, existing_disks)
              }.to raise_error(Bosh::Clouds::CloudError)
            end
          end
        end

        context 'with clusters with persistent datastores and existing persistent disks' do
          let(:available_clusters) do
            {
              "cluster-1" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-1" => 20480,
                  "persistent-ds-1" => 20480,
                  "unused-ds-1" => 102400,
                }
              },
              "cluster-2" => {
                memory: 2048,
                datastores: {
                  "ephemeral-ds-2" => 2048,
                  "persistent-ds-2" => 10240,
                  "persistent-ds-3" => 9000,
                  "persistent-ds-4" => 9000,
                }
              },
            }
          end

          context 'with an existing disk in a datastore not attached to any provided clusters' do
            let(:existing_disks) do
              {
                "persistent-ds-a" => {
                  "disk-1" => 10240,
                },
              }
            end
            it 'picks the cluster with more space in suitable datastores for the ephemeral disk and the biggest suitable persistent datastore' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)

              expect(picker.pick_cluster(2048, 1024, existing_disks)).to eq("cluster-1")
            end
          end

          context 'with an existing disk in a datastore that is attached to any provided clusters' do
            let(:existing_disks) do
              {
                "persistent-ds-2" => {
                  "disk-1" => 10240,
                },
              }
            end
            it 'picks the cluster that does not require a disk migration' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)

              expect(picker.pick_cluster(2048, 1024, existing_disks)).to eq("cluster-2")
            end
          end

          context 'with an existing disks in datastores that is attached to a provided cluster' do
            let(:available_clusters) do
              {
                "cluster-1" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-1" => 2048,
                    "persistent-ds-1" => 10240,
                    "unused-ds-1" => 102400,
                  }
                },
                "cluster-2" => {
                  memory: 2048,
                  datastores: {
                    "ephemeral-ds-2" => 2048,
                    "persistent-ds-2" => 20480,
                  }
                },
              }
            end
            let(:existing_disks) do
              {
                "persistent-ds-1" => {
                  "disk-1" => 10240,
                },
                "persistent-ds-2" => {
                  "disk-2" => 5120,
                },
              }
            end
            it 'picks a suitable cluster that requires the smallest disk migration' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)

              expect(picker.pick_cluster(2048, 1024, existing_disks)).to eq("cluster-1")
            end
          end

          context 'when there is no cluster that has an persistent ds, which can accomodate the existing disk' do
            let(:existing_disks) do
              {
                "persistent-ds-from-an-old-cluster" => {
                  "disk-1" => 102400,
                },
              }
            end
            it 'raises an error' do
              picker = ClusterPicker.new(ephemeral_pattern, persistent_pattern, 0, 0)
              picker.update(available_clusters)
              expect {
                picker.pick_cluster(512, 1024, existing_disks)
              }.to raise_error(Bosh::Clouds::CloudError)
            end
          end

        end

      end
    end

  end
end
