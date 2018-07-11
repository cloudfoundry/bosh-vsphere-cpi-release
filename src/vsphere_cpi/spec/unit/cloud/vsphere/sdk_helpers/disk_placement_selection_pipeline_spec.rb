require 'spec_helper'
require 'cloud/vsphere/disk_placement_selection_pipeline'
require 'cloud/vsphere/resources/datastore'

def get_fake_ds(options = {})

  options[:name] ||= 'fake-ds'
  options[:accessible] ||= true
  options[:mob] ||= nil
  options[:free_space] ||= 4096
  options[:total_space] ||= 8192

  VSphereCloud::Resources::Datastore.new(options[:name], options[:accessible], options[:mob], options[:total_space], options[:free_space])
end

describe VSphereCloud::DiskPlacementSelectionPipeline do
  subject { described_class.new(*criteria) { placement } }
  let(:placement) {[2,3,4,1,5,6,7,8]}

  context 'when placement options are a list of two datastores' do
    let(:ds_1) { get_fake_ds(name: 'ds-1', mob: instance_double('VimSdk::Vim::Datastore')) }
    let(:ds_2) { get_fake_ds(name: 'ds-2', mob: instance_double('VimSdk::Vim::Datastore')) }
    let(:criteria) {[512, 'ds-*']}
    let(:placement) {[ds_1, ds_2]}
    before do
      allow(ds_1).to receive(:maintenance_mode?).and_return (false)
      allow(ds_2).to receive(:maintenance_mode?).and_return (false)
      allow(ds_1).to receive(:accessible?).and_return (true)
      allow(ds_2).to receive(:accessible?).and_return (true)
    end
    context 'when  one of the datastores is in maintenance mode and other is not' do
      before do
        allow(ds_2).to receive(:maintenance_mode?).and_return (true)
      end
      it 'returns the datastore which is not in maintenance mode' do
        filtered_placements = []
        subject.each do |x|
          filtered_placements << x
        end
        expect(filtered_placements).to eq([ds_1])
      end
    end

    context 'when  one of the datastores is accessible other is not' do
      before do
        allow(ds_2).to receive(:accessible?).and_return (false)
      end
      it 'returns the datastore which is accessible' do
        filtered_placements = subject.map {|x| x}
        expect(filtered_placements).to eq([ds_1])
      end
    end

    context 'when  one of the datastores matches target pattern and other one does not' do
      before do
        ds_2.name = 'not-match'
      end
      it "returns the datastore which matches target datastore pattern" do
        filtered_placements = subject.map {|x| x}
        expect(filtered_placements).to eq([ds_1])
      end
    end

    context 'when  one of the datastores has enough free space and other one does not have' do
      before do
        ds_1.free_space = 0
      end
      it 'returns the datastore which has enough free space' do
        filtered_placements = subject.map {|x| x}
        expect(filtered_placements).to eq([ds_2])
      end
    end

    context 'when both datastore satisfy all criteria' do
      it 'returns both the datastores' do
        filtered_placements = subject.map {|x| x}
        expect(filtered_placements).to match_array([ds_1, ds_2])
      end
    end
  end
end