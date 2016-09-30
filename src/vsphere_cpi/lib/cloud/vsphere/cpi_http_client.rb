module VSphereCloud
  class CpiHttpClient < BaseHttpClient

    def initialize(http_log = nil)
      super(http_log, ENV['BOSH_CA_CERT_FILE'])
    end
  end
end
