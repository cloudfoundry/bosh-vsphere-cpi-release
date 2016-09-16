require 'httpclient'

module VSphereCloud
  class SoapStub
    def initialize(vcenter_api_uri, http_client, logger)
      @vcenter_api_uri = vcenter_api_uri
      @http_client = http_client
      @logger = logger
    end

    def create
      base_stub = VimSdk::Soap::StubAdapter.new(@vcenter_api_uri, 'vim.version.version8', @http_client)
      VSphereCloud::SdkHelpers::RetryableStubAdapter.new(base_stub, @logger)
    end
  end
end
