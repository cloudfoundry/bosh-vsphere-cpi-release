require 'spec_helper'
require 'tempfile'

describe VSphereCloud::SoapStub do
  let(:soap_stub) { described_class.new('https://some-host/sdk/vimService', http_client) }
  let(:http_client) { instance_double('HTTPClient') }
  let(:adapter) { instance_double(VimSdk::Soap::StubAdapter) }

  describe '#create' do
    it 'returns the SDK Soap Adapter' do
      expect(VimSdk::Soap::StubAdapter).to receive(:new)
        .with(
          'https://some-host/sdk/vimService',
          'vim.version.version8',
          http_client,
        )
        .and_return(adapter)

      expect(soap_stub.create).to eq(adapter)
    end
  end
end
