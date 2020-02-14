require 'integration/spec_helper'
require 'securerandom'
require 'tempfile'
require 'yaml'

describe 'set_vm_metadata' do
  let(:metadata) { {
      "bosh-#{SecureRandom.uuid}-key" => "test value",
      "OS" => "Linux",
      "BU" => "MAPBU",
      "Team" => "kaitingc", #non-existent category
      "Type" => "Sandbox",#tag does not match
      "deployment" => "zookeeper"
  } }
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
    }
  end

  context 'when trying to attach tags and custom fields' do
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    it 'succeeds' do
      @vm_cid = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {'key' => 'value'}
      )
      threads = []
      cpis = []
      pool_size = 1
      pool_size.times do
        cpis << VSphereCloud::Cloud.new(cpi_options)
      end

      pool_size.times do |i|
        threads << Thread.new do
          cpis[i].set_vm_metadata(@vm_cid, metadata)
        end
      end
      expect {
        threads.map(&:join)
      }.to_not raise_error
    end
  end

  def fetch_property(key)
    fail "Missing Environment variable #{key}: #{MISSING_KEY_MESSAGES[key]}" unless (ENV.has_key?(key))
    value = ENV[key]
    fail "Environment variable #{key} must not be blank: #{MISSING_KEY_MESSAGES[key]}" if (value =~ /^\s*$/)
    value
  end

  def create_cat_and_tag
    cate_config_1 = {
        "create_spec" => {
            "name" => "OS",
            "description" => "category contains single-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cate_config_2 = {
        "create_spec" => {
            "name" => "BU",
            "description" => "category contains single-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cate_config_3 = {
        "create_spec" => {
            "name" => "Team",
            "description" => "category contains single-tag, associable to vm, single-cardinality",
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
    tag_config_array << { "create_spec" => { "name" => "Linux", "description" => "null", "category_id" => cate_ids[0] } }
    tag_config_array << { "create_spec" => { "name" => "MAPBU", "description" => "null", "category_id" => cate_ids[1] } }
    tag_config_array << { "create_spec" => { "name" => "vcpi-team", "description" => "null", "category_id" => cate_ids[2] } }


    tag_config_array.each do |tag_config|
      unless tag_config["create_spec"]["category_id"].nil?
        tag_id = create_tag(tag_config)
        tag_ids << tag_id unless tag_id.nil?
      end
    end
  end

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

  def delete_cat_and_tag
    tag_ids.each do |tag_id|
      tagging_tag_api.delete(tag_id)
    end

    cate_ids.each do |cate_id|
      tagging_category_api.delete(cate_id)
    end
  end


=begin
  context 'when metadata has to be separated into tags and custom field attributes' do
    subject(:tagging_tag_api) { VSphereAutomation::CIS::TaggingTagApi.new(tag_client) }
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    let(:tags) { [ { 'cat_id1' => 'OS', 'tag_id1' => 'Linux'} ] }
    let (:tagging_category_api) { VSphereAutomation::CIS::TaggingCategoryApi.new(tag_client) }

    it 'assigns correct category:tag pairs as tags and custom field attributes' do
      @vm_cid = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {'key' => 'value'}
      )
      cpis = VSphereCloud::Cloud.new(cpi_options)
      thread = Thread.new do
        cpis.set_vm_metadata(@vm_cid, metadata)
      end
      expect
    end
  end
=end

  context 'when called with duplicate keys with multiple threads' do
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    after do
      cpi.delete_vm(@vm_cid) if @vm_cid
      cpi.client.remove_custom_field_def(metadata.keys.first, VimSdk::Vim::VirtualMachine)
    end
    it 'succeeds' do
      @vm_cid = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )
      threads = []
      cpis = []
      pool_size = 5
      pool_size.times do
        cpis << VSphereCloud::Cloud.new(cpi_options)
      end

      pool_size.times do |i|
        threads << Thread.new do
          cpis[i].set_vm_metadata(@vm_cid, metadata)
        end
      end

      expect {
        threads.map(&:join)
      }.to_not raise_error

    end
  end
=end
end
