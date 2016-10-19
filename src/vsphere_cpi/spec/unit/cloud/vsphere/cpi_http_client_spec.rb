require 'spec_helper'

module VSphereCloud
  describe CpiHttpClient do
    subject(:http_client) { CpiHttpClient.new }
    let(:backing_client) { http_client.backing_client }

    before(:all) do
      serve_https
    end

    after(:all) do
      stop_server
    end

    after(:each) do
      ENV.delete("BOSH_CA_CERT_FILE")
    end

    describe 'SSL validation' do
      it 'configures SSL when BOSH_CA_CERT_FILE has been set in the environment' do
        cert = certificate(:success)
        ENV["BOSH_CA_CERT_FILE"] = cert.path
        expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
        expect(backing_client.ssl_config.cert_store_items).to include(cert.path)
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
        }.to raise_error(/vcenter.connection_options.ca_cert/)
      end

      it 'succeeds when a bundle is not provided' do
        response = http_client.get("https://localhost:#{@server.port}")
        expect(response.body).to eq('success')
      end
    end
  end
end
