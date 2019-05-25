require 'integration/spec_helper'
require 'vsphere-automation-cis'
require 'vsphere-automation-vcenter'
require 'ostruct'

module VSphereCloud
  describe TaggingTag::AttachTagToVm, attach_tag:true do
    before(:all) do
      @host = fetch_property('BOSH_VSPHERE_CPI_HOST')
      @user = fetch_property('BOSH_VSPHERE_CPI_USER')
      @password = fetch_property('BOSH_VSPHERE_CPI_PASSWORD')
      create_cat_and_tag
    end

    after(:all) do
      delete_cat_and_tag
    end

    let(:network_spec) do
      {
        'static' => {
          'ip' => "169.254.1.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => { 'name' => @vlan },
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        }
      }
    end

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'tags' => tags
      }
    end

    context 'when create a vm and attach a single vm-associable tag to it' do
      let(:tags) { [ { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1'} ] }
      it 'created a vm with tag attached' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach multiple vm-associable-and-multi-cardinality tags to it' do
      let(:tags) {
        [ { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1'},
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-2'},
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-3'},
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-1'},
        ]
      }
      it 'created a vm with tags attached' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1', 'tag-name-a-2', 'tag-name-a-3', 'tag-name-c-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach a vm-non-associable tag to it' do
      let(:tags) { [ { 'category' => 'category-name-b', 'tag' => 'tag-name-b-1'} ] }
      it 'created a vm without tags attached' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, [])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach multiple same-category-single-cardinality tags to it' do
      let(:tags) {
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1'},
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-1'},
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-2'}
        ]
      }
      it 'created a vm without same-category-single-cardinality tags' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach wrong category tags to it' do
      let(:tags) {
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1'},
          { 'category' => 'category-name-d', 'tag' => 'tag-name-d-1'},
        ]
      }
      it 'created a vm with correct category tags attached' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when creating a VM and attach a non-existent category to it' do
      let(:tags) {
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1'},
          { 'category' => 'category-name-d', 'tag' => 'tag-name-d-1'}
        ]
      }
      it 'created a vm with correct tags attached' do
        begin
          test_vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    private
    def tag_ids
      return @tag_ids unless @tag_ids.nil?
      @tag_ids = Array.new
    end

    def cate_ids
      return @cate_ids unless @cate_ids.nil?
      @cate_ids = Array.new
    end

    def tag_client
      return @tag_client unless @tag_client.nil?
      cloud_config = OpenStruct.new(vcenter_host: @host, vcenter_password: @password, vcenter_user: @user)
      @tag_client = VSphereCloud::TaggingTag::AttachTagToVm.InitializeConnection(cloud_config, Bosh::Cpi::Logger.new(STDOUT))
    end

    def tag_association_api
      @tag_association_api ||= VSphereAutomation::CIS::TaggingTagAssociationApi.new(tag_client)
    end

    def tagging_tag_api
      @tagging_tag_api ||= VSphereAutomation::CIS::TaggingTagApi.new(tag_client)
    end

    def tagging_category_api
      @tagging_category_api ||= VSphereAutomation::CIS::TaggingCategoryApi.new(tag_client)
    end

    def create_category(category_config_hash)
      category_create = VSphereAutomation::CIS::CisTaggingCategoryCreate.new(category_config_hash)
      category_id_info = tagging_category_api.create(category_create)
      category_id_info.value
    end

    def create_tag(tag_config_hash)
      cis_tagging_tag_create = VSphereAutomation::CIS::CisTaggingTagCreate.new(tag_config_hash)
      tag_id_info = tagging_tag_api.create(cis_tagging_tag_create)
      tag_id_info.value
    end

    def create_cat_and_tag
      cate_config_1 = {
        "create_spec" => {
          "name" => "category-name-a",
          "description" => "category contains multi-tag, associable to vm, multi-cardinality",
          "associable_types" => [],
          "cardinality" => "MULTIPLE"
        }
      }
      cate_config_2 = {
          "create_spec" => {
            "name" => "category-name-b",
            "description" => "category contains multi-tag, not associable to vm, multi-cardinality",
            "associable_types" => ["VirtualApp", "StoragePod", "Datacenter"],
            "cardinality" => "MULTIPLE"
          }
      }
      cate_config_3 = {
        "create_spec" => {
          "name" => "category-name-c",
          "description" => "category contains multi-tag, associable to vm, single-cardinality",
          "associable_types" => [],
          "cardinality" => "SINGLE"
        }
      }

      cate_config_array = [cate_config_1, cate_config_2, cate_config_3]
      cate_config_array.each do |cate_config|
        cate_id = create_category(cate_config)
        cate_ids << cate_id unless cate_id.nil?
      end

      tag_config_array = Array.new
      tag_config_array << { "create_spec" => { "name" => "tag-name-a-1", "description" => "null", "category_id" => cate_ids[0] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-a-2", "description" => "null", "category_id" => cate_ids[0] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-a-3", "description" => "null", "category_id" => cate_ids[0] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-b-1", "description" => "null", "category_id" => cate_ids[1] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-b-2", "description" => "null", "category_id" => cate_ids[1] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-c-1", "description" => "null", "category_id" => cate_ids[2] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-c-2", "description" => "null", "category_id" => cate_ids[2] } }
      tag_config_array << { "create_spec" => { "name" => "tag-name-c-3", "description" => "null", "category_id" => cate_ids[2] } }

      tag_config_array.each do |tag_config|
        unless tag_config["create_spec"]["category_id"].nil?
          tag_id = create_tag(tag_config)
          tag_ids << tag_id unless tag_id.nil?
        end
      end
    end

    def delete_cat_and_tag
      tag_ids.each do |tag_id|
        tagging_tag_api.delete(tag_id)
      end

      cate_ids.each do |cate_id|
        tagging_category_api.delete(cate_id)
      end
    end

    def verify_tags(vm_mob_id, attached_tags)
      object_id_hash = { "type" => "VirtualMachine",  "id" => vm_mob_id }
      object_ids = { "object_ids" => [VSphereAutomation::CIS::VapiStdDynamicID.new(object_id_hash)] }
      list_attached_tags_on_object = VSphereAutomation::CIS::CisTaggingTagAssociationListAttachedTagsOnObjects.new(object_ids)
      list_attached_tags_on_objects_result  = tag_association_api.list_attached_tags_on_objects(list_attached_tags_on_object)
      tags_on_vm_info = list_attached_tags_on_objects_result.value[0]
      if tags_on_vm_info.nil?
        tags_on_vm = []
      else
        tags_on_vm = tags_on_vm_info.tag_ids
      end
      return false unless attached_tags.size == tags_on_vm.size
      tags_on_vm.each do |tag_id|
        tag_info = tagging_tag_api.get(tag_id)
        return false unless attached_tags.include?(tag_info.value.name)
      end
      return true
    end
  end
end
