module VSphereCloud
  module DeviceKeyGenerator
    def self.init(keys: nil)
      @memo = Set.new(keys)
      @seed = -1
    end

    def self.get_device_key
      until @memo.add?(@seed) != nil
        @seed -= 1
      end
      return @seed
    end
  end
end