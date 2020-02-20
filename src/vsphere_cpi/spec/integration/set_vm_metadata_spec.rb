require 'integration/spec_helper'
require 'securerandom'
require 'tempfile'
require 'yaml'
include LifecycleHelpers

describe 'set_vm_metadata' do
  before(:all) do
    create_cat_and_tag
  end
  after(:all) do
    delete_cat_and_tag
  end

  let(:metadata) { {
      "bosh-#{SecureRandom.uuid}-key" => "test value",
      "OS" => "Linux",
      "BU" => "MAPBU",
      "Team" => "vcpi-team", #non-existent category
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
end
