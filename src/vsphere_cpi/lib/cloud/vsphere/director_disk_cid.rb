require 'json'
require 'base64'

module VSphereCloud
  class DirectorDiskCID

    attr_reader :value, :raw

    def initialize(raw_director_cid)
      @raw = raw_director_cid
      disk_cid, metadata = decode(raw_director_cid)
      @value = disk_cid
      @metadata = metadata
    end

    def target_datastore_pattern
      @metadata[:target_datastore_pattern]
    end

    DISK_METADATA_SEPARATOR = '.'.freeze

    private

    def decode(raw_director_disk_id)
      disk_cid, encoded_metadata = raw_director_disk_id.split(DISK_METADATA_SEPARATOR)
      decoded_metadata = if encoded_metadata
        DirectorDiskCID.base64_to_hash(encoded_metadata)
      else
        {}
      end
      decoded_metadata = DirectorDiskCID.convert_keys_to_symbols(decoded_metadata)
      [disk_cid, decoded_metadata]
    end

    class << self
      def encode(disk_cid, metadata)
        return disk_cid unless metadata

        disk_cid + create_encoded_metadata_suffix(metadata)
      end

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
