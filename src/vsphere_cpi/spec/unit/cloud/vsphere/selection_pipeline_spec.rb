require 'spec_helper'
require 'cloud/vsphere/selection_pipeline'

describe VSphereCloud::SelectionPipeline do
  subject { described_class.new(criteria) { placement } }
  let(:criteria) { :fake_criteria }
  let(:placement) {['fake-placement']}

  describe '#initialize' do
    it 'raises an ArgumentError when no block is given' do
      expect do
        described_class.new('fake-object')
      end.to raise_error(ArgumentError)
    end
  end

  describe '#accept' do
    it 'returns true when the filter list is empty' do
      expect(subject.accept?(:fake)).to be(true)
    end

    it 'calls each filter on the placement until a filter returns false' do
      filter_1 = double
      expect(filter_1).to receive(:call).with(:fake, criteria).and_return(true)
      subject.with_filter(filter_1)

      filter_2 = double
      expect(filter_2).to receive(:call).with(:fake, criteria).and_return(true)
      subject.with_filter(filter_2)

      filter_3 = double
      expect(filter_3).to receive(:call).with(:fake, criteria).and_return(false)
      subject.with_filter(filter_3)

      filter_4 = double
      expect(filter_4).not_to receive(:call)
      subject.with_filter(filter_4)

      subject.accept?(:fake)
    end

    it 'returns true when all filters return true' do
      subject.with_filter { true }
      subject.with_filter { true }
      expect(subject.accept?(:fake)).to be(true)
    end

    it 'returns false when any filter returns false' do
      subject.with_filter { false }
      subject.with_filter { true }
      expect(subject.accept?(:fake)).to be(false)
    end
  end

  describe '#with_filter' do
    it 'returns ArgumentError when block is not given and args are empty' do
      expect do
        subject.with_filter
      end.to raise_error(ArgumentError)
    end

    it 'returns error if block is given with args' do
      expect do
        subject.with_filter('fake-args') do
          'Dummy-Filter Block'
        end
      end.to raise_error(ArgumentError)
    end

    it 'adds to filter_list when just args are given' do
      subject.with_filter('fake-arg-1', 'fake-arg-2')
      expect(subject.instance_variable_get(:@filter_list)).to eq(['fake-arg-1', 'fake-arg-2'])
    end

    it 'adds to filter list a new Proc when just a block is given' do
      subject.with_filter do
        'fake-block-filter'
      end
      expect(subject.instance_variable_get(:@filter_list).length).to eq(1)
      expect(subject.instance_variable_get(:@filter_list).first).to be_an_instance_of(Proc)
    end

    it 'returns self' do
      returned_obj = subject.with_filter('fake-arg-1', 'fake-arg-2')
      expect(returned_obj).to eq(subject)
    end
  end

  describe '#with_scorer' do
    it 'returns ArgumentError when block is not given and args are empty' do
      expect do
        subject.with_scorer
      end.to raise_error(ArgumentError)
    end

    it 'returns error if block is given with args' do
      expect do
        subject.with_scorer('fake-args') do
          'Dummy-Filter Block'
        end
      end.to raise_error(ArgumentError)
    end

    it 'adds to filter_list when just args are given' do
      subject.with_scorer('fake-arg-1', 'fake-arg-2')
      expect(subject.instance_variable_get(:@scorer_list)).to eql(['fake-arg-1', 'fake-arg-2'])
    end

    it 'adds to filter list a new Proc when just a block is given' do
      subject.with_scorer do
        'fake-block-filter'
      end
      expect(subject.instance_variable_get(:@scorer_list).length).to eql(1)
      expect(subject.instance_variable_get(:@scorer_list).first).to be_an_instance_of(Proc)
    end

    it 'returns self' do
      returned_obj = subject.with_scorer('fake-arg-1', 'fake-arg-2')
      expect(returned_obj).to eq(subject)
    end
  end

  describe '#each' do
    let(:placement) {[2,3,4,1,5,6,7,8]}

    it 'returns an Enumerator if block is not given' do
      expect(subject.each).to be_an_instance_of(Enumerator)
    end

    it 'returns list of all placements when there are no filters or scorers' do
      # map will call each
      got_placements = subject.map do |x|
        x
      end
      expect(got_placements).to match_array(placement)
    end

    it 'returns a sorted list of placements(integer) if scorer is defined to be Integer comparer' do
      subject.with_scorer do |p1, p2|
        p1 <=> p2
      end
      got_placements = subject.map do |x|
        x
      end
      expect(got_placements).to eq(placement.sort)
    end

    it 'returns a sorted list of even placements(integer) if scorer is defined to be Integer comparer and filter selects even numbers' do
      subject.with_scorer do |p1, p2|
        p1 <=> p2
      end
      subject.with_filter do |p1|
        p1.even?
      end
      got_placements = subject.map do |x|
        x
      end
      expect(got_placements).to eq(placement.select{|x| x.even?}.sort)
    end
  end
end