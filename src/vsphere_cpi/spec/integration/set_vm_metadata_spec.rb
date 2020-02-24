require 'integration/spec_helper'
require 'securerandom'
require 'tempfile'
require 'yaml'

describe 'set_vm_metadata' do
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

  after(:all) do
    delete_cat_and_tag
  end

=======
>>>>>>> 834c5bb4... Fixed unit tests for new changes
  let(:metadata) { {
      "bosh-#{SecureRandom.uuid}-key" => "test value",
      "OS" => "Linux",
      "BU" => "MAPBU",
<<<<<<< HEAD
      "Team" => "vcpi-team", #non-existent category
=======
      "Team" => "kaitingc", #non-existent category
>>>>>>> 834c5bb4... Fixed unit tests for new changes
      "Type" => "Sandbox",#tag does not match
      "deployment" => "zookeeper"
  } }
  let(:network_spec) do
    {
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
          'ip' => "169.254.1.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => { 'name' => @vlan },
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
      }
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
    }
  end
  let(:vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
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
    }
  end

=begin
  context 'when metadata has to be separated into tags and custom field attributes' do
    subject(:tagging_tag_api) { VSphereAutomation::CIS::TaggingTagApi.new(tag_client) }
>>>>>>> 834c5bb4... Fixed unit tests for new changes
    subject(:cpi) { VSphereCloud::Cloud.new(cpi_options) }
    after do
      cpi.delete_vm(@vm_cid) if @vm_cid
      cpi.client.remove_custom_field_def(metadata.keys.first, VimSdk::Vim::VirtualMachine)
    end
<<<<<<< HEAD
=======
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
    end
  end
end
