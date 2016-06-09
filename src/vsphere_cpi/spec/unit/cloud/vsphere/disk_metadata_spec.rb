require 'spec_helper'

module VSphereCloud
  describe DiskMetadata do
    describe '.decode' do

      context 'when given a cid with flat metadata' do
        it 'returns metadata and vsphere disk cid' do
          metadata = {target_datastore_pattern: '^(fake\\-cloud\\-prop\\-datastore\\-1|fake\\-cloud\\-prop\\-datastore\\-2)$'}
          expected_pattern = Base64.urlsafe_encode64(metadata.to_json)

          director_disk_cid = "disk-1234-5667-1242-1233.#{expected_pattern}"

          disk_cid, extracted_metadata = DiskMetadata.decode(director_disk_cid)

          expect(extracted_metadata).to eq(metadata)
          expect(disk_cid).to eq("disk-1234-5667-1242-1233")
        end
      end

      context 'when given a cid with nested metadata' do
        it 'returns metadata and vsphere disk cid' do
          metadata = {
            foo: [{
              bar: 'testing'
            }]
          }
          expected_pattern = Base64.urlsafe_encode64(metadata.to_json)

          director_disk_cid = "disk-1234-5667-1242-1233.#{expected_pattern}"

          disk_cid, extracted_metadata = DiskMetadata.decode(director_disk_cid)

          expect(extracted_metadata).to eq(metadata)
          expect(disk_cid).to eq("disk-1234-5667-1242-1233")
        end
      end

      context 'when metadata is not present' do
        it 'returns the vsphere disk cid and empty metadata hash' do
          director_disk_cid = "disk-1234-5667-1242-1233"

          disk_cid, metadata = DiskMetadata.decode(director_disk_cid)

          expect(metadata).to eq({})
          expect(disk_cid).to eq("disk-1234-5667-1242-1233")
        end
      end
    end

    describe '.encode' do
      context 'when metadata is given' do
        it 'returns a director disk id having the encoded metadata suffix' do
          metadata = {target_datastore_pattern: '^(fake\\-cloud\\-prop\\-datastore\\-1|fake\\-cloud\\-prop\\-datastore\\-2)$'}
          expected_encoded_metadata = Base64.urlsafe_encode64(metadata.to_json)
          disk_cid = 'disk-cid'

          director_disk_cid = DiskMetadata.encode(disk_cid, metadata)

          expect(director_disk_cid).to eq("disk-cid.#{expected_encoded_metadata}")
        end
      end
    end
  end
end
