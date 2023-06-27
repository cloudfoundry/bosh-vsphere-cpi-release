require 'spec_helper'

describe VmodlVersionDiscriminant do
  describe '.retrieve_vmodl_version', fake_logger: true, fast_retries: true do
    let(:client) do
      client = instance_double(VSphereCloud::CpiHttpClient)
      expect(VSphereCloud::CpiHttpClient).to receive(:new).and_return(client)
      client
    end
    let(:connection_options) { {} }

    let(:failure) { HTTP::Message.new_response(nil).tap { |m| m.status = 400 } }
    let(:success) do
      HTTP::Message.new_response(<<~XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <namespaces version="1.0">
          <namespace>
            <name>urn:vim25</name>
            <version>6.5</version>
            <priorVersions><version>6.0</version></priorVersions>
          </namespace>
        </namespaces>
      XML
    end

    it 'logs an informational message unless the logger is absent' do
      expect(logger).to receive(:info).with(/vSphere version/)
      described_class.retrieve_vmodl_version("test-host", connection_options, logger)
    end

    it "sends a GET request to a vimServiceVersions.xml file on the host" do
      url = "https://test-host/sdk/vimServiceVersions.xml"
      expect(client).to receive(:get).with(url).and_return(success)
      described_class.retrieve_vmodl_version("test-host", connection_options)
    end

    it 'retries the GET request to vimServiceVersions.xml on failure' do
      url = "https://test-host/sdk/vimServiceVersions.xml"
      expect(client).to receive(:get).with(url).and_return(failure, success)
      described_class.retrieve_vmodl_version("test-host", connection_options)
    end

    it 'logs each failure unless the logger is absent' do
      expect(client).to receive(:get).and_return(failure, success)

      expect(logger).to receive(:warn).with(/Couldn't GET.*test-host.*400/)
      described_class.retrieve_vmodl_version("test-host", connection_options, logger)
    end

    it 'returns the result of .extract_vmodl_version on the XML document' do
      expect(client).to receive(:get).and_return(success)

      expect(described_class).to receive(:extract_vmodl_version).with(
        an_instance_of(Nokogiri::XML::Document)).and_return(:stub)
      expect(described_class.retrieve_vmodl_version("test-host", connection_options)).to eq(:stub)
    end

    it 'returns 6.5 and warns if any nonretryable error occurs' do
      expect(client).to receive(:get).and_return(success)

      expect(described_class).to receive(:extract_vmodl_version).and_raise(
        StandardError, "test message")
      expect(logger).to receive(:warn).with(/test message.*6.5/)
      result = described_class.retrieve_vmodl_version("test-host", connection_options, logger)

      expect(result).to eq('6.5')
    end
  end

  describe '.extract_vmodl_version' do
    def self.let_document(text)
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
          #{text}
          </namespaces>
        XML
      end
    end

    context 'when multiple namespaces are in the document' do
      let_document(<<~XML)
        <namespace>
          <name>should-ignore</name>
          <version>6.7.3</version>
          <priorVersions><version>6.7.2</version></priorVersions>
        </namespace>
        <namespace>
          <name>urn:vim25</name>
          <version>6.5</version>
          <priorVersions><version>6.0</version></priorVersions>
        </namespace>
      XML

      it 'returns the version of the urn:vim25 namespace' do
        expect(described_class.extract_vmodl_version(document)).to eq('6.5')
      end
    end

    context "when the urn:vim25 namespace isn't in the document" do
      let_document(<<~XML)
        <namespace>
          <name>should-ignore</name>
          <version>6.7.3</version>
          <priorVersions><version>6.7.2</version></priorVersions>
        </namespace>
      XML

      it 'returns the fallback version' do
        expect(described_class.extract_vmodl_version(document)).to eq('6.5')
      end
    end

    context "when the urn:vim25 version isn't a . delimited version string" do
      let_document(<<~XML)
        <namespace>
          <name>urn:vim25</name>
          <version>should-ignore</version>
          <priorVersions>
            <version>should-ignore</version>
            <version>6.5</version>
            <version>6.0</version>
          </priorVersions>
        </namespace>
      XML

      it 'returns the highest version that is a . delimited version string' do
        expect(described_class.extract_vmodl_version(document)).to eq('6.5')
      end
    end

    context 'when the urn:vim25 version is at least 7.0' do
      let_document(<<~XML)
        <namespace>
          <name>urn:vim25</name>
          <version>7.0.1.0</version>
          <priorVersions><version>7.0.0.0</version></priorVersions>
        </namespace>
      XML

      it 'returns 7.0' do
        expect(described_class.extract_vmodl_version(document)).to eq('7.0')
      end
    end

    context 'when the urn:vim25 version is at least 6.7 but less than 7.0' do
      let_document(<<~XML)
        <namespace>
          <name>urn:vim25</name>
          <version>6.9.1</version>
          <priorVersions><version>6.8.7</version></priorVersions>
        </namespace>
      XML

      it 'returns 6.7' do
        expect(described_class.extract_vmodl_version(document)).to eq('6.7')
      end
    end

    context 'when the urn:vim25 version is less than 6.7' do
      let_document(<<~XML)
        <namespace>
          <name>urn:vim25</name>
          <version>6.5</version>
          <priorVersions><version>6.0</version></priorVersions>
        </namespace>
      XML

      it 'returns 6.5' do
        expect(described_class.extract_vmodl_version(document)).to eq('6.5')
      end
    end
  end
end
