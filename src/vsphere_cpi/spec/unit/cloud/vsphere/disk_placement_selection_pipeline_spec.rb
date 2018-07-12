require 'spec_helper'
require 'cloud/vsphere/disk_placement_selection_pipeline'
require 'cloud/vsphere/resources/datastore'

describe VSphereCloud::DiskPlacementSelectionPipeline do
  subject { described_class.new(*criteria) { [ds_1, ds_2] } }

  def fake_datastore(name, free_space: 4096)
    VSphereCloud::Resources::Datastore.new(
      name, true, instance_double('VimSdk::Vim::Datastore'), 8192, free_space
    ).tap do |resource|
      allow(resource).to receive(:maintenance_mode?).and_return(false)
      allow(resource).to receive(:accessible?).and_return(true)
    end
  end

  let(:criteria) { [512, 'fake-.*'] }
  let(:ds_1) { fake_datastore('fake-1') }
  let(:ds_2) { fake_datastore('fake-2') }

  it "only generates datastores that aren't in maintenance mode" do
    allow(ds_2).to receive(:maintenance_mode?).and_return(true)
    expect(subject.to_a).to contain_exactly(ds_1)
  end

  it 'only generates accessible datastores' do
    allow(ds_2).to receive(:accessible?).and_return(false)
    expect(subject.to_a).to contain_exactly(ds_1)
  end

  it 'only generates datastores matching the target pattern' do
    allow(ds_2).to receive(:name).and_return('not-match')
    expect(subject.to_a).to contain_exactly(ds_1)
  end

  it 'only generates datastores with enough free space' do
    allow(ds_1).to receive(:free_space).and_return(0)
    expect(subject.to_a).to contain_exactly(ds_2)
  end

  context 'when both datastore satisfy all criteria' do
    it 'returns both the datastores' do
      filtered_placements = subject.map {|x| x}
      expect(filtered_placements).to match_array([ds_1, ds_2])
    end
  end
end