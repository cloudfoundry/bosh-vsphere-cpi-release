require 'httpclient'

module VSphereCloud
  class CpiHttpClient
    extend Forwardable

    def_delegators :@backing_client,
      :get,
      :put,
      :post

    attr_reader :backing_client

    def initialize(http_log = nil)
      @backing_client = HTTPClient.new
      @backing_client.send_timeout = 14400 # 4 hours, for stemcell uploads
      @backing_client.receive_timeout = 14400
      @backing_client.connect_timeout = 30

      if ENV.has_key?('BOSH_CA_CERT_FILE')
        @backing_client.ssl_config.add_trust_ca(ENV['BOSH_CA_CERT_FILE'])
      else
        @backing_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      case http_log
        when String
          log_file = File.open(http_log, 'w')
          log_file.sync = true
          @backing_client.debug_dev = log_file
        when IO, StringIO
          @backing_client.debug_dev = http_log
      end
    end
  end
end
