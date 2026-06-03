require 'spec_helper'
require 'stringio'

module VSphereCloud
  module TaggingTag
    describe AttachTagToVm, fake_logger: true do
      let(:tag_client) { instance_double(TaggingTag::TagClient) }
      subject(:tagging_tag) { TaggingTag::AttachTagToVm.new(tag_client) }

      describe '#retrieve_category_id' do
        let(:category_1) { { 'id' => 'fake-category-id-1', 'name' => 'fake-category-name-1' } }
        let(:category_2) { { 'id' => 'fake-category-id-2', 'name' => 'fake-category-name-2' } }
        let(:category_ids) { %w[fake-category-id-1 fake-category-id-2] }

        before do
          allow(tag_client).to receive(:get_category).with('fake-category-id-1').and_return(category_1)
          allow(tag_client).to receive(:get_category).with('fake-category-id-2').and_return(category_2)
        end

        context 'when trying to find a category that exists on vCenter' do
          it 'returns the correct category id' do
            expect(tagging_tag.retrieve_category_id('fake-category-name-1', category_ids)).to eq('fake-category-id-1')
          end
        end

        context 'when trying to find a non-existent category on vCenter' do
          it 'returns nil' do
            expect(tagging_tag.retrieve_category_id('fake-category-name-3', category_ids)).to be_nil
          end
        end
      end

      describe '#retrieve_tag_id' do
        let(:tag_1) { { 'id' => 'fake-tag-id-1', 'name' => 'fake-tag-name-1' } }
        let(:tag_2) { { 'id' => 'fake-tag-id-2', 'name' => 'fake-tag-name-2' } }
        let(:tag_id_list_empty) { [] }
        let(:tag_id_list) { %w[fake-tag-id-1 fake-tag-id-2] }

        before do
          allow(tag_client).to receive(:get_tag).with('fake-tag-id-1').and_return(tag_1)
          allow(tag_client).to receive(:get_tag).with('fake-tag-id-2').and_return(tag_2)
        end

        context 'when received an empty tag id list' do
          it 'returns nil' do
            expect(tagging_tag.retrieve_tag_id('fake-tag-name-3', tag_id_list_empty)).to be_nil
          end
        end

        context 'when trying to find a tag that exists on vCenter' do
          it 'returns the correct tag id' do
            expect(tagging_tag.retrieve_tag_id('fake-tag-name-1', tag_id_list)).to eq('fake-tag-id-1')
          end
        end

        context 'when trying to find a tag that does not exist on vCenter' do
          it 'returns nil' do
            expect(tagging_tag.retrieve_tag_id('fake-tag-name-3', tag_id_list)).to be_nil
          end
        end
      end

      describe '#vm_association?' do
        let(:target_category_id) { 'fake-category-id' }

        context 'when associable_types is empty (i.e. all types are allowed)' do
          before { allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'associable_types' => [] }) }
          it 'returns true' do
            expect(tagging_tag.vm_association?(target_category_id)).to be(true)
          end
        end

        context 'when associable_types is nil' do
          before { allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'associable_types' => nil }) }
          it 'still returns true (treats nil as unconstrained)' do
            expect(tagging_tag.vm_association?(target_category_id)).to be(true)
          end
        end

        context 'when associable_types includes VirtualMachine' do
          before { allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'associable_types' => %w[VirtualMachine Host] }) }
          it 'returns true' do
            expect(tagging_tag.vm_association?(target_category_id)).to be(true)
          end
        end

        context 'when associable_types excludes VirtualMachine' do
          before { allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'associable_types' => ['Host'] }) }
          it 'returns false' do
            expect(tagging_tag.vm_association?(target_category_id)).to be(false)
          end
        end
      end

      describe '#create_tag_hash' do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }

        context 'when no category in category-tag pair' do
          let(:vm_config_tags) { [{ 'tag' => 'fake-tag-name' }] }
          it 'returns an empty hash and logs the issue' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include('Missing category content in cloud config , skip processing this category-tag pair.')
          end
        end

        context 'when category value is empty' do
          let(:vm_config_tags) { [{ 'category' => {}, 'tag' => 'fake-tag-name' }] }
          it 'returns an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include('Empty category in cloud config , skip processing this category-tag pair.')
          end
        end

        context 'when category value is whitespace' do
          let(:vm_config_tags) { [{ 'category' => '   ', 'tag' => 'fake-tag-name' }] }
          it 'returns an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include('Empty category in cloud config , skip processing this category-tag pair.')
          end
        end

        context 'when no tag in category-tag pair' do
          let(:vm_config_tags) { [{ 'category' => 'fake-category-name' }] }
          it 'returns an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Missing tag in category 'fake-category-name', skip attaching this tag.")
          end
        end

        context 'when tag value is empty' do
          let(:vm_config_tags) { [{ 'category' => 'fake-category-name', 'tag' => {} }] }
          it 'returns an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Empty tag in category 'fake-category-name', skip attaching this tag.")
          end
        end

        context 'when tag value is whitespace' do
          let(:vm_config_tags) { [{ 'category' => 'fake-category-name', 'tag' => '   ' }] }
          it 'returns an empty hash' do
            expect(tagging_tag.create_tag_hash(vm_config_tags)).to be_empty
            expect(log.string).to include("Empty tag in category 'fake-category-name', skip attaching this tag.")
          end
        end

        context 'when category-tag pair is correct' do
          let(:vm_config_tags) { [{ 'category' => 'fake-category-name', 'tag' => 'fake-tag-name' }] }
          it 'returns a non-empty tag hash' do
            result = tagging_tag.create_tag_hash(vm_config_tags)
            expect(result).to eq({ 'fake-category-name' => ['fake-tag-name'] })
            expect(log.string).to be_empty
          end
        end
      end

      describe '#attach_single_tag' do
        let(:tag_id) { 'fake-tag-id' }
        let(:vm_mob_id) { 'fake-mob-id' }

        it 'delegates to TagClient#attach_tag' do
          expect(tag_client).to receive(:attach_tag).with(tag_id, vm_mob_id).and_return(nil)
          expect(tagging_tag.attach_single_tag(vm_mob_id, tag_id)).to be_nil
        end
      end

      describe '#attach_multi_tags' do
        let(:tag_ids) { %w[fake-tag-id-1 fake-tag-id-2] }
        let(:vm_mob_id) { 'fake-mob-id' }
        let(:category_name) { 'fake-category-name' }
        let(:target_category_id) { 'fake-category-id' }

        context 'when category has single cardinality' do
          before do
            allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'cardinality' => 'SINGLE' })
          end
          it 'raises CardinalityError' do
            expect {
              tagging_tag.attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)
            }.to raise_error(/does not support 'Multiple Cardinality'/)
          end
        end

        context 'when category has multiple cardinality' do
          before do
            allow(tag_client).to receive(:get_category).with(target_category_id).and_return({ 'cardinality' => 'MULTIPLE' })
          end
          it 'delegates to TagClient#attach_multiple_tags_to_object' do
            expect(tag_client).to receive(:attach_multiple_tags_to_object).with(tag_ids, vm_mob_id).and_return(nil)
            expect(tagging_tag.attach_multi_tags(vm_mob_id, tag_ids, category_name, target_category_id)).to be_nil
          end
        end
      end

      describe '#attach_tags' do
        let(:log) { StringIO.new('') }
        let(:logger) { Bosh::Cpi::Logger.new(log) }
        let(:empty_hash_tag) { {} }
        let(:vm_mob_id) { 'fake-mob-id' }
        let(:tag_id_1) { 'fake-tag-id-1' }
        let(:tag_id_2) { 'fake-tag-id-2' }
        let(:tag_name_1) { 'fake-tag-name-1' }
        let(:tag_name_2) { 'fake-tag-name-2' }
        let(:tag_name_3) { 'fake-tag-name-3' }
        let(:category_id) { 'fake-category-id-1' }
        let(:tag_id_list) { ['mock-tag-id-list'] }
        let(:category_name) { 'fake-category-name-1' }
        let(:vm_config_name) { 'fake-vm-config-name' }
        let(:vm_config_tags) { 'mock-vm-config-tags' }
        let(:category_ids) { %w[fake-category-id-1 fake-category-id-2] }
        let(:hash_tag) { { category_name => [tag_name_1, tag_name_2, tag_name_3] } }
        let(:hash_tag_with_dup) { { category_name => [tag_name_1, tag_name_2, tag_name_2] } }

        context 'when no valid category-tag pairs in cloud config' do
          it 'logs and returns' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(empty_hash_tag)
            tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)

            expect(log.string).to include('No valid category-tag pair in cloud config')
          end
        end

        context 'when no category exists on vCenter' do
          it 'logs the error' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return([])
            tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(log.string).to include('No category exist on vCenter, skip attaching tags.')
          end
        end

        context 'when a category does not exist on vCenter' do
          it 'skips this category' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Unable to locate category with name '#{category_name}' on vCenter, skip attaching this category.")
          end
        end

        context 'when a category is not associated with virtual machine' do
          it 'skips this category' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(false)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Tag category '#{category_name}' is not associated with object type: 'Virtual Machine', skip attaching this category to vm.")
          end
        end

        context 'when there are duplicated tags in a category' do
          it 'removes duplicated tags and logs the warning' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag_with_dup)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tag_client).to receive(:list_tags_for_category).with(category_id).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(tag_id_2)
            expect(tag_client).to receive(:attach_multiple_tags_to_object).with([tag_id_1, tag_id_2], vm_mob_id).and_return(nil)
            allow(tag_client).to receive(:get_category).and_return({ 'cardinality' => 'MULTIPLE' })
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("Duplicated tags found in tag category '#{category_name}', deduplicated and continue")
          end
        end

        context 'when a tag of a category does not exist on vCenter' do
          it 'skips the missing tags and continues' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tag_client).to receive(:list_tags_for_category).and_return(tag_id_list)
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

        context 'when category does not have any matching tags on vCenter' do
          it 'logs the error' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tag_client).to receive(:list_tags_for_category).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(nil)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
            expect(log.string).to include("None of the provided tags exist for the category '#{category_name}' on vCenter")
          end
        end

        context 'when only one tag of a category to be attached' do
          let(:hash_tag_single_tag) { { category_name => [tag_name_1] } }
          it 'attaches a single tag' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag_single_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tag_client).to receive(:list_tags_for_category).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            expect(tagging_tag).to receive(:attach_single_tag).with(vm_mob_id, tag_id_1).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
          end
        end

        context 'when multiple tags of a category to be attached' do
          let(:tag_ids) { [tag_id_1, tag_id_2] }
          it 'delegates to attach_multi_tags' do
            allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
            allow(tag_client).to receive(:list_categories).and_return(category_ids)
            allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
            allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
            allow(tag_client).to receive(:list_tags_for_category).and_return(tag_id_list)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(tag_id_2)
            allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
            expect(tagging_tag).to receive(:attach_multi_tags).with(vm_mob_id, tag_ids, category_name, category_id).and_return(nil)
            result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
            expect(result).to be(true)
          end

          context 'when category is single cardinality' do
            let(:tag_ids) { [tag_id_1, tag_id_2] }
            it 'logs the cardinality error and continues' do
              allow(tagging_tag).to receive(:create_tag_hash).with(anything).and_return(hash_tag)
              allow(tag_client).to receive(:list_categories).and_return(category_ids)
              allow(tagging_tag).to receive(:retrieve_category_id).with(category_name, category_ids).and_return(category_id)
              allow(tagging_tag).to receive(:vm_association?).with(category_id).and_return(true)
              allow(tag_client).to receive(:list_tags_for_category).and_return(tag_id_list)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_1, tag_id_list).and_return(tag_id_1)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_2, tag_id_list).and_return(tag_id_2)
              allow(tagging_tag).to receive(:retrieve_tag_id).with(tag_name_3, tag_id_list).and_return(nil)
              allow(tagging_tag).to receive(:attach_multi_tags).with(vm_mob_id, tag_ids, category_name, category_id).and_raise(VSphereCloud::TaggingTag::CardinalityError.new(category_name))
              result = tagging_tag.attach_tags(vm_mob_id, vm_config_tags, vm_config_name)
              expect(result).to be(true)
              expect(log.string).to include('Cardinality Error Raised with message')
            end
          end
        end
      end
    end
  end
end
