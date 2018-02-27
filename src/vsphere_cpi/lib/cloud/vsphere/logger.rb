require 'logger'

module VSphereCloud
  module Logger
    def self.extended(base)
      base.__send__(:include, self)
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
