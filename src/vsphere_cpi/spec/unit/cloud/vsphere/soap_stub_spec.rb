require 'spec_helper'
require 'tempfile'

describe VSphereCloud::SoapStub, fake_logger: true do
  let(:soap_stub) { described_class.new('https://some-host/sdk/vimService', http_client) }
  let(:http_client) { instance_double('HTTPClient') }
  let(:base_adapter) { instance_double(VimSdk::Soap::StubAdapter) }
  let(:retryable_adapter) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter) }

  describe '#create' do

    around(:each) do |example|
      old_vc_version = $vc_version
      example.run
      $vc_version = old_vc_version
    end

    context 'when vc_version is set to 7.0' do
      before(:each) { $vc_version = '7.0' }

      it 'returns the SDK Soap Adapter with VIM version set to vim.version.v7_0' do
        expect(VimSdk::Soap::StubAdapter).to receive(:new).with('https://some-host/sdk/vimService', 'vim.version.v7_0', http_client).and_return(base_adapter)
        expect(VSphereCloud::SdkHelpers::RetryableStubAdapter).to receive(:new).with(base_adapter,).and_return(retryable_adapter)
        expect(soap_stub.create).to eq(retryable_adapter)
      end
    end

    context 'when vc version is set to something other than 7.0' do
      before(:each) { $vc_version = '6.5' }

      it 'returns the SDK Soap Adapter with VIM version set to vim.version.version12' do
        expect(VimSdk::Soap::StubAdapter).to receive(:new).with('https://some-host/sdk/vimService', 'vim.version.version12', http_client).and_return(base_adapter)
        expect(VSphereCloud::SdkHelpers::RetryableStubAdapter).to receive(:new).with(base_adapter,).and_return(retryable_adapter)
        expect(soap_stub.create).to eq(retryable_adapter)
      end
    end
  end
end
