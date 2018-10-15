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

    # TODO based on requirement update this
    def get_profile(profile_name='VM Encryption Policy')
      profile_mgr = @service_content.profile_manager
      resource_type = VimSdk::Pbm::Profile::ResourceType.new
      resource_type.resource_type = 'STORAGE'
      profile_ids = profile_mgr.query_profile(resource_type)
      profiles = profile_mgr.retrieve_content(profile_ids)
      profile = profiles.select{|p| p.name == profile_name}.first
      profile_id = profile.profile_id
      profile_id
    end

    def get_compatible_datastores(profile_id, datastores= [])
      placement_solver = @service_content.placement_solver
      placement_hubs = datastores #will be eventually pbm.placement.PlacementHub
      placement_result = placement_solver.check_compatibility(placement_hubs, profile_id)
      placement_result.select { |pr| pr.error.empty? }
    end
    #?? Define pbm_api_uri here
  end
end
