require 'spec_helper'

module VSphereCloud
  describe CpiHttpClient do
    subject(:http_client) { CpiHttpClient.new }
    let(:backing_client) { http_client.backing_client }

    before(:all) do
      serve_https
    end

    after(:each) do
      ENV.delete("BOSH_CA_CERT_FILE")
    end

    describe '.build' do
      it 'creates an HTTPClient with specific options' do
        expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(backing_client.send_timeout).to eq(14400)
        expect(backing_client.receive_timeout).to eq(14400)
        expect(backing_client.connect_timeout).to eq(30)
      end

      it 'configures SSL when BOSH_CA_CERT_FILE has been set in the environment' do
        cert = certificate(:success)
        ENV["BOSH_CA_CERT_FILE"] = cert.path
        expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
        expect(backing_client.ssl_config.cert_store_items).to include(cert.path)
      end

      context 'when http_log is provided as a filepath' do
        subject(:http_client) { CpiHttpClient.new(log_file.path) }
        let(:log_file) { Tempfile.new('vsphere-http-log-test') }

        after do
          log_file.unlink
        end

        it 'logs requests and responses to the provided file' do
          response = http_client.get("https://localhost:#{@server.port}")
          expect(response.status).to eq(200)
          log_contents = File.read(log_file.path)
          expect(log_contents).to include('success!')
        end
      end

      context 'when http_log is provided as IO object' do
        subject(:http_client) { CpiHttpClient.new(log_writer) }
        let(:log_writer) { StringIO.new() }

        it 'logs requests and responses to the provided writer' do
          response = http_client.get("https://localhost:#{@server.port}")
          expect(response.status).to eq(200)
          log_contents = log_writer.string
          expect(log_contents).to include('success!')
        end
      end
    end

    describe 'SSL validation' do
      it 'succeeds when the SSL cert returned from the server is signed with a CA included in the provided bundle' do
        ENV["BOSH_CA_CERT_FILE"] = certificate(:success).path
        response = http_client.get("https://localhost:#{@server.port}")
        expect(response.body).to eq('success')
      end

      it 'fails when the SSL cert returned from the server is not signed with a CA included in the provided bundle' do
        ENV["BOSH_CA_CERT_FILE"] = certificate(:failure).path
        expect {
          response = http_client.get("https://localhost:#{@server.port}")
        }.to raise_error(OpenSSL::SSL::SSLError)
      end

      it 'succeds when a bundle is not provided' do
        response = http_client.get("https://localhost:#{@server.port}")
        expect(response.body).to eq('success')
      end
    end
  end
end
