require 'spec_helper'

describe 'RetryJudge' do
  subject(:retry_judge) { VSphereCloud::SdkHelpers::RetryJudge.new }
  let(:unknown_error) { instance_double(VimSdk::Vim::Fault) }

  it 'should allow unfamiliar calls to be retryable' do
    expect(retry_judge.retryable?('some-class', 'some-method', unknown_error)).to be(true), "Expected 'some-klass.some-method' to be retryable, but it's not."
  end

  it 'should not let blacklisted methods be retryable' do
    klass = VimSdk::Vim::VirtualDiskManager
    method = 'MoveVirtualDisk_Task'
    entity = instance_double(klass, class: klass)

    expect(retry_judge.retryable?(entity, method, unknown_error)).to be(false), "Expected '#{klass.to_s}.#{method}' to not be retryable, but it was."
  end

  it 'should not let blacklisted faults be retryable' do
    fault = VimSdk::Vim::Fault::DuplicateName.new
    expect(retry_judge.retryable?('some-class', 'some-method', fault)).to be(false), "Expected '#{fault.class}' to not be retryable, but it was."
  end

  it 'should let methods that satisfy some criteria, but not all be retryable' do
    klass = VimSdk::Vim::VirtualDiskManager
    method = 'PowerOnVM_Task'
    entity = instance_double(klass, class: klass)

    expect(retry_judge.retryable?(entity, method, unknown_error)).to be(true), "Expected '#{klass.to_s}.#{method}' to be retryable, but it was not."
  end

  it 'should blacklist methods that actually exist' do
    expect(VSphereCloud::SdkHelpers::RetryJudge::NON_RETRYABLE_CRITERIA).to_not be_empty
    VSphereCloud::SdkHelpers::RetryJudge::NON_RETRYABLE_CRITERIA.each do |criterion|
      klass = criterion[:entity_class]
      method_name = criterion[:method_name]
      unless method_name && klass
        next
      end

      wsdl_method_names = klass.managed_methods.map { |m| m.wsdl_name }
      expect(wsdl_method_names).to include(method_name)
    end
  end
end
