require 'cloud/vsphere/logger'
module VSphereCloud
  class Pbm
    include Logger
    attr_reader :service_content

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
      raise "Storage Policy: #{policy_name} not found" unless profile
      profile
    end

    def find_compatible_datastores(policy_name, datacenter)
      policy = find_policy(policy_name)
      placement_solver = @service_content.placement_solver
      placement_result = placement_solver.check_compatibility([], policy.profile_id)
      results = placement_result.select { |pr| pr.error.empty? }
      raise "No compatible Datastore for Storage Policy: #{policy_name}" if results.empty?

      datastore_hubs = results.select { |r| r.hub.hub_type == 'Datastore' }

      # TODO figure out if we needs to support only SDRS enabled datastore clusters and then select all datastores from that list
      # datastore_clusters = results.select { |r| r.hub.hub_type == 'StoragePod' }

      compatible_datastores_mo_id = datastore_hubs.map { |d| d.hub.hub_id }
      all_datastores = datacenter.mob.datastore_folder.child_entity.select {|ce| ce.class == VimSdk::Vim::Datastore}
      all_datastores.select { |d| compatible_datastores_mo_id.include?(d.__mo_id__) }
    end
  end
end
