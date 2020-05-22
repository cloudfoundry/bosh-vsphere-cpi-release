require 'spec_helper'

describe VAPIVersionDiscriminant do
  describe '.vapi_version' do
    context 'when multiple namespaces are in the document' do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
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
          </namespaces>
        XML
      end

      it 'returns the version of the urn:vim25 namespace' do
        expect(described_class.vapi_version(document)).to eq('6.5')
      end
    end

    context "when the urn:vim25 namespace isn't in the document" do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
            <namespace>
              <name>should-ignore</name>
              <version>6.7.3</version>
              <priorVersions><version>6.7.2</version></priorVersions>
            </namespace>
          </namespaces>
        XML
      end

      it 'returns the fallback version' do
        expect(described_class.vapi_version(document)).to eq('6.5')
      end
    end

    context "when the urn:vim25 version isn't a . delimited version string" do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
            <namespace>
              <name>urn:vim25</name>
              <version>should-ignore</version>
              <priorVersions>
                <version>should-ignore</version>
                <version>6.5</version>
                <version>6.0</version>
              </priorVersions>
            </namespace>
          </namespaces>
        XML
      end

      it 'returns the highest version that is a . delimited version string' do
        expect(described_class.vapi_version(document)).to eq('6.5')
      end
    end

    context 'when the urn:vim25 version is at least 7.0' do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
            <namespace>
              <name>urn:vim25</name>
              <version>7.0.1.0</version>
              <priorVersions>
                <version>7.0.0.0</version>
              </priorVersions>
            </namespace>
          </namespaces>
        XML
      end

      it 'returns 7.0' do
        expect(described_class.vapi_version(document)).to eq('7.0')
      end
    end

    context 'when the urn:vim25 version is at least 6.7 but less than 7.0' do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
            <namespace>
              <name>urn:vim25</name>
              <version>6.9.1</version>
              <priorVersions>
                <version>6.8.7</version>
              </priorVersions>
            </namespace>
          </namespaces>
        XML
      end

      it 'returns 6.7' do
        expect(described_class.vapi_version(document)).to eq('6.7')
      end
    end

    context 'when the urn:vim25 version is less than 6.7' do
      let(:document) do
        Nokogiri.XML(<<~XML)
          <?xml version="1.0" encoding="UTF-8"?>
          <namespaces version="1.0">
            <namespace>
              <name>urn:vim25</name>
              <version>6.5</version>
              <priorVersions>
                <version>6.0</version>
              </priorVersions>
            </namespace>
          </namespaces>
        XML
      end

      it 'returns 6.5' do
        expect(described_class.vapi_version(document)).to eq('6.5')
      end
    end
  end
end
