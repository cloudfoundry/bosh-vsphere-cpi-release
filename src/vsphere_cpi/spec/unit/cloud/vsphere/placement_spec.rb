require 'spec_helper'

describe VSphereCloud::Placement do
  subject do
    described_class.new(resource)
  end

  let(:other) do
    described_class.new(resource)
  end

  let(:resource) do
    instance_double('VSphereCloud::Resources::Datastore')
  end

  describe '#resource' do
    it('returns the resource') { expect(subject.resource).to eq(resource) }
  end

  describe '#score' do
    it('returns the score') { expect(subject.score).to eq(0) }
  end

  describe '#inspect' do
    it ('raises an error') {expect{subject.inspect}.to raise_error NotImplementedError}
  end

  describe '#eql' do
    context 'when we use other object with same resource and same score' do
      it ('returns true') { expect(subject.eql?(other)).to eq(true)}
    end
  end
end


describe VSphereCloud::StoragePlacement do
  subject do
    described_class.new(resource)
  end

  let(:other) do
    described_class.new(resource)
  end

  let(:resource) do
    VSphereCloud::Resources::Datastore.new("fake-ds", mob, true, 16 * 1024, 8 * 1024)
  end

  let(:mob) do
    instance_double('VimSdk::Vim::Datastore')
  end

  before do
    allow(mob).to receive_message_chain(:summary, :maintenance_mode).and_return("normal")
  end

  describe '#name' do
    it('returns the name of the resource') { expect(subject.name).to eq("fake-ds") }
  end

  describe '#free_space' do
    it('returns the free space') { expect(subject.free_space).to eq(8192) }
  end

  describe '#maintenance_mode' do
    it ('returns the maintenance mode of resource') {expect(subject.maintenance_mode).to eql("normal")}
  end

  context 'when initialized with a resource type different from storage pod and datastore' do
    let(:wrong_resource) do
      VSphereCloud::Resources::Disk.new(2,nil,nil,nil)
    end
    it 'raises type error' do
      expect{described_class.new(wrong_resource)}.to raise_error TypeError
    end
  end
end


