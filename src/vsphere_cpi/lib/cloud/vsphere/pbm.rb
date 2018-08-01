require 'cloud/vsphere/logger'
module VSphereCloud
  class Pbm
    include Logger
    attr_reader :service_content

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

    # can be encryption_profile if we want to actually find an encryption profile
    # TODO based on requirement update this
    def get_profile(name)
      profile_mgr = @service_content.profile_manager
      resource_type = VimSdk::Pbm::Profile::ResourceType.new
      resource_type.resource_type = 'STORAGE'
      profile_ids = profile_mgr.query_profile(resource_type)
      profiles = profile_mgr.retrieve_content(profile_ids)
      profile = profiles.select{|p| p.name == 'VM Encryption Policy'}.first
      profile_id = profile.profile_id
      profile_id#find profile matching the name and return that
    end

    #?? Define pbm_api_uri here
  end
end
