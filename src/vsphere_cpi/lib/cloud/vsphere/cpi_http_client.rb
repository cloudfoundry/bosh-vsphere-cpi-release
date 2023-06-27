require 'cloud/vsphere/base_http_client'

module VSphereCloud
  class CpiHttpClient < BaseHttpClient

    def initialize(connection_options: {}, http_log: nil)
      # skip SSL verification for backwards compatibility
      super(
        http_log: http_log,
        trusted_ca_file: connection_options['ca_cert_file'],
        ca_cert_manifest_key: 'vcenter.connection_options.ca_cert',
        skip_ssl_verify: true,
      )
    end
  end
end
