module VSphereCloud
  class NSXTApiClientBuilder
    def initialize(config, logger)
      @config = config
      @logger = logger
    end

    def get_client
      return @client unless @client.nil?

      configuration = NSXT::Configuration.new
      configuration.host = @config.host
      configuration.logger = @logger
      configuration.client_side_validation = false

      # Configure auth key/cert or user/paswords
      if @config.auth_private_key
        configuration.key_file = @config.auth_private_key
        configuration.cert_file = @config.auth_certificate
        # Are these required with key/cert pair?
        # configuration.verify_ssl = false
        # configuration.verify_ssl_host = false
      else
        configuration.username = @config.username
        configuration.password = @config.password
      end

      # REMOTE AUTH for NSX-T vIDM Integration
      if @config.remote_auth != nil
        configuration.remote_auth = @config.remote_auth
      end

      # Root CA Cert
      if ENV['BOSH_NSXT_CA_CERT_FILE']
        configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
      end

      # SKIP SSL VALIDATION?
      if ENV['NSXT_SKIP_SSL_VERIFY']
        configuration.verify_ssl = false
        configuration.verify_ssl_host = false
      end
      @client = NSXT::ApiClient.new(configuration)
      #Design here isn't ideal but allows us to keep "x-allow-overwrite" switching logic out of Swagger generated code.
      if @config.allow_overwrite?
        @client.x_allow_overwrite(true)
      end
      @client
    end
  end
end