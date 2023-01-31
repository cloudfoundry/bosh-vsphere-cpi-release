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
      version = if $vc_version == "7.0"
                  'vim.version.v7_0'
                elsif $vc_version == "8.0"
                  'vim.version.v8_0_0_0'
                else
                  'vim.version.version12'
                end
      base_stub = VimSdk::Soap::StubAdapter.new(@vcenter_api_uri, version, @http_client)
      VSphereCloud::SdkHelpers::RetryableStubAdapter.new(base_stub)
    end
  end
end
