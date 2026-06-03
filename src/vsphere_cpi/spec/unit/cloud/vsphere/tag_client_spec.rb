require 'spec_helper'
require 'json'
require 'base64'

module VSphereCloud
  module TaggingTag
    describe TagClient do
      subject(:tag_client) do
        TagClient.new(
          host: "localhost:#{@server.port}",
          username: 'admin',
          password: 'password',
          ca_cert_file: ca_cert_file,
        )
      end
      let(:ca_cert_file) { nil }

      before(:all) do
        serve_https
      end

      after(:all) do
        stop_server
      end

      describe 'SSL validation' do
        context 'when no CA cert file is provided' do
          it 'disables TLS verification on the backing HTTP client' do
            expect(tag_client.instance_variable_get(:@http_client).backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
          end
        end

        context 'when an empty CA cert file is provided' do
          let(:ca_cert_file) { '' }

          it 'treats empty as absent and disables TLS verification' do
            expect(tag_client.instance_variable_get(:@http_client).backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
          end
        end

        context 'when a whitespace-only CA cert file is provided' do
          let(:ca_cert_file) { "  \t\n" }

          it 'treats whitespace as absent and disables TLS verification' do
            expect(tag_client.instance_variable_get(:@http_client).backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
          end
        end

        context 'when a CA cert file that signs the vCenter cert is provided' do
          let(:ca_cert_file) { certificate(:success).path }

          it 'enables peer verification and trusts the bundle' do
            backing_client = tag_client.instance_variable_get(:@http_client).backing_client
            expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
            expect(backing_client.ssl_config.cert_store_items).to include(ca_cert_file)
          end
        end

        context 'when a CA cert file that does NOT sign the vCenter cert is provided' do
          let(:ca_cert_file) { certificate(:failure).path }

          it 'fails TLS verification when establishing a session' do
            expect {
              tag_client.login
            }.to raise_error(RuntimeError, /does not have a valid SSL certificate.*vcenter.connection_options.ca_cert/)
          end
        end
      end

      describe '#login' do
        let(:base_url) { "https://localhost:#{@server.port}" }
        let(:expected_url) { "#{base_url}/rest/com/vmware/cis/session" }
        let(:http_client) { tag_client.instance_variable_get(:@http_client) }

        it 'posts to the CIS session endpoint with HTTP Basic Auth and stores the session id' do
          response = double('Response', code: 200, body: { value: 'cis-session-id' }.to_json)
          expected_basic = "Basic #{Base64.strict_encode64('admin:password')}"

          expect(http_client).to receive(:post).with(
            expected_url,
            '',
            hash_including(
              'Authorization' => expected_basic,
              'Accept' => 'application/json',
            )
          ).and_return(response)

          expect(tag_client.login).to eq('cis-session-id')
          expect(tag_client.session_id).to eq('cis-session-id')
        end

        it 'is idempotent: subsequent login calls reuse the cached session id' do
          response = double('Response', code: 200, body: { value: 'cis-session-id' }.to_json)
          expect(http_client).to receive(:post).once.and_return(response)
          tag_client.login
          tag_client.login
          expect(tag_client.session_id).to eq('cis-session-id')
        end

        it 'raises TagClientError on a non-2xx response' do
          response = double('Response', code: 401, body: 'unauthorized')
          allow(http_client).to receive(:post).and_return(response)
          expect { tag_client.login }.to raise_error(TagClientError, /HTTP 401/)
        end
      end

      describe 'tagging API calls' do
        let(:base_url) { "https://localhost:#{@server.port}" }
        let(:http_client) { tag_client.instance_variable_get(:@http_client) }
        let(:session_id) { 'cis-session-id' }
        let(:success_session_response) { double('Response', code: 200, body: { value: session_id }.to_json) }

        before do
          allow(http_client).to receive(:post).with(
            "#{base_url}/rest/com/vmware/cis/session",
            '',
            hash_including('Authorization' => /^Basic /),
          ).and_return(success_session_response)
        end

        def stub_response(code:, body:)
          double('Response', code: code, body: body)
        end

        describe '#list_categories' do
          it 'returns the value array' do
            expect(http_client).to receive(:get).with(
              "#{base_url}/rest/com/vmware/cis/tagging/category",
              hash_including('vmware-api-session-id' => session_id),
            ).and_return(stub_response(code: 200, body: { value: %w[urn:cat:1 urn:cat:2] }.to_json))

            expect(tag_client.list_categories).to eq(%w[urn:cat:1 urn:cat:2])
          end
        end

        describe '#get_category' do
          it 'returns the value hash' do
            expect(http_client).to receive(:get).with(
              "#{base_url}/rest/com/vmware/cis/tagging/category/id:urn:cat:1",
              hash_including('vmware-api-session-id' => session_id),
            ).and_return(stub_response(code: 200, body: { value: { id: 'urn:cat:1', name: 'category-name-a', cardinality: 'MULTIPLE', associable_types: ['VirtualMachine'] } }.to_json))

            result = tag_client.get_category('urn:cat:1')
            expect(result['name']).to eq('category-name-a')
            expect(result['cardinality']).to eq('MULTIPLE')
            expect(result['associable_types']).to eq(['VirtualMachine'])
          end
        end

        describe '#get_tag' do
          it 'returns the value hash' do
            expect(http_client).to receive(:get).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag/id:urn:tag:1",
              hash_including('vmware-api-session-id' => session_id),
            ).and_return(stub_response(code: 200, body: { value: { id: 'urn:tag:1', name: 'tag-name-a-1' } }.to_json))

            expect(tag_client.get_tag('urn:tag:1')['name']).to eq('tag-name-a-1')
          end
        end

        describe '#list_tags_for_category' do
          it 'POSTs the action and returns the value array' do
            expect(http_client).to receive(:post).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag/id:urn:cat:1?~action=list-tags-for-category",
              '',
              hash_including('vmware-api-session-id' => session_id, 'Accept' => 'application/json'),
            ).and_return(stub_response(code: 200, body: { value: %w[urn:tag:1 urn:tag:2] }.to_json))

            expect(tag_client.list_tags_for_category('urn:cat:1')).to eq(%w[urn:tag:1 urn:tag:2])
          end
        end

        describe '#attach_tag' do
          it 'POSTs the attach action with the vm mob in the body' do
            expected_body = {
              'object_id' => { 'id' => 'vm-1', 'type' => 'VirtualMachine' },
            }
            expect(http_client).to receive(:post).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag-association/id:urn:tag:1?~action=attach",
              JSON.generate(expected_body),
              hash_including(
                'vmware-api-session-id' => session_id,
                'Content-Type' => 'application/json',
              ),
            ).and_return(stub_response(code: 200, body: ''))

            expect(tag_client.attach_tag('urn:tag:1', 'vm-1')).to be_nil
          end
        end

        describe '#attach_multiple_tags_to_object' do
          it 'POSTs the attach-multiple action with tag_ids array' do
            expected_body = {
              'object_id' => { 'id' => 'vm-1', 'type' => 'VirtualMachine' },
              'tag_ids' => %w[urn:tag:1 urn:tag:2],
            }
            expect(http_client).to receive(:post).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag-association?~action=attach-multiple-tags-to-object",
              JSON.generate(expected_body),
              hash_including(
                'vmware-api-session-id' => session_id,
                'Content-Type' => 'application/json',
              ),
            ).and_return(stub_response(code: 200, body: ''))

            expect(tag_client.attach_multiple_tags_to_object(%w[urn:tag:1 urn:tag:2], 'vm-1')).to be_nil
          end
        end

        describe '#list_attached_tags_on_objects' do
          it 'POSTs the list-attached-tags-on-objects action with a VirtualMachine object_ids array and returns the value' do
            vm_mob_ids = %w[vm-1 vm-2]
            expected_body = {
              'object_ids' => [
                { 'id' => 'vm-1', 'type' => 'VirtualMachine' },
                { 'id' => 'vm-2', 'type' => 'VirtualMachine' },
              ],
            }
            response_value = [
              { 'object_id' => { 'id' => 'vm-1', 'type' => 'VirtualMachine' }, 'tag_ids' => %w[urn:tag:1] },
              { 'object_id' => { 'id' => 'vm-2', 'type' => 'VirtualMachine' }, 'tag_ids' => [] },
            ]
            expect(http_client).to receive(:post).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-tags-on-objects",
              JSON.generate(expected_body),
              hash_including(
                'vmware-api-session-id' => session_id,
                'Content-Type' => 'application/json',
              ),
            ).and_return(stub_response(code: 200, body: { value: response_value }.to_json))

            result = tag_client.list_attached_tags_on_objects(vm_mob_ids)
            expect(result).to eq(response_value)
          end

          it 'wraps a single vm_mob_id in an array' do
            expected_body = {
              'object_ids' => [{ 'id' => 'vm-solo', 'type' => 'VirtualMachine' }],
            }
            expect(http_client).to receive(:post).with(
              "#{base_url}/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-tags-on-objects",
              JSON.generate(expected_body),
              anything,
            ).and_return(stub_response(code: 200, body: { value: [] }.to_json))

            tag_client.list_attached_tags_on_objects('vm-solo')
          end
        end

        describe 'error handling' do
          it 'raises TagClientError on non-2xx responses' do
            allow(http_client).to receive(:get).and_return(stub_response(code: 500, body: 'boom'))
            expect { tag_client.list_categories }.to raise_error(TagClientError, /HTTP 500.*boom/)
          end
        end
      end

      describe 'live HTTPS round-trip against a self-signed cert' do
        let(:ca_cert_file) { certificate(:success).path }

        it 'pins the CA when calling vCenter' do
          tag_client_with_ca = TagClient.new(
            host: "localhost:#{@server.port}",
            username: 'admin',
            password: 'password',
            ca_cert_file: ca_cert_file,
          )
          backing_client = tag_client_with_ca.instance_variable_get(:@http_client).backing_client
          expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
          expect(backing_client.ssl_config.cert_store_items).to include(ca_cert_file)

          response = backing_client.get("https://localhost:#{@server.port}")
          expect(response.body).to eq('success')
        end
      end

      describe '.new_from_config' do
        let(:soap_log) { StringIO.new }
        let(:cloud_config) do
          instance_double(
            VSphereCloud::Config,
            vcenter_host: 'vc.example.test',
            vcenter_user: 'u',
            vcenter_password: 'p',
            vcenter_connection_options: connection_options,
            soap_log: soap_log,
          )
        end
        let(:connection_options) { {} }

        it 'builds a TagClient that skips TLS verification when ca_cert_file is absent' do
          client = TagClient.new_from_config(cloud_config)
          backing_client = client.instance_variable_get(:@http_client).backing_client
          expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        end

        context 'when vcenter.connection_options.ca_cert_file is set' do
          let(:ca_cert_file) { certificate(:success).path }
          let(:connection_options) { { 'ca_cert_file' => ca_cert_file } }

          it 'builds a TagClient that pins the CA bundle' do
            client = TagClient.new_from_config(cloud_config)
            backing_client = client.instance_variable_get(:@http_client).backing_client
            expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
            expect(backing_client.ssl_config.cert_store_items).to include(ca_cert_file)
          end
        end

        context 'when vcenter.connection_options.ca_cert_file is blank' do
          let(:connection_options) { { 'ca_cert_file' => '' } }

          it 'treats blank as absent' do
            client = TagClient.new_from_config(cloud_config)
            backing_client = client.instance_variable_get(:@http_client).backing_client
            expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
          end
        end

        context 'when vcenter_connection_options is nil' do
          let(:connection_options) { nil }

          it 'still constructs a TagClient with no CA' do
            client = TagClient.new_from_config(cloud_config)
            backing_client = client.instance_variable_get(:@http_client).backing_client
            expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
          end
        end

        context 'with a live local server' do
          let(:cloud_config) do
            instance_double(
              VSphereCloud::Config,
              vcenter_host: "localhost:#{@server.port}",
              vcenter_user: 'admin',
              vcenter_password: 'password',
              vcenter_connection_options: {},
              soap_log: soap_log,
            )
          end

          it 'wires up cloud_config.soap_log and logs HTTP traffic correctly' do
            client = TagClient.new_from_config(cloud_config)
            expect { client.login }.to raise_error(VSphereCloud::TaggingTag::TagClientError, /Malformed JSON response payload on create CIS session/)

            log_output = soap_log.string
            expect(log_output).to include('POST')
            expect(log_output).to include('/rest/com/vmware/cis/session')
            expect(log_output).to include('Status: 200 OK')
            expect(log_output).to include('Response Body:')
            expect(log_output).to include('success')
            expect(log_output).to include('Authorization: Basic [REDACTED]')
            expect(log_output).not_to include('Basic YWRtaW46cGFzc3dvcmQ=') # admin:password in basic auth
          end
        end
      end

      describe 'LogRedactor' do
        let(:log_io) { StringIO.new }
        subject(:redactor) { LogRedactor.new(log_io) }

        it 'redacts session tokens, headers, and authorization' do
          redactor << "Authorization: Basic dGVzdDp0ZXN0\n"
          redactor << "vmware-api-session-id: some-sensitive-token-123\n"
          redactor << '{"value":"sensitive-session-id"}' + "\n"
          redactor << "some normal logs here\n"

          output = log_io.string
          expect(output).to include('Authorization: Basic [REDACTED]')
          expect(output).not_to include('dGVzdDp0ZXN0')
          expect(output).to include('vmware-api-session-id: [REDACTED]')
          expect(output).not_to include('some-sensitive-token-123')
          expect(output).to include('{"value":"[REDACTED]"}')
          expect(output).not_to include('sensitive-session-id')
          expect(output).to include('some normal logs here')
        end
      end

      describe '#parse_value' do
        let(:response) { double('HTTP::Message', code: 200, body: body) }

        context 'when response contains a valid value key' do
          let(:body) { '{"value":"some-value"}' }

          it 'extracts and returns the value' do
            expect(tag_client.send(:parse_value, response, 'test action')).to eq('some-value')
          end
        end

        context 'when response contains malformed JSON' do
          let(:body) { '{"value":' }

          it 'raises TagClientError' do
            expect {
              tag_client.send(:parse_value, response, 'test action')
            }.to raise_error(TagClientError, /Malformed JSON response payload on test action \(HTTP 200\):/)
          end
        end

        context 'when response is missing the value key' do
          let(:body) { '{"wrong_key":"some-value"}' }

          it 'raises TagClientError' do
            expect {
              tag_client.send(:parse_value, response, 'test action')
            }.to raise_error(TagClientError, /Malformed JSON response payload on test action \(HTTP 200\):/)
          end
        end
      end
    end
  end
end
