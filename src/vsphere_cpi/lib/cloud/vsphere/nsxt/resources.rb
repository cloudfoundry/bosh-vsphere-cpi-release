require 'cgi'

module VSphereCloud
  module NSXT
    class VirtualMachine < Struct.new(:external_id)
      def initialize(**kwargs)
        super(*members.map { |k| kwargs[k] })
      end
    end

    class NSGroup < Struct.new(:id, :display_name)
      def initialize(client, **kwargs)
        super(*members.map { |k| kwargs[k] })
        @client = client
      end

      def href
        "ns-groups/#{CGI.escape(id)}"
      end

      def add_member(logical_port)
        json = @client.post(href, query: {
          action: 'ADD_MEMBERS'
        }, body: {
          members: [{
            resource_type: 'NSGroupSimpleExpression',
            op: 'EQUALS',
            target_type: 'LogicalPort',
            value: logical_port.id,
            target_property: 'id',
          }]
        }).body
        NSGroup.new(@client, id: json['id'], display_name: json['display_name'])
      end
    end

    class VIF < Struct.new(:lport_attachment_id)
      def initialize(**kwargs)
        super(*members.map { |k| kwargs[k] })
      end
    end

    class LogicalPort < Struct.new(:id)
      def initialize(**kwargs)
        super(*members.map { |k| kwargs[k] })
      end
    end
  end
end