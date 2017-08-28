require 'jsonclient'
require 'pry-byebug'

module VSphereCloud
  module NSXT
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

        @client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      def nsgroups
        json = @client.get('ns-groups').body
        json['results'].map do |result|
          NSGroup.new(@client, id: result['id'], display_name: result['display_name'], members: result['members'])
        end
      end

      def virtual_machines(display_name:)
        json = @client.get('fabric/virtual-machines', query: {
          display_name: display_name
        }).body
        json['results'].map do |result|
          VirtualMachine.new(external_id: result['external_id'])
        end
      end

      def vifs(owner_vm_id:)
        json = @client.get('fabric/vifs', query: {
          owner_vm_id: owner_vm_id
        }).body
        json['results'].map do |result|
          VIF.new(lport_attachment_id: result['lport_attachment_id'])
        end
      end

      def logical_ports(attachment_id:)
        json = @client.get('logical-ports', query: {
          attachment_id: attachment_id
        }).body
        json['results'].map do |result|
          LogicalPort.new(id: result['id'])
        end
      end

      # Use this private method in HTTPClient
      def success_content(res)
        @client.send(:success_content, res)
      end
    end
  end
end