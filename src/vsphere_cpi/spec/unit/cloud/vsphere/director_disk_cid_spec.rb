require 'spec_helper'

module VSphereCloud
  describe DirectorDiskCID do
    describe '.decode' do

      context 'when given a raw director cid with flat metadata' do
        it 'returns metadata and vsphere disk cid' do
          target_datastore_pattern = '^(fake\\-cloud\\-prop\\-datastore\\-1|fake\\-cloud\\-prop\\-datastore\\-2)$'
          metadata = {
            target_datastore_pattern: target_datastore_pattern
          }
          expected_pattern = Base64.urlsafe_encode64(metadata.to_json)

          raw_director_disk_cid = "disk-1234-5667-1242-1233.#{expected_pattern}"

          director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)

          expect(director_disk_cid.target_datastore_pattern).to eq(target_datastore_pattern)
          expect(director_disk_cid.value).to eq('disk-1234-5667-1242-1233')

        end
      end

      context 'when metadata is not present' do
        it 'returns the vsphere disk cid and empty metadata hash' do
          raw_director_disk_cid = 'disk-1234-5667-1242-1233'

          director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)

          expect(director_disk_cid.target_datastore_pattern).to eq(nil)
          expect(director_disk_cid.value).to eq('disk-1234-5667-1242-1233')
        end
      end
    end

    describe '.encode' do
      context 'when metadata is given' do
        it 'returns a director disk cid having the encoded metadata suffix' do
          metadata = {target_datastore_pattern: '^(fake\\-cloud\\-prop\\-datastore\\-1|fake\\-cloud\\-prop\\-datastore\\-2)$'}
          expected_encoded_metadata = Base64.urlsafe_encode64(metadata.to_json)
          disk_cid = 'disk-cid'

          director_disk_cid = DirectorDiskCID.encode(disk_cid, metadata)

          expect(director_disk_cid).to eq("disk-cid.#{expected_encoded_metadata}")
        end
      end
    end
  end
end
