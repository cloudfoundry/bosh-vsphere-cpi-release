require 'cgi'

module VSphereCloud
  module NSXT
    class VirtualMachine < Struct.new(:external_id)
      def initialize(**kwargs)
        super(*members.map { |k| kwargs[k] })
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

    class NSGroup
      class SimpleExpression < Struct.new(:target_type, :target_property, :op, :value)
        def initialize(**kwargs)
          super(*members.map { |k| kwargs[k] })
        end
      end

      attr_reader :id, :display_name, :members

      def initialize(client, id:, display_name:, members: nil)
        @client = client
        @id = id
        @display_name = display_name

        if members.nil?
          @members = []
        else
          @members = members.map do |member|
            SimpleExpression.new(
              target_type: member['target_type'],
              target_property: member['target_property'],
              op: member['op'],
              value: member['value']
            )
          end
        end
      end

      def inspect
        "#<NSGroup:#{@id.inspect} @display_name=#{@display_name.inspect}, @members=#{@members.inspect}>"
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
        NSGroup.new(@client, id: json['id'], display_name: json['display_name'], members: json['members'])
      end

      def remove_member(logical_port)
        json = @client.post(href, query: {
          action: 'REMOVE_MEMBERS'
        }, body: {
          members: [{
            resource_type: 'NSGroupSimpleExpression',
            op: 'EQUALS',
            target_type: 'LogicalPort',
            value: logical_port.id,
            target_property: 'id',
          }]
        }).body
        NSGroup.new(@client, id: json['id'], display_name: json['display_name'], members: json['members'])
      end
    end
  end
end