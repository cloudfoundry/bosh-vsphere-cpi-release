require 'spec_helper'

module VSphereCloud
  describe DiskConfigFactory do
    let(:disk_config_factory) { DiskConfigFactory.new(datacenter: datacenter, vm_type: vm_type, disk_pool: disk_pool) }
    let(:datacenter) { instance_double(Resources::Datacenter, name: 'datacenter-1') }
    let(:vm_type) { {} }
    let(:disk_pool) { {} }
    let(:target_datastore_pattern) { 'global-persistent-ds' }
    let(:ephemeral_pattern) { 'global-ephemeral-ds' }
    let(:datastore_clusters) { [{ 'sp-1' => {} }, { 'sp-2' => {} }, { 'sp-3' => {} }] }

    let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
    let(:datastore2) {double('Datastore', name: 'sp-2-ds-1')}
    let(:datastore_cluster_mob1) { double('StoragePodMob', child_entity: [datastore1], __mo_id__: 'storage-pod-1')}
    let(:datastore_cluster_mob2) { double('StoragePodMob', child_entity: [datastore2], __mo_id__: 'storage-pod-2')}
    let(:sdrs_enabled_datastore_cluster1) { double('StoragePod', drs_enabled?: true, mob: datastore_cluster_mob1, free_space: 2048)}
    let(:sdrs_enabled_datastore_cluster2) { double('StoragePod', drs_enabled?: true, mob: datastore_cluster_mob2, free_space: 120000)}
    let(:sdrs_disabled_datastore_cluster) { double('StoragePod', drs_enabled?: false)}

    before do
      allow(datacenter).to receive(:persistent_pattern)
        .and_return(target_datastore_pattern)
      allow(datacenter).to receive(:ephemeral_pattern)
        .and_return(ephemeral_pattern)
    end

    describe '#disk_config_from_persistent_disk' do
      let(:existing_disk_cid) { VSphereCloud::DirectorDiskCID.new('fake-disk-cid') }
      let(:existing_disk) do
        instance_double(Resources::PersistentDisk,
                        size_in_mb: 1024,
                        cid: existing_disk_cid.value,
                        datastore: datastore,
        )
      end
      let(:datastore) do
        instance_double(Resources::Datastore,
                        name: 'fake-datastore',
        )
      end
      let(:disk_config) do
        instance_double(VSphereCloud::DiskConfig,
          cid: existing_disk_cid.value,
          size: 1024,
          target_datastore_pattern: target_datastore_pattern,
        )
      end

      before do
        allow(datacenter).to receive(:find_disk)
                                 .with(existing_disk_cid)
                                 .and_return(existing_disk)
      end

      context 'when datastore pattern is encoded into the disk CID' do
        let(:existing_disk_cid) { DirectorDiskCID.new(encoded_disk_cid) }
        let(:target_datastore_pattern) { 'encoded-ds' }
        let(:encoded_disk_cid) do
          metadata = { target_datastore_pattern: target_datastore_pattern }
          DirectorDiskCID.encode('fake-disk-cid', metadata)
        end

        it 'includes the encoded pattern' do
          expect(VSphereCloud::DiskConfig).to receive(:new).with(
            cid: existing_disk_cid.value,
            size: 1024,
            existing_datastore_name: datastore.name,
            target_datastore_pattern: target_datastore_pattern
          ).and_return(disk_config)

          returned_disk_config = disk_config_factory.disk_config_from_persistent_disk(existing_disk_cid)
          expect(returned_disk_config).to eq(disk_config)
        end
      end

      context 'when datastore pattern is not encoded into the disk CID' do
        it 'includes the global pattern' do
          expect(VSphereCloud::DiskConfig).to receive(:new).with(
            cid: existing_disk_cid.value,
            size: 1024,
            existing_datastore_name: datastore.name,
            target_datastore_pattern: target_datastore_pattern
          ).and_return(disk_config)

          returned_disk_config = disk_config_factory.disk_config_from_persistent_disk(existing_disk_cid)
          expect(returned_disk_config).to eq(disk_config)
        end
      end
    end

    describe '#director_disk_cid' do
      let(:existing_disk_cid) { 'fake-disk-cid' }

      context 'when disk pool specifies persistent datastores' do
        let(:disk_pool) do
          {
              'datastores' => ['ds-1', 'ds-2'],
          }
        end
        let(:existing_disk_config) do
          instance_double(VSphereCloud::DiskConfig,
            size: 1024,
            cid: existing_disk_cid,
            target_datastore_pattern: '^(ds\\-1|ds\\-2)$',
          )
        end

        it 'encodes the specified datastores as a pattern in the cid' do
          expected_metadata = {
              target_datastore_pattern: existing_disk_config.target_datastore_pattern,
          }
          expected_cid = DirectorDiskCID.encode(existing_disk_cid, expected_metadata)

          director_cid = disk_config_factory.director_disk_cid(existing_disk_config)
          expect(director_cid).to eq(expected_cid)
        end
      end

      context 'when disk pool does not specify persistent datastores' do
        let(:disk_pool) { {} }
        let(:existing_disk_config) do
          instance_double(VSphereCloud::DiskConfig,
            size: 1024,
            cid: existing_disk_cid,
            target_datastore_pattern: 'global-persistent-ds',
          )
        end

        it 'returns the original disk cid' do
          director_cid = disk_config_factory.director_disk_cid(existing_disk_config)
          expect(director_cid).to eq(existing_disk_cid)
        end
      end
    end

    describe '#new_ephemeral_disk_config' do
      context 'when datastore clusters are specified under vm_type' do
        before do
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-1',anything,anything).and_return(sdrs_enabled_datastore_cluster1)
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-2',anything,anything).and_return(sdrs_enabled_datastore_cluster2)
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-3',anything,anything).and_return(sdrs_disabled_datastore_cluster)
        end

        context 'along with datastores' do
          let(:vm_type) do
            {
              'disk' => 1024,
              'datastores' => ['ds-1', 'ds-2', 'clusters' => datastore_clusters],
            }
          end
          let(:disk_config) do
            instance_double(VSphereCloud::DiskConfig,
                            size: 1024,
                            ephemeral?: true,
                            target_datastore_pattern: '^(ds\-1|ds\-2|sp\-1\-ds\-1|sp\-2\-ds\-1)$',
            )
          end

          it 'includes a pattern constructed from vm_type along with datastores from sdrs enabled datastore clusters' do
            expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, ephemeral: true, target_datastore_pattern: '^(ds\-1|ds\-2|sp\-1\-ds\-1|sp\-2\-ds\-1)$',
            ).and_return(disk_config)

            returned_disk_config = disk_config_factory.new_ephemeral_disk_config
            expect(returned_disk_config).to eq(disk_config)
          end
        end
        context 'and no datastores are specified' do
          let(:vm_type) do
            {
              'disk' => 1024,
              'datastores' => ['clusters' => datastore_clusters],
            }
          end
          let(:disk_config) do
            instance_double(VSphereCloud::DiskConfig,
                            size: 1024,
                            ephemeral?: true,
                            target_datastore_pattern: '^(sp\-1\-ds\-1|sp\-2\-ds\-1)$',
            )
          end

          it 'includes the datastores from sdrs enabled datastore clusters' do
            expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, ephemeral: true, target_datastore_pattern: '^(sp\-1\-ds\-1|sp\-2\-ds\-1)$',
            ).and_return(disk_config)

            returned_disk_config = disk_config_factory.new_ephemeral_disk_config
            expect(returned_disk_config).to eq(disk_config)
          end
        end
      end
      context 'when datastores are not specified under vm_type' do
        let(:vm_type) do
          {
            'disk' => 1024,
          }
        end
        let(:disk_config) do
          instance_double(VSphereCloud::DiskConfig,
            size: 1024,
            ephemeral?: true,
            target_datastore_pattern: datacenter.ephemeral_pattern,
          )
        end

        it 'includes the global ephemeral pattern' do
          expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, ephemeral: true, target_datastore_pattern: datacenter.ephemeral_pattern,
          ).and_return(disk_config)

          returned_disk_config = disk_config_factory.new_ephemeral_disk_config
          expect(returned_disk_config).to eq(disk_config)
        end
      end
    end

    describe '#new_persistent_disk_config' do
      context 'when datastore clusters are specified under disk_pool' do
       before do
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-1',anything,anything).and_return(sdrs_enabled_datastore_cluster1)
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-2',anything,anything).and_return(sdrs_enabled_datastore_cluster2)
          expect(VSphereCloud::Resources::StoragePod).to receive(:find).with('sp-3',anything,anything).and_return(sdrs_disabled_datastore_cluster)
        end
        context 'along with datastores' do
          let(:disk_pool) do
            {
              'datastores' => ['ds-1', 'ds-2', 'clusters' => datastore_clusters],
            }
          end
          let(:disk_config) do
            instance_double(VSphereCloud::DiskConfig,
                            size: 1024,
                            target_datastore_pattern: '^(ds\-1|ds\-2|sp\-2\-ds\-1)$',
            )
          end

          it 'includes a pattern constructed from cloud_properties along with datastores from best sdrs enabled datastore cluster' do
            expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, target_datastore_pattern: '^(ds\-1|ds\-2|sp\-2\-ds\-1)$',
            ).and_return(disk_config)

            returned_disk_config = disk_config_factory.new_persistent_disk_config(1024)
            expect(returned_disk_config).to eq(disk_config)
          end
        end
        context 'and no datastores are specified' do
          let(:disk_pool) do
            {
              'datastores' => ['clusters' => datastore_clusters],
            }
          end
          let(:disk_config) do
            instance_double(VSphereCloud::DiskConfig,
                            size: 1024,
                            target_datastore_pattern: '^(sp\-1\-ds\-1)$',
            )
          end

          it 'includes the datastores from the best sdrs enabled datastore cluster' do
            expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, target_datastore_pattern: '^(sp\-2\-ds\-1)$',
            ).and_return(disk_config)

            returned_disk_config = disk_config_factory.new_persistent_disk_config(1024)
            expect(returned_disk_config).to eq(disk_config)
          end
        end
      end
      context 'when datastores are not specified under disk_pool' do
        let(:disk_pool) { {} }
        let(:disk_config) do
          instance_double(VSphereCloud::DiskConfig,
            size: 1024,
            target_datastore_pattern: datacenter.persistent_pattern,
          )
        end

        it 'includes the global persistent pattern' do
          expect(VSphereCloud::DiskConfig).to receive(:new).with(
              size: 1024, target_datastore_pattern: datacenter.persistent_pattern,
          ).and_return(disk_config)

          returned_disk_config = disk_config_factory.new_persistent_disk_config(1024)
          expect(returned_disk_config).to eq(disk_config)
        end
      end
    end
  end
end
