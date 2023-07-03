module VSphereCloud
  class NSXTPolicyApiClientBuilder
    def initialize(config, logger)
      @config = config
      @logger = logger
    end

    def get_client
      return @client unless @client.nil?

      configuration = NSXTPolicy::Configuration.new
      configuration.host = @config.host
      configuration.logger = @logger
      configuration.client_side_validation = false
      configuration.debugging = false

      # Configure auth key/cert or user/paswords
      if @config.auth_private_key
        configuration.key_file = @config.auth_private_key
        configuration.cert_file = @config.auth_certificate
      else
        configuration.username = @config.username
        configuration.password = @config.password
      end

      # Root CA Cert
      configuration.ssl_ca_cert = @config.ca_cert_file

      # SKIP SSL VALIDATION?
      if ENV['NSXT_SKIP_SSL_VERIFY']
        configuration.verify_ssl = false
        configuration.verify_ssl_host = false
      end
      @client = NSXTPolicy::ApiClient.new(configuration)
    end
  end
end