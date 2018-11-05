require 'cloud/vsphere/logger'
module VSphereCloud
  class Pbm
    include Logger
    # attr_reader :service_content

    def initialize(pbm_api_uri:, http_client:, vc_cookie:)
      pbm_soap_stub = VimSdk::Soap::PbmStubAdapter.new(
        pbm_api_uri,
        'pbm.version.version12',
        http_client,
        vc_cookie: vc_cookie
      )
      pbm_instance = VimSdk::Pbm::ServiceInstance.new('ServiceInstance', pbm_soap_stub)

      @service_content = pbm_instance.retrieve_content
    end

    def find_policy(policy_name)
      profile_mgr = @service_content.profile_manager
      profile_category = VimSdk::Pbm::Profile::CapabilityBasedProfile::ProfileCategoryEnum::REQUIREMENT
      resource_type = VimSdk::Pbm::Profile::ResourceType.new
      resource_type.resource_type = VimSdk::Pbm::Profile::ResourceTypeEnum::STORAGE
      profile_ids = profile_mgr.query_profile(resource_type, profile_category)
      profiles = profile_mgr.retrieve_content(profile_ids)
      profile = profiles.find{ |p| p.name == policy_name }
      raise 'Policy Not found' unless profile
      profile
    end
  end
end
