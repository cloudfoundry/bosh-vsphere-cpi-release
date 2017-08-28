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

  # TODO(cdutra, kchen): remove after refactoring
  describe '#nsgroups' do
    before do
      expect(json_client).to receive(:get).with('ns-groups', query: {}).and_return(
        HTTP::Message.new_response('results' => [
          nsgroup_json(id: 'fake-nsgroup-id-1', display_name: 'fake-nsgroup-name-1'),
          nsgroup_json(id: 'fake-nsgroup-id-2', display_name: 'fake-nsgroup-name-2'),
        ])
      )
    end

    it 'returns the list of NSGroups' do
      nsgroups = client.nsgroups

      expect(nsgroups[0].id).to eq('fake-nsgroup-id-1')
      expect(nsgroups[0].display_name).to eq('fake-nsgroup-name-1')
      expect(nsgroups[1].id).to eq('fake-nsgroup-id-2')
      expect(nsgroups[1].display_name).to eq('fake-nsgroup-name-2')
    end
  end

  describe '#get_results' do
    let(:path) { 'fake-path' }
    let(:query) { { query_1: 'whatever' } }
    let(:http_response) { HTTP::Message.new_response('results' => %w(fake-result-1 fake-result-2)) }

    before do
      expect(json_client).to receive(:get).with(path, query: query).and_return(http_response)
    end

    context 'when response is successful' do
      it 'maps a block over each result' do
        results = client.send(:get_results, path, query) do |result|
          "got-#{result}"
        end
        expect(results).to eq(%w(got-fake-result-1 got-fake-result-2))
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
          client.send(:get_results, path, query) do |result|
            "got-#{result}"
          end
        end.to raise_error(VSphereCloud::NSXT::Error)
      end
    end
  end

  def nsgroup_json(id:, display_name:, members: [])
    { 'id' => id, 'display_name' => display_name, 'members' => members }
  end
end