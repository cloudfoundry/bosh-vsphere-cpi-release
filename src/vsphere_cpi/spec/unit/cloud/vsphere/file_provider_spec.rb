require 'spec_helper'

module VSphereCloud
  describe FileProvider, fake_logger: true do
    subject(:file_provider) do  described_class.new(client: client,
      http_client: http_client, vcenter_host: vcenter_host, retryer: retryer)
    end

    let(:http_client) { double('fake-rest-client') }
    let(:vcenter_host) { 'fake-vcenter-host' }
    let(:retryer) { Retryer.new }
    let(:client) { instance_double('VSphereCloud::VCenterClient') }
    let(:datacenter_name) { 'fake-datacenter-name 1' }
    let(:path) { 'fake-path' }
    let(:datastore) {
      instance_double('VimSdk::Vim::Datastore',name: 'fake-datastore-name 1')
    }
    let(:host) { instance_double('VimSdk::Vim::HostSystem', name: 'host')}
    let(:ticket) {
      instance_double('VimSdk::Vim::SessionManager::GenericServiceTicket', id: 'ticket')
    }
    before do
      allow(file_provider).to receive(:get_healthy_host).with(anything).and_return(host)
      allow(file_provider).to receive(:get_generic_service_ticket).with(anything).and_return(ticket)
      allow(retryer).to receive(:sleep)
    end

    describe '#fetch_file' do
      it 'first tries to get file from datastore via a host and succeeds' do
        response_body = double('response_body')
        response = double('response', code: 200, body: response_body)
        expect(http_client).to receive(:get).with(
          'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
          {'Cookie' => "vmware_cgi_ticket=ticket"}
        ).and_return(response)

        expect(
          file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
        ).to eq(response_body)
      end

      it 'fails to get file via host and retries to get through datacenter and succeeds' do
        response_body = double('response_body')
        response = double('response', code: 200, body: response_body)

        expect(http_client).to receive(:get).with(
          'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
          {'Cookie' => "vmware_cgi_ticket=ticket"}
        ).exactly(Retryer::MAX_TRIES).times
         .and_return(double('response', code: 401))

        expect(http_client).to receive(:get).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
        ).and_return(response)

        expect(
          file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
        ).to eq(response_body)
      end

      context 'when vsphere fails to issue generic service ticket' do
        before do
          allow(file_provider).to receive(:get_generic_service_ticket).with(anything).and_raise("BOOM : Any Error")
        end
        it 'fails to get file via host and retries to get through datacenter and succeeds' do
          response_body = double('response_body')
          response = double('response', code: 200, body: response_body)

          expect(http_client).to_not receive(:get).with(
              'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
              {'Cookie' => "vmware_cgi_ticket=ticket"}
          )
          expect(http_client).to receive(:get).with(
              'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
          ).and_return(response)

          expect(
              file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
          ).to eq(response_body)
        end
      end


      it 'fails to get file and raises file transfer error' do
        response_body = double('response_body')

        expect(http_client).to receive(:get).with(
          'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
          {'Cookie' => "vmware_cgi_ticket=ticket"}
        ).exactly(Retryer::MAX_TRIES).times
         .and_return(double('response', code: 401))

        expect(http_client).to receive(:get).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
        ).exactly(Retryer::MAX_TRIES).times
         .and_return(double('response', code: 401))

        expect {
          file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
        }.to raise_error(VSphereCloud::FileTransferError, /Could not transfer file/)
      end

      context 'when the current agent environment does not exist' do
        it 'returns nil' do
          expect(http_client).to receive(:get).with(
            'https://host/folder/fake-path?'\
            'dsName=fake-datastore-name%201',
            {'Cookie' => "vmware_cgi_ticket=ticket"}
          ).exactly(Retryer::MAX_TRIES).times
           .and_return(double('response', code: 404))

          expect(http_client).to receive(:get).with(
            'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
          ).and_return(double('response', code: 404))

          expect(
            file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
          ).to be_nil
        end
      end

      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do
          expect(http_client).to receive(:get).with(
            'https://host/folder/fake-path?'\
            'dsName=fake-datastore-name%201',
            {'Cookie' => "vmware_cgi_ticket=ticket"}
          ).exactly(Retryer::MAX_TRIES).times
           .and_return(double('response', code: 500))

          expect(http_client).to receive(:get).with(
            'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201', {}
          ).exactly(Retryer::MAX_TRIES).times
           .and_return(double('response', code: 500))

          expect {
            file_provider.fetch_file_from_datastore(datacenter_name, datastore, path)
          }.to raise_error(/Could not transfer file/)
        end
      end
    end

    describe '#upload_file_to_datastore' do
      let(:upload_contents) {"fake upload contents"}
      it 'first tries to upload file to datastore via a host and succeeds' do
        response = double('response', code: 200, body: nil)
        expect(http_client).to receive(:put).with(
          'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
          upload_contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => upload_contents.bytesize,
            'Cookie' => "vmware_cgi_ticket=ticket"
          }
        ).and_return(response)

        file_provider.upload_file_to_datastore(datacenter_name, datastore, path, upload_contents)
      end

      it 'fails to upload file via host and retries to upload through datacenter and succeeds' do
        response_body = double('response_body')
        response = double('response', code: 200, body: response_body)

        expect(http_client).to receive(:put).with(
          'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
          upload_contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => upload_contents.bytesize,
            'Cookie' => "vmware_cgi_ticket=ticket",
          }
        ).exactly(Retryer::MAX_TRIES).times
         .and_return(double('response', code: 401))

        expect(http_client).to receive(:put).with(
          'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201',
          upload_contents,
          { 'Content-Type' => 'application/octet-stream',
            'Content-Length' => upload_contents.bytesize,
          }
        ).and_return(response)

        file_provider.upload_file_to_datastore(datacenter_name, datastore, path, upload_contents)
      end

      context 'when vsphere fails to issue generic service ticket' do
        before do
          allow(file_provider).to receive(:get_generic_service_ticket).with(anything).and_raise("BOOM : Any Error")
        end
        it 'fails to upload file via host and retries to upload through datacenter and succeeds' do
          response_body = double('response_body')
          response = double('response', code: 200, body: response_body)

          expect(http_client).to_not receive(:put).with(
              'https://host/folder/fake-path?'\
          'dsName=fake-datastore-name%201',
              upload_contents,
              { 'Content-Type' => 'application/octet-stream', 'Content-Length' => upload_contents.bytesize,
                'Cookie' => "vmware_cgi_ticket=ticket",
              }
          )
          expect(http_client).to receive(:put).with(
              'https://fake-vcenter-host/folder/fake-path?'\
          'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201',
              upload_contents,
              { 'Content-Type' => 'application/octet-stream',
                'Content-Length' => upload_contents.bytesize,
              }
          ).and_return(response)

          file_provider.upload_file_to_datastore(datacenter_name, datastore, path, upload_contents)
        end
      end


      context 'when vSphere cannot handle the request' do
        it 'retries then raises an error' do

          expect(http_client).to receive(:put).with(
            'https://host/folder/fake-path?'\
            'dsName=fake-datastore-name%201',
            upload_contents,
            { 'Content-Type' => 'application/octet-stream',
              'Content-Length' => upload_contents.bytesize,
              'Cookie' => "vmware_cgi_ticket=ticket",
            }
          ).exactly(Retryer::MAX_TRIES).times.and_return(double('response', code: 500))

          expect(http_client).to receive(:put).with(
            'https://fake-vcenter-host/folder/fake-path?'\
            'dcPath=fake-datacenter-name%201&dsName=fake-datastore-name%201',
            upload_contents,
            { 'Content-Type' => 'application/octet-stream',
              'Content-Length' => upload_contents.bytesize,
            }
          ).exactly(Retryer::MAX_TRIES).times.and_return(double('response', code: 500))

          expect {
            file_provider.upload_file_to_datastore(datacenter_name, datastore, path, upload_contents)
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
