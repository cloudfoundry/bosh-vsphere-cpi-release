require 'spec_helper'
require 'timecop'

describe VSphereCloud::DrsLock, fake_logger: true do
  subject(:drs_lock) { described_class.new(vm_attribute_manager, drs_lock_suffix) }
  let(:drs_lock_suffix) {''}
  let(:vm_attribute_manager) { instance_double('VSphereCloud::VMAttributeManager') }

  context 'when drs lock exists' do
    context 'when lock is released within timeout' do
      it 'creates drs lock' do
        original_time = Time.now
        Timecop.freeze(original_time)

        expect(vm_attribute_manager).to receive(:create).with('drs_lock') do
          Timecop.freeze(original_time + 5)
          raise VimSdk::SoapError.new('field already exists', false)
        end

        expect(vm_attribute_manager).to receive(:create).with('drs_lock')

        expect(vm_attribute_manager).to receive(:delete).with('drs_lock')

        drs_lock.with_drs_lock {}
      end
    end

    context 'when lock is not released within timeout' do
      it 'fails with timeout error' do
        original_time = Time.now
        Timecop.freeze(original_time)
        expect(vm_attribute_manager).to receive(:create).with('drs_lock') do
          Timecop.freeze(original_time + 31)
          raise VimSdk::SoapError.new('field already exists', false)
        end

        expect(vm_attribute_manager).to_not receive(:delete)
        expect {
          drs_lock.with_drs_lock {}
        }.to raise_error VSphereCloud::DrsLock::LockError
      end
    end
  end

  context 'when lock does not exist' do
    it 'creates DRS lock' do
      expect(vm_attribute_manager).to receive(:create).with('drs_lock')
      expect(vm_attribute_manager).to receive(:delete).with('drs_lock')

      drs_lock.with_drs_lock {}
    end

    context 'and drs_lock_suffix is present' do
      let(:drs_lock_suffix) { '_suffix' }
      it 'creates DRS lock with the suffix' do
        expect(vm_attribute_manager).to receive(:create).with('drs_lock_suffix')
        expect(vm_attribute_manager).to receive(:delete).with('drs_lock_suffix')

        drs_lock.with_drs_lock {}
      end
    end

    context 'when block fails' do
      it 'deletes the lock' do
        expect(vm_attribute_manager).to receive(:create).with('drs_lock')
        expect(vm_attribute_manager).to receive(:delete).with('drs_lock')

        expect do
          drs_lock.with_drs_lock do
            raise 'Failed block'
          end
        end.to raise_error 'Failed block'
      end
    end
  end
end
