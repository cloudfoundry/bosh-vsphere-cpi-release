require 'integration/spec_helper'
require 'securerandom'
require 'tempfile'
require 'yaml'
include LifecycleHelpers

describe 'set_vm_metadata' do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  before(:all) do
    cat_config_1 = {
        "create_spec" => {
            "name" => "OS",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_2 = {
        "create_spec" => {
            "name" => "BU",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_3 = {
        "create_spec" => {
            "name" => "Team",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_array = [cat_config_1, cat_config_2, cat_config_3]
    #extract category_ids from category_configurations and create categories on Vm in VCenter
    cat_id_array = cat_ids(cat_config_array)

    tag_config_array = Array.new
    tag_config_array << { "create_spec" => { "name" => "Linux", "description" => "null", "category_id" => cat_id_array[0] } }
    tag_config_array << { "create_spec" => { "name" => "MAPBU", "description" => "null", "category_id" => cat_id_array[1] } }
    tag_config_array << { "create_spec" => { "name" => "vcpi-team", "description" => "null", "category_id" => cat_id_array[2] } }

    #assign category/tag pairs to VM in VCenter using tag_name and category_id specified in tag_config_array
    create_cat_and_tag(tag_config_array)
  end

=======
  before(:all) do
    cat_config_1 = {
        "create_spec" => {
            "name" => "OS",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_2 = {
        "create_spec" => {
            "name" => "BU",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_3 = {
        "create_spec" => {
            "name" => "Team",
            "description" => "category contains multi-tag, associable to vm, single-cardinality",
            "associable_types" => [],
            "cardinality" => "SINGLE"
        }
    }
    cat_config_array = [cat_config_1, cat_config_2, cat_config_3]
    #extract category_ids from category_configurations and create categories on Vm in VCenter
    cat_id_array = cat_ids(cat_config_array)

    tag_config_array = Array.new
    tag_config_array << { "create_spec" => { "name" => "Linux", "description" => "null", "category_id" => cat_id_array[0] } }
    tag_config_array << { "create_spec" => { "name" => "MAPBU", "description" => "null", "category_id" => cat_id_array[1] } }
    tag_config_array << { "create_spec" => { "name" => "vcpi-team", "description" => "null", "category_id" => cat_id_array[2] } }

    #assign category/tag pairs to VM in VCenter using tag_name and category_id specified in tag_config_array
    create_cat_and_tag(tag_config_array)
  end
>>>>>>> 856b5d1e... added integration tests
  after(:all) do
    delete_cat_and_tag
  end

<<<<<<< HEAD
=======
>>>>>>> 834c5bb4... Fixed unit tests for new changes
=======
>>>>>>> 856b5d1e... added integration tests
  let(:metadata) { {
      "bosh-#{SecureRandom.uuid}-key" => "test value",
      "OS" => "Linux",
      "BU" => "MAPBU",
<<<<<<< HEAD
<<<<<<< HEAD
      "Team" => "vcpi-team", #non-existent category
=======
      "Team" => "kaitingc", #non-existent category
>>>>>>> 834c5bb4... Fixed unit tests for new changes
=======
      "Team" => "vcpi-team", #non-existent category
>>>>>>> 856b5d1e... added integration tests
      "Type" => "Sandbox",#tag does not match
      "deployment" => "zookeeper"
  } }
  let(:network_spec) do
    {
<<<<<<< HEAD
<<<<<<< HEAD
      'static' => {
=======
  context 'when called with duplicate keys with multiple threads' do
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    let(:metadata) { {
        "bosh-#{SecureRandom.uuid}-key" => "test value",
        "OS" => "Linux",
        "BU" => "MAPBU",
        "team" => "kaitingc", #non-existent category
        "type" => "prodd",#tag does not match
        "deployment" => "zookeeper"
    } }
    let(:network_spec) do
      {
        'static' => {
>>>>>>> 3bbd3920... Integration Test (Manual Check) TBRL
=======
      'static' => {
>>>>>>> 856b5d1e... added integration tests
          'ip' => "169.254.1.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => { 'name' => @vlan },
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
      }
<<<<<<< HEAD
=======
        'static' => {
            'ip' => "169.254.1.#{rand(4..254)}",
            'netmask' => '255.255.254.0',
            'cloud_properties' => { 'name' => @vlan },
            'default' => ['dns', 'gateway'],
            'dns' => ['169.254.1.2'],
            'gateway' => '169.254.1.3'
        }
>>>>>>> 834c5bb4... Fixed unit tests for new changes
=======
>>>>>>> 856b5d1e... added integration tests
    }
  end
  let(:vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
<<<<<<< HEAD
<<<<<<< HEAD
        'tags' => tags
    }
  end
  let(:tags) {
    [
        { 'category' => 'OS', 'tag' => 'Linux'},
        { 'category' => 'BU', 'tag' => 'MAPBU'},
        { 'category' => 'Team', 'tag' => 'vcpi-team'},
    ]
  }

  context 'when called with duplicate keys with multiple threads' do
=======
=======
        'tags' => tags
>>>>>>> 856b5d1e... added integration tests
    }
  end
  let(:tags) {
    [
        { 'category' => 'OS', 'tag' => 'Linux'},
        { 'category' => 'BU', 'tag' => 'MAPBU'},
        { 'category' => 'Team', 'tag' => 'vcpi-team'},
    ]
  }

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

  context 'when attaching tags and custom fields to VM' do
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    it 'assigns relevant tags on VM' do
      vm_cid = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {}
      )
      @cpi.set_vm_metadata(vm_cid, metadata)

      #expect current vm to have tags attached
      mob_id = @cpi.vm_provider.find(vm_cid).mob.__mo_id__
      expect(vm_cid).to_not be_nil
      expect(verify_tags(mob_id, ['Linux', 'MAPBU', 'vcpi-team'])).to be(true)
      expect(verify_tags(mob_id, ['Type', 'deployment'])).to be(false)
    ensure
      delete_vm(@cpi, vm_cid)
    end
  end
<<<<<<< HEAD

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
<<<<<<< HEAD

  def delete_cat_and_tag

    tag_ids.each do |tag_id|
      tagging_tag_api.delete(tag_id)
    end
    cate_ids.each do |cate_id|
      tagging_category_api.delete(cate_id)
    end
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

  def fetch_property(key)
    fail "Missing Environment variable #{key}: #{MISSING_KEY_MESSAGES[key]}" unless (ENV.has_key?(key))
    value = ENV[key]
    fail "Environment variable #{key} must not be blank: #{MISSING_KEY_MESSAGES[key]}" if (value =~ /^\s*$/)
    value
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

<<<<<<< HEAD
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
>>>>>>> 834c5bb4... Fixed unit tests for new changes
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
<<<<<<< HEAD
    after do
      cpi.delete_vm(@vm_cid) if @vm_cid
      cpi.client.remove_custom_field_def(metadata.keys.first, VimSdk::Vim::VirtualMachine)
    end
<<<<<<< HEAD
=======
=======
    let(:tags) { [ { 'cat_id1' => 'OS', 'tag_id1' => 'Linux'} ] }
    let (:tagging_category_api) { VSphereAutomation::CIS::TaggingCategoryApi.new(tag_client) }

>>>>>>> ae3817f7... added integration tests
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
>>>>>>> 834c5bb4... Fixed unit tests for new changes
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    end
  end

  context 'when attaching tags and custom fields to VM' do
    let (:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    it 'assigns relevant tags on VM' do
      vm_cid = @cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {}
      )
      @cpi.set_vm_metadata(vm_cid, metadata)
      
      mob_id = @cpi.vm_provider.find(vm_cid).mob.__mo_id__
      expect(vm_cid).to_not be_nil
      expect(verify_tags(mob_id, ['Linux', 'MAPBU', 'vcpi-team'])).to be(true)
      expect(verify_tags(mob_id, ['Type', 'deployment'])).to be(false)
    ensure
      delete_vm(@cpi, vm_cid)
=======
      require 'pry-byebug'
      binding.pry
>>>>>>> 3bbd3920... Integration Test (Manual Check) TBRL
=======
      #require 'pry-byebug'
      #binding.pry
>>>>>>> 834c5bb4... Fixed unit tests for new changes
=======
>>>>>>> ae3817f7... added integration tests
    end
  end
=end
=======
>>>>>>> 856b5d1e... added integration tests
=======
>>>>>>> 8420aba5... Moved helper functions to lifecycle helpers
=======
>>>>>>> f2538e9e... fixed integration tests and moved helper functions to lifecycle_helpers.rb
end
