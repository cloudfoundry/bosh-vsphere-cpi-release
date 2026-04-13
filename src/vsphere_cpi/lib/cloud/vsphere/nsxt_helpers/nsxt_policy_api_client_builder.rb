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
      raw_ca = @config.ca_cert_file
      s = raw_ca.to_s.strip
      ca_file = s.empty? ? nil : s
      configuration.ssl_ca_cert = ca_file

      # SKIP SSL VALIDATION?
      configuration.verify_ssl = !ca_file.nil?
      configuration.verify_ssl_host = !ca_file.nil?

      @client = NSXTPolicy::ApiClient.new(configuration)
    end
  end
end