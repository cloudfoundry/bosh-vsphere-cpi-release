require 'spec_helper'

module VSphereCloud
  describe VSphereCloud::DeviceKeyGenerator, fake_logger: true do
    subject { described_class }

    describe '#init' do
      context 'when no device keys are passed' do
        it 'initializes the memo with empty set passed and seeds it with -1' do
          subject.instance.init(nil)
          expect(subject.instance.instance_variable_get(:@memo)).to be_empty
          expect(subject.instance.instance_variable_get(:@seed)).to eq(-1)
        end
      end
      it 'initializes the memo with keys passed and seeds it with -1' do
        subject.instance.init([1,2,3])
        expect(subject.instance.instance_variable_get(:@memo)).to eq(Set.new([1,2,3]))
        expect(subject.instance.instance_variable_get(:@seed)).to eq(-1)

      end
    end

    describe '#get_device_key' do
      context 'when no device keys are passed to init' do
        it 'initializes the memo with empty set passed and seeds it with -1' do
          subject.instance.init()
          expect(subject.instance.device_key).to eq(-1)
          expect(subject.instance.device_key).to eq(-2)
          expect(subject.instance.device_key).to eq(-3)
        end
      end
      it 'returns the keys not present in memo' do
        subject.instance.init([-2, -3])
        expect(subject.instance.device_key).to eq(-1)
        expect(subject.instance.device_key).to eq(-4)
        expect(subject.instance.device_key).to eq(-5)
      end
    end
  end
end
