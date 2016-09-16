require 'spec_helper'
require 'tempfile'

describe VSphereCloud::SoapStub do
  let(:soap_stub) { described_class.new('https://some-host/sdk/vimService', http_client, logger) }
  let(:http_client) { instance_double('HTTPClient') }
  let(:base_adapter) { instance_double(VimSdk::Soap::StubAdapter) }
  let(:retryable_adapter) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter) }
  let(:logger) { Logger.new(StringIO.new("")) }

  describe '#create' do
    it 'returns the SDK Soap Adapter' do
      expect(VimSdk::Soap::StubAdapter).to receive(:new)
        .with(
          'https://some-host/sdk/vimService',
          'vim.version.version8',
          http_client,
        )
        .and_return(base_adapter)
      expect(VSphereCloud::SdkHelpers::RetryableStubAdapter).to receive(:new)
       .with(
         base_adapter,
         logger,
       )
       .and_return(retryable_adapter)

      expect(soap_stub.create).to eq(retryable_adapter)
    end
  end
end
