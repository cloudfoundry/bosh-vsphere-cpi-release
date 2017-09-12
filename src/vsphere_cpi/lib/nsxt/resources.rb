require 'cgi'

module NSXT
  class InvalidExpressionResource < StandardError; end
  class InvalidType < StandardError; end

  class Resource < Struct
    def self.json_create(client, hash)
      resource = new(*members.map { |k| hash[k.to_s] })
      resource.client = client if resource.respond_to?(:client)
      resource.json_data = hash if resource.respond_to?(:json_data=)
      resource
    end

    def client=(val)
      # no op
    end

    def self.resource_type
      nil
    end

    def resource_type
      self.class.resource_type
    end

    def to_h
      return super if resource_type.nil?

      h = super
      h[:resource_type] = resource_type
      h.delete(:client)
      h
    end
 end

  class VirtualMachine < Resource.new(:external_id)
    def self.resource_type
      'VirtualMachine'
    end
  end

  class VIF < Resource.new(:lport_attachment_id)
    def self.resource_type
      'VirtualNetworkInterface'
    end
  end

  class LogicalPort < Resource.new(:client, :id, :tags, :json_data)
    def self.resource_type
      'LogicalPort'
    end

    def update(hash)
      response = client.put(href, body: json_data.merge(hash))
      if response.ok?
        self.tags = response.content['tags']
      end
      response
    end

    def reload!
      response = client.get(href)
      if response.ok?
        self.json_data = response.body
        self.tags = json_data['tags']
      else
        raise Error.new(response.status_code), response.body
      end
    end

    private

    def href
      "logical-ports/#{CGI.escape(id)}"
    end
  end

  class NSGroup < Resource.new(:client, :id, :display_name, :members)
    class ExpressionFactory
      def self.create(members)
        return [] if members.nil?

        result = []
        members.map do |m|
          case m['resource_type']
          when SimpleExpression.resource_type
            result << SimpleExpression.json_create(nil, m)
          when TagExpression.resource_type
            result << TagExpression.json_create(nil, m)
          when ComplexExpression.resource_type
            result << ComplexExpression.json_create(nil, m)
          end
        end

        result
      end
    end

    class SimpleExpression < Resource.new(:op, :target_type, :target_property, :value)
      def self.from_resource(resource, target_property, op = 'EQUALS')
        raise InvalidExpressionResource unless resource.is_a?(LogicalPort)

        SimpleExpression.new(
          op,
          resource.class.resource_type,
          target_property,
          resource.send(target_property)
        )
      end

      def self.resource_type
        'NSGroupSimpleExpression'
      end
    end
    class TagExpression < Resource.new(:scope, :scope_op, :tag, :tag_op, :target_type)
      def self.resource_type
        'NSGroupTagExpression'
      end
    end
    class ComplexExpression < Resource.new(:expressions)
      def self.json_create(client, hash)
        hash['expressions'] = ExpressionFactory.create(hash['expressions'])
        new(*members.map { |k| hash[k.to_s] })
      end

      def self.resource_type
        'NSGroupComplexExpression'
      end
    end

    def self.json_create(client, hash)
      hash['members'] = ExpressionFactory.create(hash['members'])
      super(client, hash)
    end

    def add_members(*members)
      client.post(href, query: {
        action: 'ADD_MEMBERS'
      }, body: {
        members: members.map(&:to_h)
      })
    end

    def remove_members(*members)
      client.post(href, query: {
        action: 'REMOVE_MEMBERS'
      }, body: {
        members: members.map(&:to_h)
      })
    end

    private

    def href
      "ns-groups/#{CGI.escape(id)}"
    end

    def self.resource_type
      'NSGroup'
    end
  end
end
