require 'json'
require 'base64'
require 'uri'
require 'cloud/vsphere/base_http_client'

module VSphereCloud
  module TaggingTag
    # Raised when the vCenter CIS tagging REST API returns a non-2xx response.
    class TagClientError < StandardError
      attr_reader :code, :response_body

      def initialize(message, code: nil, response_body: nil)
        super(message)
        @code = code
        @response_body = response_body
      end
    end

    # TagClient implements just enough of the vCenter CIS tagging REST API for
    # the CPI's set_vm_metadata flow.
    #
    # We previously delegated to vsphere-automation-sdk-ruby (vsphere-automation-cis
    # and vsphere-automation-vcenter), but that SDK was archived upstream in 2021
    # and its Configuration#ssl_ca_cert is silently ignored by its ApiClient.
    # That bug made it impossible to enable peer verification while trusting a
    # custom CA bundle, which broke deployments using self-signed vCenter certs
    # the moment we tried to honor the SAST fix that enabled verification.
    #
    # This implementation builds on the same BaseHttpClient that vCenter SOAP and
    # NSX use, so CA pinning and skip-verify behavior are both consistent and
    # exercised by the existing http client unit tests.
    class TagClient
      CIS_PATH = '/rest/com/vmware/cis'.freeze
      SESSION_HEADER = 'vmware-api-session-id'.freeze

      attr_reader :session_id

      # Factory method to build a TagClient from the global BOSH CPI configuration.
      # @param cloud_config [VSphereCloud::Config] BOSH CPI configuration object
      # @return [TagClient] a pre-configured TagClient instance
      def self.new_from_config(cloud_config)
        connection_options = cloud_config.vcenter_connection_options || {}
        raw_ca = connection_options['ca_cert_file']
        ca_file = raw_ca.to_s.strip
        ca_file = nil if ca_file.empty?

        new(
          host: cloud_config.vcenter_host,
          username: cloud_config.vcenter_user,
          password: cloud_config.vcenter_password,
          ca_cert_file: ca_file,
          http_log: cloud_config.soap_log,
        )
      end

      # @param host [String] vCenter hostname (no scheme; may include port)
      # @param username [String]
      # @param password [String]
      # @param ca_cert_file [String, nil] path to a PEM bundle; when nil/blank
      #   TLS verification is disabled (preserving prior behavior for
      #   deployments that never configured a CA).
      # @param http_log [IO, String, nil] optional log destination for HTTP traffic.
      def initialize(host:, username:, password:, ca_cert_file: nil, http_log: nil)
        @host = host
        @username = username
        @password = password
        @base_url = "https://#{host}"

        normalized_ca = ca_cert_file.to_s.strip
        @ca_cert_file = normalized_ca.empty? ? nil : normalized_ca

        @http_client = if @ca_cert_file
          BaseHttpClient.new(
            http_log: http_log,
            trusted_ca_file: @ca_cert_file,
            ca_cert_manifest_key: 'vcenter.connection_options.ca_cert',
            skip_ssl_verify: false,
          )
        else
          BaseHttpClient.new(
            http_log: http_log,
            skip_ssl_verify: true,
          )
        end
      end

      # Opens an authenticated CIS session and caches the session id for
      # subsequent calls. Safe to call multiple times.
      def login
        return @session_id if @session_id

        basic_token = Base64.strict_encode64("#{@username}:#{@password}")
        response = @http_client.post(
          "#{@base_url}#{CIS_PATH}/session",
          '',
          {
            'Authorization' => "Basic #{basic_token}",
            'Accept' => 'application/json',
          }
        )
        ensure_success!(response, 'create CIS session')

        @session_id = parse_value(response)
      end

      def logout
        return unless @session_id
        @http_client.delete(
          "#{@base_url}#{CIS_PATH}/session",
          { SESSION_HEADER => @session_id }
        )
      rescue StandardError # rubocop:disable Lint/SuppressedException
      ensure
        @session_id = nil
      end

      def list_categories
        login
        response = authed_request(:get, "#{CIS_PATH}/tagging/category")
        ensure_success!(response, 'list tagging categories')
        parse_value(response)
      end

      def get_category(category_id)
        login
        response = authed_request(:get, "#{CIS_PATH}/tagging/category/id:#{escape(category_id)}")
        ensure_success!(response, "get tagging category #{category_id}")
        parse_value(response)
      end

      def get_tag(tag_id)
        login
        response = authed_request(:get, "#{CIS_PATH}/tagging/tag/id:#{escape(tag_id)}")
        ensure_success!(response, "get tagging tag #{tag_id}")
        parse_value(response)
      end

      def list_tags_for_category(category_id)
        login
        response = authed_request(
          :post,
          "#{CIS_PATH}/tagging/tag/id:#{escape(category_id)}?~action=list-tags-for-category",
          '',
        )
        ensure_success!(response, "list tags for category #{category_id}")
        parse_value(response)
      end

      def attach_tag(tag_id, vm_mob_id)
        login
        body = {
          'object_id' => {
            'id' => vm_mob_id,
            'type' => 'VirtualMachine',
          },
        }
        response = authed_request(
          :post,
          "#{CIS_PATH}/tagging/tag-association/id:#{escape(tag_id)}?~action=attach",
          JSON.generate(body),
        )
        ensure_success!(response, "attach tag #{tag_id} to vm #{vm_mob_id}")
        nil
      end

      def attach_multiple_tags_to_object(tag_ids, vm_mob_id)
        login
        body = {
          'object_id' => {
            'id' => vm_mob_id,
            'type' => 'VirtualMachine',
          },
          'tag_ids' => tag_ids,
        }
        response = authed_request(
          :post,
          "#{CIS_PATH}/tagging/tag-association?~action=attach-multiple-tags-to-object",
          JSON.generate(body),
        )
        ensure_success!(response, "attach tags #{tag_ids.inspect} to vm #{vm_mob_id}")
        nil
      end

      def list_attached_tags_on_objects(vm_mob_ids)
        login
        body = {
          'object_ids' => Array(vm_mob_ids).map do |id|
            { 'id' => id, 'type' => 'VirtualMachine' }
          end,
        }
        response = authed_request(
          :post,
          "#{CIS_PATH}/tagging/tag-association?~action=list-attached-tags-on-objects",
          JSON.generate(body),
        )
        ensure_success!(response, 'list attached tags on objects')
        parse_value(response)
      end

      private

      def authed_request(method, path, body = nil)
        url = "#{@base_url}#{path}"
        headers = {
          SESSION_HEADER => @session_id,
          'Accept' => 'application/json',
        }
        headers['Content-Type'] = 'application/json' if body

        case method
        when :get
          @http_client.get(url, headers)
        when :post
          @http_client.post(url, body || '', headers)
        when :delete
          @http_client.delete(url, headers)
        else
          raise ArgumentError, "Unsupported HTTP method: #{method.inspect}"
        end
      end

      def parse_value(response)
        return nil if response.body.nil? || response.body.empty?
        JSON.parse(response.body).fetch('value')
      end

      def ensure_success!(response, action)
        code = response.respond_to?(:code) ? response.code.to_i : 0
        return if (200..299).cover?(code)

        body_snippet = (response.body || '').to_s
        body_snippet = body_snippet[0, 500] + '...' if body_snippet.length > 500
        raise TagClientError.new(
          "vCenter CIS tagging REST call failed (#{action}): HTTP #{code} #{body_snippet}",
          code: code,
          response_body: response.body,
        )
      end

      def escape(value)
        URI::DEFAULT_PARSER.escape(value.to_s)
      end
    end
  end
end
