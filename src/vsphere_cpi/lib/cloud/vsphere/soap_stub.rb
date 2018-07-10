require 'httpclient'
require 'cloud/vsphere/logger'

module VSphereCloud
  class SoapStub
    include Logger

    def initialize(vcenter_api_uri, http_client)
      @vcenter_api_uri = vcenter_api_uri
      @http_client = http_client
    end

    def create
      base_stub = VimSdk::Soap::StubAdapter.new(@vcenter_api_uri, 'vim.version.version9', @http_client)
      VSphereCloud::SdkHelpers::RetryableStubAdapter.new(base_stub)
    end
  end
end
