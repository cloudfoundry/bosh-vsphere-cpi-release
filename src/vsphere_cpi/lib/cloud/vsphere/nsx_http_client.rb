module VSphereCloud
  class NsxHttpClient < BaseHttpClient
    def initialize(user, password, ca_cert_file, http_log = nil)
      unless ENV['NSXT_SKIP_SSL_VERIFY'] then
        super(
          http_log: http_log,
          trusted_ca_file: ca_cert_file,
          ca_cert_manifest_key: 'vcenter.nsx.ca_cert',
          skip_ssl_verify: false
        )
      else
        super(
          http_log: http_log,
          skip_ssl_verify: true
        )
      end

      @backing_client.set_auth(nil, user, password)
      # NSX returns 403, not 401, so we need force basic auth from the get-go
      @backing_client.force_basic_auth = true
    end
  end
end
