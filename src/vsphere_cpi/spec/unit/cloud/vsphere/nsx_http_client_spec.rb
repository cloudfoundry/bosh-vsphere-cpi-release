require 'spec_helper'

module VSphereCloud
  describe NsxHttpClient do
    subject(:http_client) { NsxHttpClient.new('username', 'password', ca_cert_file) }
    let(:ca_cert_file) { nil }
    let(:backing_client) { http_client.backing_client }

    before(:all) do
      serve_https
    end

    after(:all) do
      stop_server
    end

    describe 'SSL validation' do
      context 'when no CA cert file is provided' do
        it 'does not validate the NSX certificate when connecting' do
          expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        end
      end

      context 'when the CA cert file provided signs the NSX cert' do
        let(:ca_cert_file) { certificate(:success).path }

        it 'validates the NSX certificate when connecting' do
          expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
          expect(backing_client.ssl_config.cert_store_items).to include(ca_cert_file)
        end

        it 'succeeds when connecting' do
          response = http_client.get("https://localhost:#{@server.port}")
          expect(response.body).to eq('success')
        end
      end

      context 'when the CA cert file does NOT sign the NSX cert' do
        let(:ca_cert_file) { certificate(:failure).path }

        it 'raises a TLS verification error' do
          expect {
            http_client.get("https://localhost:#{@server.port}")
          }.to raise_error(/does not have a valid SSL certificate.*vcenter.nsx.ca_cert/)
        end
      end
    end
  end
end
