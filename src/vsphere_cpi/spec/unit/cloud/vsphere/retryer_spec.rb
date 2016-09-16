require 'spec_helper'

module VSphereCloud
  describe Retryer do
    subject(:retryer) { Retryer.new() }
    let(:result) { 'fake-result' }

    it 'should retry a failing block as much as it can' do
      expect(retryer).to receive(:sleep).exactly(VSphereCloud::Retryer::MAX_TRIES - 1).times
      expect do
        retryer.try do
          [result, 'fake-error']
        end
      end.to raise_error(/fake-error/)
    end

    it 'should try a successful block only once' do
      expect(retryer).not_to receive(:sleep)
      value = retryer.try do
        [result, nil]
      end
      expect(value).to eq(result)
    end

    it 'should pass the iteration count to the block' do
      expect(retryer).to receive(:sleep).exactly(VSphereCloud::Retryer::MAX_TRIES - 1).times
      call_count = 0
      expect do
        retryer.try do |i|
          expect(i).to eq(call_count)
          call_count += 1
          [result, 'fake-error']
        end
      end.to raise_error(/fake-error/)
    end

    it 'should return if it succeeds before it runs out of attempts' do
      expect(retryer).to receive(:sleep).exactly(VSphereCloud::Retryer::MAX_TRIES - 1).times
      i = 0
      value = retryer.try do
        i += 1
        if i < VSphereCloud::Retryer::MAX_TRIES
          [nil, 'fake-error']
        else
          [result, nil]
        end
      end
      expect(value).to eq(result)
    end

    it 'should double the wait time each iteration' do
      expect(retryer).to receive(:sleep).with(1)
      expect(retryer).to receive(:sleep).with(2)
      expect(retryer).to receive(:sleep).with(4)
      expect(retryer).to receive(:sleep).with(8)
      expect(retryer).to receive(:sleep).with(16)
      expect do
        retryer.try do
          [result, 'fake-error']
        end
      end.to raise_error(/fake-error/)
    end
  end
end
