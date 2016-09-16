require 'spec_helper'

module VSphereCloud
  describe FileProvider do
    subject(:file_provider) { described_class.new(http_client: http_client, vcenter_host: vcenter_host, logger: logger, retryer: retryer) }

    let(:http_client) { double('fake-rest-client') }
    let(:vcenter_host) { 'fake-vcenter-host' }
    let(:logger) { Logger.new(StringIO.new("")) }
    let(:retryer) { Retryer.new }

    let(:datacenter_name) { 'fake-datacenter-name 1' }
    let(:datastore_name) { 'fake-datastore-name 1' }
    let(:path) { 'fake-path' }

    before do
      allow(retryer).to receive(:sleep)
    end

    describe '#fetch_file' do
      it 'gets specified file' do
        response_body = double('response_body')
        response = double('response', code: 200, body: response_body)
        expect(http_client).to receive(:get).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
        ).and_return(response)

        expect(
          file_provider.fetch_file_from_datastore(datacenter_name, datastore_name, path)
        ).to eq(response_body)
      end

      context 'when the current agent environment does not exist' do
        it 'returns nil' do
          expect(http_client).to receive(:get).with(
            'https://fake-vcenter-host/folder/fake-path?'\
            'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
          ).and_return(double('response', code: 404))

          expect(
            file_provider.fetch_file_from_datastore(datacenter_name, datastore_name, path)
          ).to be_nil
        end
      end

      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do
          expect(http_client).to receive(:get)
            .with(
              'https://fake-vcenter-host/folder/fake-path?'\
              'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
            )
            .exactly(Retryer::MAX_TRIES).times
            .and_return(double('response', code: 500))

          expect {
            file_provider.fetch_file_from_datastore(datacenter_name, datastore_name, path)
          }.to raise_error(/Could not transfer file/)
        end
      end
    end

    describe '#upload_file_to_datastore' do
      let(:upload_contents) {"fake uplóad contents"}
      it 'uploads specified file' do
        response = double('response', code: 200, body: nil)
        expect(http_client).to receive(:put).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201',
          upload_contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => upload_contents.bytesize }
        ).and_return(response)

        file_provider.upload_file_to_datastore(datacenter_name, datastore_name, path, upload_contents)
      end

      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do
          expect(http_client).to receive(:put)
            .exactly(Retryer::MAX_TRIES).times
            .and_return(double('response', code: 500, body: nil))

          expect {
            file_provider.upload_file_to_datastore(datacenter_name, datastore_name, path, upload_contents)
          }.to raise_error(/Could not transfer file/)
        end
      end
    end

    describe '#upload_file_to_url' do
      let (:url) { 'http://example.com' }
      let (:body) { 'fake-bödy'}
      let (:headers) { { 'Content-Type' => 'fake-header' } }

      it 'uploads specified file' do
        response = double('response', code: 200, body: body)
        expected_headers = { 'Content-Type' => 'fake-header' , 'Content-Length' => body.bytesize }
        expect(http_client).to receive(:post).with(url, body, expected_headers).and_return(response)

        file_provider.upload_file_to_url(url, body, headers)
      end

      context 'when vSphere cannot handle the request' do
        it 'retries and then raises an error' do
          expect(http_client).to receive(:post).exactly(Retryer::MAX_TRIES).times.and_return(double('response', code: 500, body: nil))

          expect {
            file_provider.upload_file_to_url(url, body, headers)
          }.to raise_error(/Could not transfer file/)
        end
      end
    end
  end
end
