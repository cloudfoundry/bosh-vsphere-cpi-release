module VSphereCloud
  class CpiHttpClient < BaseHttpClient

    def initialize(http_log = nil)
      # skip SSL verification for backwards compatibility
      super(
        http_log: http_log,
        trusted_ca_file: ENV['BOSH_CA_CERT_FILE'],
        ca_cert_manifest_key: 'vcenter.connection_options.ca_cert',
        skip_ssl_verify: true,
      )
    end
  end
end
