require 'logger'

module VSphereCloud
  module Logger
    def self.included(base)
      base.extend(self)
    end

    def self.logger
      @logger ||= ::Logger.new($stderr)
    end

    def self.logger=(logger)
      @logger = logger
    end

    def logger
      VSphereCloud::Logger.logger
    end
  end
end
