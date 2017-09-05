require 'spec_helper'

include VSphereCloud::NSXT

describe NSGroup do
  subject(:nsgroup) do
    described_class.new(client, 'fake-id', 'fake-display-name', [])
  end
  let(:client) { instance_double(JSONClient) }
  let(:path) { 'ns-groups/fake-id' }
  let(:expression_1) do
    NSGroup::SimpleExpression.new('EQUALS', 'LogicalPort', 'id', 'fake-lport-id-1')
  end
  let(:expression_2) do
    NSGroup::SimpleExpression.new('EQUALS', 'LogicalPort', 'id', 'fake-lport-id-2')
  end
  let(:body) { { members: [expression_1.to_h, expression_2.to_h] } }
  let(:response) { instance_double(HTTP::Message, body: body) }

  context '#json_create' do
    let(:members) do
      [
        {
          'resource_type' => 'NSGroupSimpleExpression',
          'op' => 'EQUALS',
          'target_type' => 'LogicalPort',
          'target_property' => 'id',
          'value' => 'lport-id'
        },
        {
          'resource_type' => 'NSGroupTagExpression',
          'scope' => 'Tenant',
          'scope_op' => 'EQUALS',
          'tag' => 'fake-tag',
          'tag_op' => 'EQUALS',
          'target_type' => 'LogicalPort'
        },
        {
          'resource_type' => 'NSGroupComplexExpression',
          'expressions' => []
        }
      ]
    end
    let(:nsgroup_hash) do
      {
        'resource_type' => 'NSGroup',
        'id' => 'fake-id',
        'display_name' => 'fake-display-name',
        'members' => members
      }
    end

    it 'returns a NSGroup instance with members as proper types' do
      nsgroup_instance = described_class.json_create(client, nsgroup_hash)

      expect(nsgroup_instance).not_to be_nil

      members = nsgroup_instance.members
      expect(members).to_not be_nil
      expect(members.length).to eq(3)

      expect(members[0]).to be_a(NSGroup::SimpleExpression)
      expect(members[1]).to be_a(NSGroup::TagExpression)
      expect(members[2]).to be_a(NSGroup::ComplexExpression)
    end
  end

  context '#to_h' do
    it "returns Resource hash with 'resource_type'" do
      expect(nsgroup.to_h).to include(
        :id => 'fake-id',
        :display_name => 'fake-display-name',
        :members => [],
        :client => client,
        :resource_type => 'NSGroup'
      )
    end
  end

  context '#add_members' do
    let(:query) { { action: 'ADD_MEMBERS' } }

    before do
      expect(client).to receive(:post).with(path, query: query, body: body).and_return(response)
    end

    it 'posts to ns-groups/<group-id>' do
      nsgroup.add_members(expression_1, expression_2)
    end
  end

  context '#remove_members' do
    let(:query) { { action: 'REMOVE_MEMBERS' } }

    before do
      expect(client).to receive(:post).with(path, query: query, body: body).and_return(response)
    end

    it 'posts to ns-groups/<group-id>' do
      nsgroup.remove_members(expression_1, expression_2)
    end
  end
end

describe NSGroup::ComplexExpression do
  let(:complex_expression) do
    {
      'resource_type' => 'NSGroupComplexExpression',
      'expressions' => [
        {
          'resource_type' => 'NSGroupSimpleExpression',
          'op' => 'EQUALS',
          'target_type' => 'LogicalPort',
          'target_property' => 'id',
          'value' => 'lport-id-2'
        },
        {
          'resource_type' => 'NSGroupTagExpression',
          'scope' => 'Tenant',
          'scope_op' => 'EQUALS',
          'tag' => 'fake-tag-2',
          'tag_op' => 'EQUALS',
          'target_type' => 'LogicalPort'
        },
        {
          'resource_type' => 'NSGroupComplexExpression',
          'expressions' => [
            {
              'resource_type' => 'NSGroupComplexExpression',
              'expressions' => []
            }
          ]
        }
      ]
    }
  end

  context '#json_create' do
    it 'returns a ComplexExpression instance with expressions as proper types' do
      instance = described_class.json_create(nil, complex_expression)

      expect(instance).not_to be_nil

      nested_exp = instance.expressions
      expect(nested_exp).to_not be_nil
      expect(nested_exp.length).to eq(3)

      expect(nested_exp[0]).to be_a(NSGroup::SimpleExpression)
      expect(nested_exp[1]).to be_a(NSGroup::TagExpression)
      expect(nested_exp[2]).to be_a(NSGroup::ComplexExpression)

      expect(nested_exp[2].expressions).to_not be_nil
      expect(nested_exp[2].expressions.length).to eq(1)
      expect(nested_exp[2].expressions[0]).to be_a(NSGroup::ComplexExpression)
      expect(nested_exp[2].expressions[0].expressions.length).to eq(0)
    end
  end
end

describe NSGroup::SimpleExpression do
  context '#from_resource' do
    let(:vif_resource) { VIF.new('fake_lport_attachment_id') }
    let(:logical_port) { LogicalPort.new('fake_id') }

    it 'raises an error if resource is not a LogicalPort' do
      expect do
        described_class.from_resource(vif_resource, 'id')
      end.to raise_error(InvalidExpressionResource)
    end

    it 'returns an instance of SimpleExpression for given resource' do
      simple_expression = described_class.from_resource(logical_port, 'id')
      expect(simple_expression).to be_a(described_class)
      expect(simple_expression.op).to eq('EQUALS')
      expect(simple_expression.target_type).to eq('LogicalPort')
      expect(simple_expression.target_property).to eq('id')
      expect(simple_expression.value).to eq('fake_id')
    end
  end
end

