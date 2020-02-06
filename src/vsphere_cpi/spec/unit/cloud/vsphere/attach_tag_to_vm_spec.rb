require 'spec_helper'
require 'vsphere-automation-cis'
require 'vsphere-automation-vcenter'

module VSphereCloud
  module TaggingTag
    describe AttachTagToVm, fake_logger: true do
      subject(:api_client) { VSphereAutomation::ApiClient.new }
      subject(:tagging_tag) { TaggingTag::AttachTagToVm.new(api_client) }
      let(:vm_mob) { instance_double('VimSdk::Vim::VirtualMachine') }

      describe '#retrieve_category_id' do
        let(:result_1) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 id: "fake-category-id-1",
                                                 name: "fake-category-name-1"
                          )
          )
        end
        let(:result_2) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double( VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                  id: "fake-category-id-2",
                                                  name: "fake-category-name-2"
                          )
          )
        end
        let(:category_ids) { %w[ fake-category-id-1 fake-category-id-2 ]}

        context 'when trying to find a category that exists on vCenter' do
          let(:category_name ) { "fake-category-name-1" }
          it "should return the correct category id" do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-category-id-1").and_return(result_1)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-category-id-2").and_return(result_2)
            expect(tagging_tag.retrieve_category_id(category_name, category_ids)) .to eq("fake-category-id-1")
          end
        end

        context 'when trying to find a non-existent category on vCenter' do
          let(:category_name ) { "fake-category-name-3" }
          it 'should return nil' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-category-id-1").and_return(result_1)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-category-id-2").and_return(result_2)
            expect(tagging_tag.retrieve_category_id(category_name, category_ids)) .to eq(nil)
          end
        end
      end

      describe '#retrieve_tag_id' do
        let(:result_1) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 id: "fake-tag-id-1",
                                                 name: "fake-tag-name-1"
                          )
          )
        end
        let(:result_2) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 id: "fake-tag-id-2",
                                                 name: "fake-tag-name-2"
                          )
          )
        end
        let(:config_tag_1 ) { "fake-tag-name-1" }
        let(:config_tag_2 ) { "fake-tag-name-3" }
        let(:tag_id_list_1) { [] }
        let(:tag_id_list_2) { %w[ fake-tag-id-1 fake-tag-id-2 ] }

        context 'when received an empty tag id list' do
          it 'should return nil' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-1").and_return(result_1)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-2").and_return(result_2)
            expect(tagging_tag.retrieve_tag_id(config_tag_2, tag_id_list_1)).to eq(nil)
          end
        end

        context 'when trying to find a tag that exists on vCenter' do
          it "should return the correct category id" do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-1").and_return(result_1)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-2").and_return(result_2)
            expect(tagging_tag.retrieve_category_id(config_tag_1, tag_id_list_2)) .to eq("fake-tag-id-1")
          end
        end

        context 'when trying to find a tag that does exist on vCenter' do
          it 'should return nil' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-1").and_return(result_1)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with("fake-tag-id-2").and_return(result_2)
            expect(tagging_tag.retrieve_category_id(config_tag_2, tag_id_list_2)).to eq(nil)
          end
        end
      end

      describe '#vm_association?' do
        let(:category_information_1) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double( VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                  associable_types: []
                          )
          )
        end
        let(:category_information_2) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 associable_types: ["VirtualMachine", "Host"]
                          )
          )
        end
        let(:category_information_3) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 associable_types: ["Host"]
                          )
          )
        end
        let(:target_category_id) {"fake-category-id"}

        context 'when vm is associated with all types' do
          it 'should return true' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with(target_category_id).and_return(category_information_1)
            expect(tagging_tag.vm_association?(target_category_id)).to be(true)
          end
        end

        context 'when vm is associated with some types including virtual machine' do
          it 'should return true' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with(target_category_id).and_return(category_information_2)
            expect(tagging_tag.vm_association?(target_category_id)).to be(true)
          end
        end

        context 'when vm is associated with some types excluding virtual machine' do
          it 'should return true' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with(target_category_id).and_return(category_information_3)
            expect(tagging_tag.vm_association?(target_category_id)).to be(false)
          end
        end
      end

      describe '#valid_cat_tag' do
<<<<<<< HEAD
        let(:category_tag_hash) do
          {
              'cat1' => 'tag1',
              'cat2' => 'tag2',
              'cat3' => 'tag3',
          }
        end
=======
>>>>>>> 8cd2c977... Add Unit tests
        context 'when VC has no categories' do
          it 'should return an empty hash' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
              receive_message_chain(:list, :value).and_return([])
            expect(tagging_tag.valid_cat_tag({:a => 1, :b => 2})).to eq({})
          end
        end
        context 'when input category tag hash is empty' do
          it 'should return an empty hash' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
              receive_message_chain(:list, :value).and_return(%w[id1 id2 id3])
            expect(tagging_tag.valid_cat_tag({})).to eq({})
          end
        end
        context 'when VC has no matching categories in category tag hash' do
<<<<<<< HEAD
=======
          let(:category_tag_hash) do
            {
                'cat1' => 'tag1',
                'cat2' => 'tag2',
                'cat3' => 'tag3',
            }
          end
>>>>>>> 8cd2c977... Add Unit tests
          let(:category_ids) { %w[cat_id1 cat_id2 cat_id3] }
          it 'should return an empty hash' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
              receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).thrice.and_return(nil)
            expect(tagging_tag.valid_cat_tag(category_tag_hash)).to eq({})
          end
        end
        context 'when VC has some categories that match but none of the tags match' do
<<<<<<< HEAD
=======
          let(:category_tag_hash) do
            {
                'cat1' => 'tag1',
                'cat2' => 'tag2',
                'cat3' => 'tag3',
            }
          end
>>>>>>> 8cd2c977... Add Unit tests
          let(:category_ids) { %w[cat_id1 cat_id5 cat_id6] }
          let(:tag_id_list) { %w[tag_id4 tag_id5 tag_id6] }
          it 'should return an empty hash' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
              receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with(anything,\
              category_ids).thrice.and_return('cat_id1', nil, nil)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).to \
<<<<<<< HEAD
              receive_message_chain(:list_tags_for_category, :value).and_return(tag_id_list)
=======
              receive(:list_tags_for_category).with('cat_id1').and_return(tag_id_list)
>>>>>>> 8cd2c977... Add Unit tests
            expect(tagging_tag).to receive(:retrieve_tag_id).with('tag1',\
              tag_id_list).and_return(nil)
            expect(tagging_tag.valid_cat_tag(category_tag_hash)).to eq ({})
          end
        end
        context 'when VC has some valid category tag pairs matching pairs in input category tag hash' do
<<<<<<< HEAD
          let(:category_ids) { %w[cat_id1 cat_id5 cat_id6] }
          let(:tag_id_list) { %w[tag_id1 tag_id5 tag_id6] }
          it 'should return valid category:tag pairs' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
              receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with(anything,\
              category_ids).thrice.and_return('cat_id1', nil, nil)
            allow_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).to \
              receive_message_chain(:list_tags_for_category, :value).and_return(tag_id_list)
            expect(tagging_tag).to receive(:retrieve_tag_id).with('tag1',\
              tag_id_list).and_return('tag_id1')
            expect(tagging_tag.valid_cat_tag(category_tag_hash)).to eq ({'cat1' => 'tag1'})
          end
        end
      end

      describe '#attach_cat_tag_to_vm' do
        let(:category_tag_hash) do
          {
              'cat1' => 'tag1',
              'cat2' => 'tag2',
              'cat3' => 'tag3',
          }
        end
        let(:category_ids) { %w[cat_id1 cat_id5 cat_id6] }
        let(:tag_id_list) { %w[tag_id1 tag_id5 tag_id6] }
        context 'when tagging_category_api_list throws an error' do
          it 'should rescue and log the error' do
            expect_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
                receive_message_chain(:list, :value).and_raise(RuntimeError.new('Error encountered'))
            expect(tagging_tag).not_to receive(:retrieve_category_id)
            expect_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).not_to \
                receive(:list_tags_for_category)
            expect(tagging_tag).not_to receive(:retrieve_tag_id)
            expect_any_instance_of(VSphereAutomation::CIS::CisTaggingTagAssociationAttach).not_to \
                receive(:attach_single_tag)
            tagging_tag.attach_cat_tag_to_vm('cat1','tag1',vm_mob)
          end
        end
        context 'when retrieve_category_id function throws an error' do
          it 'should rescue and log the error' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
                receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with('cat1',\
                category_ids).and_raise(RuntimeError.new('Error encountered'))
            expect_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).not_to \
                receive(:list_tags_for_category)
            expect(tagging_tag).not_to receive(:retrieve_tag_id)
            expect_any_instance_of(VSphereAutomation::CIS::CisTaggingTagAssociationAttach).not_to \
                receive(:attach_single_tag)
            tagging_tag.attach_cat_tag_to_vm('cat1','tag1',vm_mob)
          end
        end
        context 'when list_tags_for_category function throws an error' do
          it 'should rescue and log the error' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
                receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with('cat1',\
                category_ids).and_return('cat_id1')
            expect_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).to \
                receive_message_chain(:list_tags_for_category, :value).and_raise(RuntimeError.new('Error encountered'))
            expect(tagging_tag).not_to receive(:retrieve_tag_id)
            expect_any_instance_of(VSphereAutomation::CIS::CisTaggingTagAssociationAttach).not_to \
                receive(:attach_single_tag)
            tagging_tag.attach_cat_tag_to_vm('cat1','tag1',vm_mob)
          end
        end
        context 'when retrieve_tag_id function throws an error' do
          it 'should rescue and log the error' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
                receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with('cat1',\
                category_ids).and_return('cat_id1')
            allow_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).to \
                receive_message_chain(:list_tags_for_category, :value).and_return(tag_id_list)
            expect(tagging_tag).to receive(:retrieve_tag_id).with('tag1',\
                tag_id_list).and_raise(RuntimeError.new('Error encountered'))
            expect_any_instance_of(VSphereAutomation::CIS::CisTaggingTagAssociationAttach).not_to \
                receive(:attach_single_tag)
            tagging_tag.attach_cat_tag_to_vm('cat1','tag1',vm_mob)
          end
        end
        context 'when attach_single_tag function throws an error' do
          it 'should rescue and log the error' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to \
                receive_message_chain(:list, :value).and_return(category_ids)
            expect(tagging_tag).to receive(:retrieve_category_id).with('cat1',\
                category_ids).and_return('cat_id1')
            allow_any_instance_of(VSphereAutomation::CIS::TaggingTagApi).to \
                receive_message_chain(:list_tags_for_category, :value).and_return(tag_id_list)
            expect(tagging_tag).to receive(:retrieve_tag_id).with('tag1',\
                tag_id_list).and_return('tag_id1')
            allow_any_instance_of(VSphereAutomation::CIS::CisTaggingTagAssociationAttach).to \
                receive(:attach_single_tag).with(anything, 'tag_id1').and_raise(RuntimeError.new('Error encountered'))
            tagging_tag.attach_cat_tag_to_vm('cat1','tag1',vm_mob)
          end
=======
>>>>>>> 8cd2c977... Add Unit tests
        end
      end

      describe "#create_tag_hash" do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }

        context 'when no category in category-tag pair' do
          let(:vm_config_tags){ [ { "tag" => "fake-tag-name"} ] }
          it 'should return an empty hash and raise log info' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Missing category content in cloud config , skip processing this category-tag pair.")
          end
        end

        context 'when category value is empty' do
          let(:vm_config_tags) { [ { "category" => {}, "tag" => "fake-tag-name" } ] }
          it 'should return an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Empty category in cloud config , skip processing this category-tag pair.")
          end
        end

        context 'when no tag in category-tag pair' do
          let(:vm_config_tags) { [ { "category" => "fake-category-name"} ] }
          it 'should return an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Missing tag in category 'fake-category-name', skip attaching this tag.")
          end
        end

        context 'when tag area is empty' do
          let(:vm_config_tags) { [ { "category" => "fake-category-name", "tag" => {} } ] }
          it 'should return an empty hash and raise log info' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Empty tag in category 'fake-category-name', skip attaching this tag.")
          end
        end

        context 'when category-tag pair is correct' do
          let(:vm_config_tags) { [ { "category" => "fake-category-name", "tag" => "fake-tag-name" } ] }
          it 'should return a non-empty tag hash' do
            result = tagging_tag.create_tag_hash(vm_config_tags)
            expect(result).to eq( { "fake-category-name" => [ "fake-tag-name" ] } )
            expect(log.string).to be_empty
          end
        end
      end

      describe "#attach_single_tag" do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }
        let(:tag_id) { "fake-tag-id" }
        let(:vm_mob_id) { "fake-mob-id" }

        context 'when attach a single tag to vm' do
          it 'should attach the tag successfully and return nil' do
            allow(tagging_tag).to receive_message_chain(:tag_association_api, :attach).with(tag_id, anything).and_return(nil)
            result = tagging_tag.attach_single_tag(vm_mob_id, tag_id)
            expect(result).to be_nil
            expect(log.string).to be_empty
          end
        end
      end

      describe "#attach_multi_tags" do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }
        let(:tag_ids) { %w[ fake-tag-id-1 fake-tag-id-2] }
        let(:vm_mob_id) { "fake-mob-id" }
        let(:category_name) { "fake-category-name" }
        let(:target_category_id) { "fake-category-id" }
        let(:tag_association_api) { VSphereAutomation::CIS::TaggingTagAssociationApi.new(api_client) }
        let(:multi_tag_assoc_info) { VSphereAutomation::CIS::CisTaggingTagAssociationAttachMultipleTagsToObject.new }
        let(:category_information_1) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 cardinality: "SINGLE"
                          )
          )
        end
        let (:category_information_2) do
          instance_double(VSphereAutomation::CIS::CisTaggingCategoryResult,
                          value: instance_double(VSphereAutomation::CIS::CisTaggingCategoryModel,
                                                 cardinality: "MULTIPLE"
                          )
          )
        end

        context 'when category with single cardinality' do
          it 'should return nil and raise log info' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with(target_category_id).and_return(category_information_1)
            expect do
              tagging_tag.attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
            end.to raise_error(/does not support 'Multiple Cardinality'/)
          end
        end

        context 'when category with multiple cardinality' do
          it 'should attach tags successfully and return nil' do
            allow_any_instance_of(VSphereAutomation::CIS::TaggingCategoryApi).to receive(:get).with(target_category_id).and_return(category_information_2)
            allow(tagging_tag).to receive_message_chain(:tag_association_api, :attach_multiple_tags_to_object).with(anything).and_return(nil)
            result = tagging_tag.attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
            expect(result).to be_nil
            expect(log.string).to be_empty
          end
        end
      end

      describe '#attach_tags' do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }
        let(:empty_hash_tag) { {} }
        let(:vm_mob_id) { "fake-mob-id" }
        let(:tag_id_1) { "fake-tag-id-1" }
        let(:tag_id_2) { "fake-tag-id-2" }
        let(:tag_name_1) { "fake-tag-name-1" }
        let(:tag_name_2) { "fake-tag-name-2" }
        let(:tag_name_3) { "fake-tag-name-3" }
        let(:category_id){ "fake-category-id-1" }
        let(:tag_id_list) { ["mock-tag-id-list"] }
        let(:category_name) { "fake-category-name-1" }
        let(:vm_config_name) { "fake-vm-config-name" }
        let(:vm_config_tags) { "mock-vm-config-tags" }
        let(:category_ids){ %w[ fake-category-id-1 fake-category-id-2] }
        let(:hash_tag) { { category_name => [tag_name_1, tag_name_2, tag_name_3 ] } }
        let(:hash_tag_with_dup) { { category_name => [ tag_name_1, tag_name_2, tag_name_2 ] } }

        context 'when no valid category-tag pairs in cloud config' do
          it 'should raise log info' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(empty_hash_tag)
            tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)

            expect(log.string).to include("No valid category-tag pair in cloud config")
          end
        end

        context 'when no category exists on vCenter' do
          it 'should raise log info' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return([])
            tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(log.string).to include("No category exist on vCenter, skip attaching tags.")
          end
        end

        context 'when a category does not exit on vCenter' do
          it 'should skip this category' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Unable to locate category with name '#{category_name}' on vCenter, skip attaching this category.")
          end
        end

        context 'when a category is not associated with virtual machine' do
          it 'should skip this category' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(false)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Tag category '#{category_name}' is not associated with object type: 'Virtual Machine', skip attaching this category to vm.")
          end
        end

        context 'when there are duplicated tags in a category' do
          it 'should remove duplicated tags and raise log info' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag_with_dup)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Duplicated tags found in tag category '#{category_name}', deduplicated and continue")
          end
        end

        context 'when a tag of a category does not exist on vCenter' do
          it 'should skip the tag and continue attach other tags in the category' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tagging_tag).to receive_message_chain( :tagging_tag_api, :list_tags_for_category, :value).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:attach_single_tag).with(vm_mob_id, tag_id_1).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Unable to locate tag with name '#{tag_name_2}' on vCenter, skip attaching this tag.")
            expect(log.string).to include("Unable to locate tag with name '#{tag_name_3}' on vCenter, skip attaching this tag.")
          end
        end

        context 'when category does not have any tags on vCenter' do
          it 'should skip the category and raise log info' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tagging_tag).to receive_message_chain( :tagging_tag_api, :list_tags_for_category, :value).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("None of the provided tags exist for the category '#{category_name}' on vCenter")
          end
        end

        context 'when only one tag of a category to be attached' do
          let(:hash_tag_single_tag) { { category_name => [tag_name_1 ] } }
          it 'should call the correct function and succeed' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag_single_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tagging_tag).to receive_message_chain( :tagging_tag_api, :list_tags_for_category, :value).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
          end
        end

        context 'when multiple tags of a category to be attached' do
          let(:tag_ids) { [ tag_id_1, tag_id_2 ] }
          it 'should call the correct function and succeed' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tagging_tag).to receive_message_chain( :tagging_tag_api, :list_tags_for_category, :value).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(tag_id_2)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:attach_multi_tags).with(vm_mob_id, tag_ids, category_name, category_id ).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
          end
          context 'when category is single cardinality' do
            let(:tag_ids) { [ tag_id_1, tag_id_2 ] }
            it 'should call the correct function and succeed' do
              allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
              allow(tagging_tag).to receive_message_chain(:tagging_category_api, :list, :value).and_return(category_ids)
              allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
              allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
              allow(tagging_tag).to receive_message_chain( :tagging_tag_api, :list_tags_for_category, :value).and_return(tag_id_list)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(tag_id_2)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
              allow(tagging_tag).to receive(:attach_multi_tags).with(vm_mob_id, tag_ids, category_name, category_id ).and_raise(VSphereCloud::TaggingTag::CardinalityError.new('category_id'))
              result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
              expect(result).to be(true)
              expect(log.string).to include("Cardinality Error Raised with message")
            end
          end
        end
      end
    end
  end
end