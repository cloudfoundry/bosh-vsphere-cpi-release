require "spec_helper"

module VSphereCloud
  describe DiskConfigs do
    let(:disk_configs) { DiskConfigs.new(datacenter: datacenter, vm_type: vm_type, disk_pool: disk_pool) }
    let(:datacenter) { instance_double(Resources::Datacenter) }
    let(:vm_type) { {} }
    let(:disk_pool) { {} }

    before do
      allow(datacenter).to receive(:persistent_pattern)
        .and_return('global-persistent-ds')
      allow(datacenter).to receive(:ephemeral_pattern)
        .and_return('global-ephemeral-ds')
    end

    describe '#disk_config_from_persistent_disk' do
      let(:existing_disk_cid) { 'fake-disk-cid' }
      let(:existing_disk) do
        instance_double(Resources::PersistentDisk,
          size_in_mb: 1024,
          cid: existing_disk_cid,
          datastore: datastore,
        )
      end
      let(:datastore) do
        instance_double(Resources::Datastore,
          name: 'fake-datastore',
        )
      end

      before do
        allow(datacenter).to receive(:find_disk)
          .with(existing_disk_cid)
          .and_return(existing_disk)
      end

      it 'returns a hash representing the persistent disk' do
        disk_config = disk_configs.disk_config_from_persistent_disk(existing_disk_cid)
        expect(disk_config).to include({
          cid: existing_disk.cid,
          size: existing_disk.size_in_mb,
          existing_datastore_name: datastore.name,
        })
      end

      context 'when datastore pattern is encoded disk CID' do
        let(:encoded_disk_cid) do
          metadata = { target_datastore_pattern: 'encoded-ds' }
          DiskMetadata.encode(existing_disk_cid, metadata)
        end

        it 'includes the encoded pattern' do
          disk_config = disk_configs.disk_config_from_persistent_disk(encoded_disk_cid)
          expect(disk_config).to include({
            target_datastore_pattern: 'encoded-ds',
          })
        end
      end

      context 'when datastore pattern is not encoded disk CID' do
        it 'includes the global pattern' do
          disk_config = disk_configs.disk_config_from_persistent_disk(existing_disk_cid)
          expect(disk_config).to include({
            target_datastore_pattern: datacenter.persistent_pattern,
          })
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
          {
            cid: existing_disk_cid,
            size: 1024,
            target_datastore_pattern: '^(ds\\-1|ds\\-2)$',
          }
        end

        it 'encodes the specified datastores as a pattern in the cid' do
          expected_metadata = {
            target_datastore_pattern: existing_disk_config[:target_datastore_pattern],
          }
          expected_cid = DiskMetadata.encode(existing_disk_cid, expected_metadata)

          director_cid = disk_configs.director_disk_cid(existing_disk_config)
          expect(director_cid).to eq(expected_cid)
        end
      end

      context 'when disk pool does not specify persistent datastores' do
        let(:disk_pool) { {} }
        let(:existing_disk_config) do
          {
            cid: existing_disk_cid,
            size: 1024,
            target_datastore_pattern: 'global-persistent-ds',
          }
        end

        it 'returns the original disk cid' do
          director_cid = disk_configs.director_disk_cid(existing_disk_config)
          expect(director_cid).to eq(existing_disk_cid)
        end
      end
    end

    describe '#new_ephemeral_disk_config' do
      context 'when datastores are specified under vm_type' do
        let(:vm_type) do
          {
            'disk' => 1024,
            'datastores' => ['ds-1', 'ds-2'],
          }
        end

        it 'includes a pattern constructed from vm_type' do
          disk_config = disk_configs.new_ephemeral_disk_config
          expect(disk_config).to include({
            size: 1024,
            ephemeral: true,
            target_datastore_pattern: '^(ds\-1|ds\-2)$',
          })
        end
      end

      context 'when datastores are not specified under vm_type' do
        let(:vm_type) do
          {
            'disk' => 1024,
          }
        end

        it 'includes the global ephemeral pattern' do
          disk_config = disk_configs.new_ephemeral_disk_config
          expect(disk_config).to include({
            size: 1024,
            ephemeral: true,
            target_datastore_pattern: datacenter.ephemeral_pattern,
          })
        end
      end
    end

    describe '#new_persistent_disk_config' do
      context 'when datastores are specified under disk_pool' do
        let(:disk_pool) do
          {
            'datastores' => ['ds-1', 'ds-2'],
          }
        end

        it 'includes a pattern constructed from cloud_properties' do
          disk_config = disk_configs.new_persistent_disk_config(1024)
          expect(disk_config).to include({
            size: 1024,
            target_datastore_pattern: '^(ds\-1|ds\-2)$',
          })
        end
      end

      context 'when datastores are not specified under disk_pool' do
        let(:disk_pool) { {} }

        it 'includes the global persistent pattern' do
          disk_config = disk_configs.new_persistent_disk_config(1024)
          expect(disk_config).to include({
            size: 1024,
            target_datastore_pattern: datacenter.persistent_pattern,
          })
        end
      end
    end
  end
end
