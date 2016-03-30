require 'httpclient'

module VSphereCloud
  module CpiHttpClient
    class << self
      def build
        client = ::HTTPClient.new
        client.send_timeout = 14400 # 4 hours, for stemcell uploads
        client.receive_timeout = 14400
        client.connect_timeout = 30

        if ENV.has_key?('BOSH_CA_CERT_FILE')
          client.ssl_config.add_trust_ca(ENV['BOSH_CA_CERT_FILE'])
        else
          client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        client
      end
    end
  end
end
