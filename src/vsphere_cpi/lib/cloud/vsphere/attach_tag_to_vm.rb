require 'cloud/vsphere/logger'
require 'cloud/vsphere/tag_client'

module VSphereCloud
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

      def initialize(tag_client)
        @tag_client = tag_client
      end

      def retrieve_category_id(category_name, category_ids)
        category_ids.find { |category_id| @tag_client.get_category(category_id)['name'] == category_name }
      end

      def retrieve_tag_id(tag_name, tag_id_list)
        tag_id_list.find { |tag_id| @tag_client.get_tag(tag_id)['name'] == tag_name }
      end

      def vm_association?(target_category_id)
        category_assoc_types = @tag_client.get_category(target_category_id)['associable_types']
        category_assoc_types = [] if category_assoc_types.nil?
        category_assoc_types.empty? || category_assoc_types.include?('VirtualMachine')
      end

      def create_tag_hash(vm_config_tags)
        tag_hash = {}
        vm_config_tags.each do |vm_config_tag|
          begin
            raise BadCategoryTagInfoError.new('Invalid tag configuration format') unless vm_config_tag.is_a?(Hash)
            category = vm_config_tag['category']
            tag = vm_config_tag['tag']
            raise BadCategoryTagInfoError.new('Missing category content') if category.nil?
            raise BadCategoryTagInfoError.new('Empty category') if !category.is_a?(String) || category.strip.empty?
            raise CreateTagHashTagError.new('Missing tag', category) if tag.nil?
            raise CreateTagHashTagError.new('Empty tag', category) if !tag.is_a?(String) || tag.strip.empty?
            category = category.strip
            tag = tag.strip
          rescue => e
            if e.instance_of?(BadCategoryTagInfoError)
              logger.warn("Create Tag Hash Category Error Raised with message : #{e.message}")
            else
              logger.warn("Create Tag Hash Tag Error Raised with message : #{e.message}")
            end
            next
          end
          tag_hash[category] ||= []
          tag_hash[category] << tag
        end
        tag_hash
      end

      def attach_single_tag(vm_mob_id, tag_id)
        @tag_client.attach_tag(tag_id, vm_mob_id)
      end

      def attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
        if @tag_client.get_category(target_category_id)['cardinality'] == 'SINGLE'
          raise CardinalityError.new(category_name)
        end
        @tag_client.attach_multiple_tags_to_object(tag_ids, vm_mob_id)
      end

      def attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
        begin
          tag_hash = create_tag_hash(vm_config_tags)
          raise NoCategoryTagPairError.new if tag_hash.empty?
          category_ids = @tag_client.list_categories
          raise VCenterNoCategoryFoundError.new if category_ids.empty?
          tag_hash.keys.each do |category_name|
            begin
              target_category_id = retrieve_category_id(category_name, category_ids)
              raise VCenterBadEntityError.new(category_name, 'category') if target_category_id.nil?

              vm_association = vm_association?(target_category_id)
              raise VmAssociationError.new(category_name) unless vm_association

              tag_array = tag_hash[category_name]
              logger.warn(DuplicatedTagError.new(category_name).message) if tag_array.uniq!

              tag_id_list = @tag_client.list_tags_for_category(target_category_id)
              tag_ids = tag_array.inject([]) do |acc, tag_name|
                target_tag_id = retrieve_tag_id(tag_name, tag_id_list)
                logger.warn(VCenterBadEntityError.new(tag_name, 'tag')) if target_tag_id.nil?
                acc << target_tag_id
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
