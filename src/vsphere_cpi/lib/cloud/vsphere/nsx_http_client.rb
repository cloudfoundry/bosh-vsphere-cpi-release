module VSphereCloud
  class NsxHttpClient < BaseHttpClient
    def initialize(user, password, http_log = nil)
      super(http_log, ENV['BOSH_NSX_CA_CERT_FILE'])

      @backing_client.set_auth(nil, user, password)
      # NSX returns 403, not 401, so we need force basic auth from the get-go
      @backing_client.force_basic_auth = true
    end
  end
end

