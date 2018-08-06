require 'spec_helper'
require 'tempfile'

describe VSphereCloud::SoapStub, fake_logger: true do
  let(:soap_stub) { described_class.new('https://some-host/sdk/vimService', http_client) }
  let(:http_client) { instance_double('HTTPClient') }
  let(:base_adapter) { instance_double(VimSdk::Soap::StubAdapter) }
  let(:retryable_adapter) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter) }

  describe '#create' do
    it 'returns the SDK Soap Adapter' do
      expect(VimSdk::Soap::StubAdapter).to receive(:new)
        .with(
          'https://some-host/sdk/vimService',
          'vim.version.version12',
          http_client,
        )
        .and_return(base_adapter)
      expect(VSphereCloud::SdkHelpers::RetryableStubAdapter).to receive(:new)
       .with(
         base_adapter,
       )
       .and_return(retryable_adapter)

      expect(soap_stub.create).to eq(retryable_adapter)
    end
  end
end
