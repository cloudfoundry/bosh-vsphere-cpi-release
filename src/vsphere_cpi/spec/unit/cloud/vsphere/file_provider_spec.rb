require 'spec_helper'

module VSphereCloud
  describe FileProvider do
    subject(:file_provider) { described_class.new(http_client: http_client, vcenter_host: vcenter_host, logger: logger) }

    let(:http_client) { double('fake-rest-client') }
    let(:vcenter_host) { 'fake-vcenter-host' }
    let(:logger) { Logger.new(StringIO.new("")) }

    let(:datacenter_name) { 'fake-datacenter-name 1' }
    let(:datastore_name) { 'fake-datastore-name 1' }
    let(:path) { 'fake-path' }

    describe '#fetch_file' do
      it 'gets specified file' do
        response_body = double('response_body')
        response = double('response', code: 200, body: response_body)
        expect(http_client).to receive(:get).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201'
        ).and_return(response)

        expect(
          file_provider.fetch_file(datacenter_name, datastore_name, path)
        ).to eq(response_body)
      end

      context 'when the current agent environment does not exist' do
        it 'returns nil' do
          expect(http_client).to receive(:get).with(
            'https://fake-vcenter-host/folder/fake-path?'\
            'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201'
          ).and_return(double('response', code: 404))

          expect(
            file_provider.fetch_file(datacenter_name, datastore_name, path)
          ).to be_nil
        end
      end

      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do
          expect(http_client).to receive(:get)
            .with(
              'https://fake-vcenter-host/folder/fake-path?'\
              'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201'
            )
            .exactly(5).times
            .and_return(double('response', code: 500))

          expect {
            file_provider.fetch_file(datacenter_name, datastore_name, path)
          }.to raise_error(/Could not fetch file/)
        end
      end
    end

    describe '#upload_file' do
      let(:upload_contents) {"fake upload contents"}
      it 'uploads specified file' do
        response = double('response', code: 200, body: nil)
        expect(http_client).to receive(:put).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201',
          upload_contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => upload_contents.length }
        ).and_return(response)

        file_provider.upload_file(datacenter_name, datastore_name, path, upload_contents)
      end

      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do
          expect(http_client).to receive(:put)
            .exactly(5).times
            .and_return(double('response', code: 500, body: nil))

          expect {
            file_provider.upload_file(datacenter_name, datastore_name, path, upload_contents)
          }.to raise_error(/Could not upload file/)
        end
      end
    end
  end
end
