require 'spec_helper'
require 'ruby_vim_sdk'

describe 'RetryableStubAdapter' do
  subject(:retryable_stub_adapter) do
    VSphereCloud::SdkHelpers::RetryableStubAdapter.new(stub_adapter, logger, retry_judge, retryer)
  end

  let(:stub_adapter) { instance_double(VimSdk::Soap::StubAdapter) }
  let(:soap_result) { double('some-soap-object') }
  let(:managed_object) { instance_double(VimSdk::Vim::VirtualMachine, class: VimSdk::Vim::VirtualMachine) }
  let(:method_info) { double('some-method-info', wsdl_name: 'PowerOnVM_Task') }
  let(:method_args) { nil }
  let(:retry_judge) { VSphereCloud::SdkHelpers::RetryJudge.new }
  let(:logger) { Logger.new(StringIO.new("")) }
  let(:retryer) { VSphereCloud::Retryer.new }

  describe '#invoke_method' do
    context 'When the status is "2xx"' do
      let(:soap_status) { 200 + rand(100) }

      it 'should return the SOAP object result' do
        expect(stub_adapter).to receive(:invoke_method)
                                  .once
                                  .with(managed_object, method_info, method_args, retryable_stub_adapter)
                                  .and_return([soap_status, soap_result])
        expect(retryable_stub_adapter.invoke_method(managed_object, method_info, method_args)).to be soap_result
      end
    end

    context 'When the status is "5xx" and the call is retryable' do
      let(:soap_status) { 500 + rand(100) }
      let(:soap_result) { double('fake-soap-error', fault_cause: 'fake-fault-cause') }

      it 'should try the SOAP operation 5 times' do
        expect(retryer).to receive(:sleep).with(1).once
        expect(retryer).to receive(:sleep).with(2).once
        expect(retryer).to receive(:sleep).with(4).once
        expect(retryer).to receive(:sleep).with(8).once
        expect(retryer).to receive(:sleep).with(16).once

        expect(stub_adapter).to receive(:invoke_method)
                                  .exactly(VSphereCloud::Retryer::MAX_TRIES).times
                                  .with(managed_object, method_info, method_args, retryable_stub_adapter)
                                  .and_return([soap_status, soap_result])
        expect {
          retryable_stub_adapter.invoke_method(managed_object, method_info, method_args)
        }.to raise_error(VimSdk::SoapError, 'Unknown SOAP fault')
      end
    end

    context 'When the status is "5xx" and the call is NOT retryable' do
      let(:soap_status) { 500 + rand(100) }
      let(:soap_result) { double('fake-soap-error', fault_cause: 'fake-fault-cause') }
      let(:method_info) { double('some-method-info', wsdl_name: 'RelocateVM_Task') }

      it 'should not retry the SOAP operation' do
        expect(stub_adapter).to receive(:invoke_method)
                                  .once
                                  .with(managed_object, method_info, method_args, retryable_stub_adapter)
                                  .and_return([soap_status, soap_result])
        expect {
          retryable_stub_adapter.invoke_method(managed_object, method_info, method_args)
        }.to raise_error(VimSdk::SoapError, 'Unknown SOAP fault')
      end
    end

    context 'When the status is initially "5xx", but changes to "2xx"' do
      let(:initial_soap_status) { 500 + rand(100) }
      let(:final_soap_status) { 200 + rand(100) }
      let(:initial_soap_result) { double('fake-soap-error', fault_cause: 'fake-fault-cause') }
      let(:final_soap_result) { double('some-soap-object') }

      it 'should retry the SOAP operation until it succeeds' do
        expect(retryer).to receive(:sleep).with(1).once
        call_count = 0
        expect(stub_adapter).to receive(:invoke_method)
                                  .twice
                                  .with(managed_object, method_info, method_args, retryable_stub_adapter) do
          if call_count == 0
            call_count += 1
            [initial_soap_status, initial_soap_result]
          else
            [final_soap_status, final_soap_result]
          end
        end

        expect(retryable_stub_adapter.invoke_method(managed_object, method_info, method_args)).to be(final_soap_result)
      end
    end
  end

  describe '#invoke_property' do
    let(:property_info) { double('some-property-info') }

    it 'delegates to the wrapped stub_adapter' do
      expect(stub_adapter).to receive(:invoke_property)
        .with(managed_object, property_info, retryable_stub_adapter)
        .once.and_return('some-property')
      expect(retryable_stub_adapter.invoke_property(managed_object, property_info)).to eq('some-property')
    end
  end

  describe '#version' do
    it 'delegates to the wrapped stub_adapter' do
      expect(stub_adapter).to receive(:version).once.and_return('some-version')

      expect(retryable_stub_adapter.version).to eq('some-version')
    end
  end
end
