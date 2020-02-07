require 'cloud/vsphere/logger'
require 'vsphere-automation-cis'
require 'vsphere-automation-vcenter'

module  VSphereCloud
  module TaggingTag

    class VCenterBadEntityError < StandardError
      def initialize(name, type)
        @name = name
        @type = type
      end

      def to_s
        "Unable to locate #{@type} with name '#{@name}' on vCenter, skip attaching this #{@type}."
      end
    end

    class VCenterNoTagFoundError < StandardError
      def initialize(category_name)
        @category_name = category_name
      end

      def to_s
        "None of the provided tags exist for the category '#{@category_name}' on vCenter."
      end
    end

    class VCenterNoCategoryFoundError < StandardError
      def to_s
        "No category exist on vCenter, skip attaching tags."
      end
    end

    class VmAssociationError < StandardError
      def initialize(category_name)
        @category_name = category_name
      end

      def to_s
        "Tag category '#{@category_name}' is not associated with object type: 'Virtual Machine', skip attaching this category to vm."
      end
    end

    class CardinalityError < StandardError
      def initialize(category_name)
        @category_name = category_name
      end

      def to_s
        "Tag category '#{@category_name}' does not support 'Multiple Cardinality', skip tagging this category to vm."
      end
    end

    class NoCategoryTagPairError < StandardError
      def to_s
        "No valid category-tag pair in cloud config."
      end
    end

    class DuplicatedTagError < StandardError
      def initialize(category_name)
        @category_name = category_name
      end

      def to_s
        "Duplicated tags found in tag category '#{@category_name}', deduplicated and continue."
      end
    end

    class BadCategoryTagInfoError < StandardError
      def initialize(type)
        @type = type
      end

      def to_s
        "#{@type} in cloud config , skip processing this category-tag pair."
      end
    end

    class CreateTagHashTagError < StandardError
      def initialize(type, category_name)
        @type = type
        @category_name = category_name
      end

      def to_s
        "#{@type} in category '#{@category_name}', skip attaching this tag."
      end
    end

    class AttachTagToVm
      include Logger
      def self.InitializeConnection(cloud_config, logger)
        configuration = VSphereAutomation::Configuration.new.tap do |config|
          config.host = cloud_config.vcenter_host
          config.username = cloud_config.vcenter_user
          config.password = cloud_config.vcenter_password
          config.scheme = 'https'
          config.verify_ssl = false
          config.verify_ssl_host = false
          config.logger = logger
          config.debugging = false
        end
        api_client = VSphereAutomation::ApiClient.new(configuration)
        api_client.default_headers['Authorization'] = configuration.basic_auth_token
        session_api = VSphereAutomation::CIS::SessionApi.new(api_client)
        session_id = session_api.create('').value
        api_client.default_headers['vmware-api-session-id'] = session_id
        api_client
      end

      def initialize(api_client)
        @api_client = api_client
      end

      private def tag_association_api
        @tag_association_api ||= VSphereAutomation::CIS::TaggingTagAssociationApi.new(@api_client)
      end

      private def tagging_tag_api
        @tagging_tag_api ||= VSphereAutomation::CIS::TaggingTagApi.new(@api_client)
      end

      def tagging_category_api
        @tagging_category_api ||= VSphereAutomation::CIS::TaggingCategoryApi.new(@api_client)
      end

      def retrieve_category_id(category_name, category_ids)
        category_ids.find { |category_id| tagging_category_api.get(category_id).value.name == category_name }
      end

      def retrieve_tag_id(tag_name, tag_id_list)
        tag_id_list.find { |tag_id| tagging_tag_api.get(tag_id).value.name == tag_name }
      end

      def vm_association?(target_category_id)
        category_information = tagging_category_api.get(target_category_id)
        category_assoc_types = category_information.value.associable_types
        category_assoc_types.empty? || category_assoc_types.include?("VirtualMachine")
      end

      def valid_cat_tag(category_tag_hash)
        category_ids = tagging_category_api.list.value
        return {} if category_ids.empty?
        category_tag_hash.reject do |cat_name, tag|
          cat_id = retrieve_category_id(cat_name.to_s, category_ids)
          cat_id.nil? || retrieve_tag_id(tag.to_s, tagging_tag_api.list_tags_for_category(cat_id).value).nil?
        end
      end

      def attach_cat_tag_to_vm(cat_name, tag_name, vm_mob_id)
        begin
          category_ids = tagging_category_api.list.value
          cat_id = retrieve_category_id(cat_name.to_s, category_ids)
          tag_id_list  = tagging_tag_api.list_tags_for_category(cat_id).value
          tag_id = retrieve_tag_id(tag_name, tag_id_list)
          attach_single_tag(vm_mob_id, tag_id)
        rescue => e
          logger.warn("Cannot attach category/tag pair :  #{cat_name}/#{tag_name} with error #{e}")
        end
      end

      def create_tag_hash(vm_config_tags)
        tag_hash = Hash.new
        vm_config_tags.each do |vm_config_tag|
          begin
            raise BadCategoryTagInfoError.new("Missing category content") if vm_config_tag["category"].nil?
            raise BadCategoryTagInfoError.new("Empty category") if vm_config_tag["category"].empty?
            raise CreateTagHashTagError.new("Missing tag",vm_config_tag["category"] ) if vm_config_tag["tag"].nil?
            raise CreateTagHashTagError.new("Empty tag",vm_config_tag["category"] ) if vm_config_tag["tag"].empty?
          rescue => e
            if e.instance_of?(BadCategoryTagInfoError)
              logger.warn("Create Tag Hash Category Error Raised with message : #{e.message}")
            else
              logger.warn("Create Tag Hash Tag Error Error Raised with message : #{e.message}")
            end
            next
          end
          tag_hash[vm_config_tag["category"]] ||= []
          tag_hash[vm_config_tag["category"]] << vm_config_tag["tag"]
        end
        tag_hash
      end

      def attach_single_tag(vm_mob_id, tag_id)
        tag_assoc_info = VSphereAutomation::CIS::CisTaggingTagAssociationAttach.new
        tag_assoc_info.object_id = VSphereAutomation::CIS::VapiStdDynamicID.new
        tag_assoc_info.object_id.id = vm_mob_id
        tag_assoc_info.object_id.type = 'VirtualMachine'
        tag_association_api.attach(tag_id, tag_assoc_info)
      end

      def attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
        if tagging_category_api.get(target_category_id).value.cardinality == "SINGLE"
          raise CardinalityError.new(category_name)
        end
        multi_tag_assoc_info = VSphereAutomation::CIS::CisTaggingTagAssociationAttachMultipleTagsToObject.new
        multi_tag_assoc_info.object_id = VSphereAutomation::CIS::VapiStdDynamicID.new
        multi_tag_assoc_info.object_id.id = vm_mob_id
        multi_tag_assoc_info.object_id.type = 'VirtualMachine'
        multi_tag_assoc_info.tag_ids = tag_ids
        tag_association_api.attach_multiple_tags_to_object(multi_tag_assoc_info)
      end

      def attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
        begin
          tag_hash = create_tag_hash(vm_config_tags)
          raise NoCategoryTagPairError.new if tag_hash.empty?
          category_ids = tagging_category_api.list.value
          raise VCenterNoCategoryFoundError.new if category_ids.empty?
          tag_hash.keys.each do |category_name|
            begin
              target_category_id = retrieve_category_id(category_name, category_ids)
              raise VCenterBadEntityError.new(category_name, "category") if target_category_id.nil?

              vm_association = vm_association?(target_category_id)
              raise VmAssociationError.new(category_name) unless vm_association

              tag_array = tag_hash[category_name]
              logger.warn(DuplicatedTagError.new(category_name).message) if tag_array.uniq!

              tag_id_list = tagging_tag_api.list_tags_for_category(target_category_id).value
              tag_ids = tag_array.inject([]) do |tag_ids, tag_name|
                target_tag_id = retrieve_tag_id(tag_name, tag_id_list)
                logger.warn(VCenterBadEntityError.new(tag_name, "tag")) if target_tag_id.nil?
                tag_ids << target_tag_id
              end.compact

              case tag_ids.size
                when 0
                  raise VCenterNoTagFoundError.new(category_name)
                when 1
                  attach_single_tag(vm_mob_id, tag_ids[0])
                else
                  attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
              end

            rescue => e
              case e
                when VCenterBadEntityError
                  logger.warn("Bad Entity Error Raised with message : #{e.message}")
                when VmAssociationError
                  logger.warn("Bad VM Association Error Raised with message : #{e.message}")
                when VCenterNoTagFoundError
                  logger.warn("vCenter No Tag Found Error Raised with message : #{e.message}")
                when CardinalityError
                  logger.warn("Cardinality Error Raised with message : #{e.message}")
                else
                  logger.warn(e.message)
              end
            end
          end
        rescue => e
          logger.warn("Unable to attach tags with message: #{e.message}")
        end
        logger.info("Attach tags to vm '#{vm_config_name}' finished.")
      end
    end
  end
end