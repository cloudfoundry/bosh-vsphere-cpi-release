module VSphereCloud
  module NSXTApiClientBuilder
    def self.build_api_client(config, logger)
      configuration = NSXT::Configuration.new
      configuration.host = config.host
      configuration.username = config.username
      configuration.password = config.password
      if config.remote_auth != nil
        configuration.remote_auth = config.remote_auth
      end
      configuration.logger = logger
      configuration.client_side_validation = false
      if ENV['BOSH_NSXT_CA_CERT_FILE']
        configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
      end
      if ENV['NSXT_SKIP_SSL_VERIFY']
        configuration.verify_ssl = false
        configuration.verify_ssl_host = false
      end
      NSXT::ApiClient.new(configuration)
    end
  end
end