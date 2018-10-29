require 'cloud/vsphere/logger'
module VSphereCloud
  class Pbm
    include Logger
    # attr_reader :service_content

    def initialize(pbm_uri, http_client, vc_cookie)
      pbm_soap_stub = VimSdk::Soap::PbmStubAdapter.new(
        pbm_uri,
        'pbm.version.version12',
        http_client,
        vc_cookie: vc_cookie
      )
      pbm_instance = VimSdk::Pbm::ServiceInstance.new('ServiceInstance', pbm_soap_stub)

      @service_content = pbm_instance.retrieve_content
    end
  end
end
