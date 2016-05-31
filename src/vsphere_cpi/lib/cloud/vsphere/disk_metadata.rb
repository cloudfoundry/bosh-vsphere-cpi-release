require 'json'
require 'base64'

module VSphereCloud
  class DiskMetadata
    DISK_METADATA_SEPARATOR = '.'

    class << self
      def decode(director_disk_id)
        disk_cid, encoded_metadata = director_disk_id.split(DISK_METADATA_SEPARATOR)
        decoded_metadata = if encoded_metadata
          base64_to_hash(encoded_metadata)
        else
          {}
        end
        decoded_metadata = convert_keys_to_symbols(decoded_metadata)
        [disk_cid, decoded_metadata]
      end

      def encode(disk_cid, metadata)
        return disk_cid unless metadata

        disk_cid + create_encoded_metadata_suffix(metadata)
      end

      private

      def create_encoded_metadata_suffix(metadata)
        DISK_METADATA_SEPARATOR + hash_to_base64(metadata)
      end

      def hash_to_base64(hash)
        Base64.urlsafe_encode64(hash.to_json)
      end

      def base64_to_hash(encoded_hash)
        JSON.parse(Base64.urlsafe_decode64(encoded_hash))
      end

      def convert_keys_to_symbols(obj)
        if obj.is_a? Hash
          return obj.inject({}) { |memo,(k,v)| memo[k.to_sym] = convert_keys_to_symbols(v); memo }
        end
        if obj.is_a? Array
          return obj.inject([]) { |memo,v| memo << convert_keys_to_symbols(v); memo }
        end
        return obj
      end
    end
  end
end
