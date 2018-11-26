require 'spec_helper'
require 'cloud/vsphere/disk_placement_selection_pipeline'
require 'cloud/vsphere/resources/datastore'

describe VSphereCloud::DiskPlacementSelectionPipeline do
  subject { described_class.new(*criteria) { [ds_1, ds_2, ds_3] } }

  def fake_datastore(name, free_space: 4096)
    VSphereCloud::Resources::Datastore.new(
      name, instance_double('VimSdk::Vim::Datastore'), true, 8192, free_space
    ).tap do |resource|
      allow(resource).to receive(:maintenance_mode?).and_return(false)
      allow(resource).to receive(:accessible?).and_return(true)
    end
  end

  let(:criteria) { [512, 'fake-.*'] }
  let(:ds_1) { fake_datastore('fake-1') }
  let(:ds_2) { fake_datastore('fake-2') }
  let(:ds_3) { VSphereCloud::Resources::Datastore.new('not-a-match', instance_double('VimSdk::Vim::Datastore'), true, 8192, 2056)  }

  before do(:all)
    allow(ds_3).to receive(:maintenance_mode?).and_return(false)
  end

  it "only generates datastores that aren't in maintenance mode" do
    allow(ds_2).to receive(:maintenance_mode?).and_return(true)
    expect(subject.to_a).to contain_exactly(ds_1)
  end

  it 'should not check datastores for accessibility' do
    allow(ds_2).to receive(:accessible?).and_return(false)
    expect(subject.to_a).to match_array([ds_1, ds_2])
  end

  it 'only generates datastores matching the target pattern' do
    allow(ds_2).to receive(:name).and_return('not-match')
    expect(subject.to_a).to contain_exactly(ds_1)
  end

  context 'when filtering on free space' do
    context 'when criteria is specified for a persistent disk' do
      it 'only generates datastores with enough free space' do
        allow(ds_1).to receive(:free_space).and_return(0)
        expect(subject.to_a).to contain_exactly(ds_2)
      end
    end
    context 'when criteria is specified for an ephemeral disk' do
      let(:criteria) { [512, 'fake-.*', nil, true, 512] }
      it 'only generates datastores with enough free space' do
        allow(ds_1).to receive(:free_space).and_return(2047)
        expect(subject.to_a).to contain_exactly(ds_2)
      end
    end
  end

  context 'when both datastore satisfy all criteria' do
    context 'when the randomization is set to zero' do
      # Mocking out stable random to a constant 1 to ensure algorithm scores
      # datastores in descending order of free space.
      module VSphereCloud::SelectionPipeline::StableRandom
        def self.[](object)
          1
        end
      end
      let(:ds_1) { fake_datastore('fake-1', free_space: 4096) }
      let(:ds_2) { fake_datastore('fake-2', free_space: 8192) }
      it 'returns the array of datastores sorted in reverse order of available free space' do
        filtered_placements = subject.map {|x| x}
        expect(filtered_placements).to eq([ds_2, ds_1])
      end
    end
  end
end