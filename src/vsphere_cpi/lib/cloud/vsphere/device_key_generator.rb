require 'singleton'

module VSphereCloud
  class DeviceKeyGenerator
    include Singleton

    def init(keys = nil)
      @memo = Set.new(keys)
      @seed = -1
    end

    def device_key
      @seed -=1 while @memo.add?(@seed).nil?
      @seed
    end
  end
end