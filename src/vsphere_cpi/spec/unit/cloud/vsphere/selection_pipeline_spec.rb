require 'spec_helper'
require 'cloud/vsphere/selection_pipeline'

describe VSphereCloud::SelectionPipeline do
  subject { described_class.new(criteria) { placement } }
  let(:criteria) { :fake_criteria }
  let(:placement) { [:fake_placement] }

  class Integer
    def inspect
      ""
    end
    alias inspect_before inspect
  end

  describe '#initialize' do
    it 'raises an ArgumentError when no block is given' do
      expect do
        described_class.new('fake-criteria')
      end.to raise_error(ArgumentError)
    end
  end

  describe '#accept' do
    it 'returns true when the filter list is empty' do
      expect(subject.accept?(:fake)).to be(true)
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
  end

  describe '#with_filter' do
    it 'returns self' do
      expect(subject.with_filter(:fake)).to be(subject)
    end

    context 'with no block' do
      it 'raises an ArgumentError when no arguments are given' do
        expect { subject.with_filter }.to raise_error(ArgumentError)
      end

      it 'adds each argument as a filter' do
        subject.with_filter(:fake_1, :fake_2)
        expect(subject.send(:filter_list)).to include(:fake_1, :fake_2)
      end
    end

    context 'with a block' do
      it 'raises an ArgumentError when arguments are given' do
        expect do
          subject.with_filter(:fake) {}
        end.to raise_error(ArgumentError)
      end

      it 'adds the block as a filter' do
        sentinel = proc {}
        subject.with_filter(&sentinel)
        expect(subject.send(:filter_list)).to include(sentinel)
      end
    end
  end

  describe '#with_scorer' do
    it 'returns self' do
      expect(subject.with_scorer(:fake)).to be(subject)
    end

    context 'with no block' do
      it 'raises an ArgumentError when no arguments are given' do
        expect { subject.with_scorer }.to raise_error(ArgumentError)
      end

      it 'adds each argument as a scorer' do
        subject.with_scorer(:fake_1, :fake_2)
        expect(subject.send(:scorer_list)).to include(:fake_1, :fake_2)
      end
    end

    context 'with a block' do
      it 'raises an ArgumentError when arguments are given' do
        expect do
          subject.with_scorer(:fake) {}
        end.to raise_error(ArgumentError)
      end

      it 'adds the block as a scorer' do
        sentinel = proc {}
        subject.with_scorer(&sentinel)
        expect(subject.send(:scorer_list)).to include(sentinel)
      end
    end
  end

  describe '#each' do
    let(:placement) { [2, 3, 4, 1, 5, 6, 7, 8] }

    it 'returns an Enumerator when no block is given' do
      expect(subject.each).to be_an(Enumerator)
    end

    it 'generates all placements when there are no filters or scorers' do
      # Enumerable#to_a will call #each
      expect(subject.to_a).to match_array(placement)
    end

    it 'yields with placements filtered on its filter list' do
      subject.with_filter { |p1| p1.even? }
      subject.with_filter { |p1| p1 > 2 }
      answer = placement.select { |n| n.even? && n > 2 }.reverse

      expect do |b|
        subject.each(&b)
      end.to yield_successive_args(*answer)
    end

    it 'yields with placements sorted with its scorer list' do
      subject.with_scorer { |p1, p2| p1 <=> p2 }
      answer = placement.sort.reverse

      expect do |b|
        subject.each(&b)
      end.to yield_successive_args(*answer)
    end

    it 'yields with filtered and sorted placements' do
      subject.with_filter { |p1| p1.even? }
      subject.with_filter { |p1| p1 > 2 }
      subject.with_scorer { |p1, p2| p1 <=> p2 }
      answer = placement.select{ |n| n.even? && n > 2 }.sort.reverse

      expect do |b|
        subject.each(&b)
      end.to yield_successive_args(*answer)
    end
  end
end