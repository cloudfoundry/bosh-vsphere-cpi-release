require 'httpclient'

module VSphereCloud
  class SoapStub
    def initialize(vcenter_api_uri, http_client)
      @vcenter_api_uri = vcenter_api_uri
      @http_client = http_client
    end

    def create
      VimSdk::Soap::StubAdapter.new(@vcenter_api_uri, 'vim.version.version8', @http_client)
    end
  end
end
