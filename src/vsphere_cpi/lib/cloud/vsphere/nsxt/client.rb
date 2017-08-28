require 'jsonclient'
require 'pry-byebug'

module VSphereCloud
  module NSXT
    class Error < StandardError
      attr_reader :status_code, :error

      def initialize(status_code, error = nil)
        @status_code = status_code
        @error = error
      end
    end

    class Client
      def initialize(host, username, password, http_log = nil)
        # The trailing / is important for a well behaved base_url
        root = URI::HTTPS.build(host: host, path: '/api/v1/')

        @client = JSONClient.new(base_url: root)

        @client.set_auth(root, username, password)
        # NSX-T returns 403, not 401, so we need force basic auth from the get-go
        @client.force_basic_auth = true

        if ENV['BOSH_NSXT_CA_CERT_FILE']
          @client.ssl_config.add_trust_ca(ENV['BOSH_NSXT_CA_CERT_FILE'])
        end
      end

      def nsgroups
        get_results('ns-groups') do |result|
          NSGroup.new(@client, id: result['id'], display_name: result['display_name'], members: result['members'])
        end
      end

      def virtual_machines(display_name:)
        get_results('fabric/virtual-machines', display_name: display_name) do |result|
          VirtualMachine.new(external_id: result['external_id'])
        end
      end

      def vifs(owner_vm_id:)
        get_results('fabric/vifs', owner_vm_id: owner_vm_id) do |result|
          VIF.new(lport_attachment_id: result['lport_attachment_id'])
        end
      end

      def logical_ports(attachment_id:)
        get_results('logical-ports', attachment_id: attachment_id) do |result|
          LogicalPort.new(id: result['id'])
        end
      end

      private

      def get_results(path, query = {}, &block)
        response = @client.get(path, query: query)
        if response.ok?
          response.body['results'].map(&block)
        else
          raise Error.new(response.status_code), response.body
        end
      end
    end
  end
end