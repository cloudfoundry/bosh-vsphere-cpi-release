require 'spec_helper'

module VSphereCloud
  describe CpiHttpClient do
    subject(:http_client) { CpiHttpClient.build }

    after(:each) do
      ENV.delete("BOSH_CA_CERT_FILE")
    end

    describe '.build' do
      it 'creates an HTTPClient with specific options' do
        expect(http_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(http_client.send_timeout).to eq(14400)
        expect(http_client.receive_timeout).to eq(14400)
        expect(http_client.connect_timeout).to eq(30)
      end

      it 'configures SSL when BOSH_CA_CERT_FILE has been set in the environment' do
        cert = certificate(:success)
        ENV["BOSH_CA_CERT_FILE"] = cert.path
        expect(http_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
        expect(http_client.ssl_config.cert_store_items).to include(cert.path)
      end
    end

    describe 'SSL validation' do
      before(:all) do
        serve_https
      end

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
