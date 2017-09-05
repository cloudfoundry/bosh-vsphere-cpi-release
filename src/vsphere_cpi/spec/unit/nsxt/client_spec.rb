require 'spec_helper'

describe VSphereCloud::NSXT::Client do
  subject(:client) do
    described_class.new('fake-host', 'fake-username', 'fake-password')
  end
  let(:json_client) { client.instance_variable_get('@client') }

  describe '#initialize' do
    let(:host) { 'fake-host' }
    let(:username) { 'fake-username' }
    let(:password) { 'fake-password' }

    let(:json_client) { instance_double(JSONClient) }
    let(:root_url) { URI::HTTPS.build(host: host, path: '/api/v1/') }

    it 'uses basic authentication' do
      expect(JSONClient).to receive(:new).with(base_url: root_url).and_return(json_client)

      expect(json_client).to receive(:set_auth).with(root_url, username, password)
      expect(json_client).to receive(:force_basic_auth=).with(true)

      described_class.new(host, username, password)
    end

    context 'when $BOSH_NSXT_CA_CERT_FILE is present' do
      let(:ca_cert_file) { certificate(:success).path }

      before do
        ENV['BOSH_NSXT_CA_CERT_FILE'] = ca_cert_file
      end

      after do
        ENV.delete('BOSH_NSXT_CA_CERT_FILE')
        File.unlink(ca_cert_file)
      end

      it 'adds the file to the verification certificate store' do
        client = described_class.new(host, username, password)
        ssl_config = client.instance_variable_get('@client').ssl_config
        expect(ssl_config.cert_store_items).to include(ca_cert_file)
      end
    end
  end

  describe '#get_results' do
    let(:path) { 'fake-path' }
    let(:query) { { query_1: 'whatever' } }
    let(:http_response) do
      HTTP::Message.new_response(
        'results' => [
          { 'id' => 'fake-id-1', 'another_param' => 'abc' },
          { 'id' => 'fake-id-2' },
        ]
      )
    end
    let(:clazz) { TestClass }

    class TestClass < VSphereCloud::NSXT::Resource.new(:id); end
    class TestClassWithClient < VSphereCloud::NSXT::Resource.new(:client, :id); end

    before do
      expect(json_client).to receive(:get).with(path, query: query).and_return(http_response)
    end

    context 'when response is successful' do
      results = []
      before do
        results = client.send(:get_results, path, clazz, query)
        expect(results.length).to eq(2)

        expect(results[0].class).to eq(clazz)
        expect(results[1].class).to eq(clazz)
      end

      context 'and class has client' do
        let(:clazz) { TestClassWithClient }

        it 'injects client into Resource' do
          expect(results[0].client).to eq(json_client)
          expect(results[1].client).to eq(json_client)
          expect(results[0].id).to eq('fake-id-1')
          expect(results[1].id).to eq('fake-id-2')
        end
      end

      context 'and class does NOT have client' do
        it 'maps each result to VSphereCloud::NSXT::Resource' do
          expect(results[0].id).to eq('fake-id-1')
          expect(results[1].id).to eq('fake-id-2')
        end
      end
    end

    context 'when response is unsuccessful' do
      let(:http_response) do
        HTTP::Message.new_response('error-message').tap do |response|
          response.status = HTTP::Status::INTERNAL
        end
      end
      let(:error) do
        VSphereCloud::NSXT::Error.new(HTTP::Status::INTERNAL, nil)
      end

      it 'raises an error' do
        expect do
          client.send(:get_results, path, clazz, query)
        end.to raise_error(VSphereCloud::NSXT::Error)
      end
    end
  end
end