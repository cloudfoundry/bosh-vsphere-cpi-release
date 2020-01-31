require 'spec_helper'

module VSphereCloud
  describe ClusterConfig do
    subject(:cluster_config) { described_class.new(name, config) }
    let(:name) { 'fake-cluster-name' }
    let(:config) do
      {
        'resource_pool' => 'fake-resource-pool',
        'host_group' => {'name' => 'fake-host-group', 'drs_rule' => 'MUST'},
      }
    end

    describe '#name' do
      it 'returns the cluster name' do
        expect(cluster_config.name).to eq(name)
      end
    end

    describe '#resource_pool' do
      it 'returns the resource pool name' do
        expect(cluster_config.resource_pool).to eq('fake-resource-pool')
      end
    end

    describe '#host_group_name' do
      it 'returns the host group name' do
        expect(cluster_config.host_group_name).to eq('fake-host-group')
      end
      context 'when host group is not defined' do
        let(:config){ {'resource_pool' => 'fake-resource-pool'} }
        it 'returns nil' do
          expect(cluster_config.host_group_name).to be_nil
        end
      end
      context 'when host group is defined in backward compatible way' do
        let(:config){ {'resource_pool' => 'fake-resource-pool', 'host_group' => 'vcpi-cl1-hg-1'} }
        it 'returns host group name' do
          expect(cluster_config.host_group_name).to eq('vcpi-cl1-hg-1')
        end
      end
    end

    describe '#host_group_drs_rule' do
      it 'returns the host group drs rule condition' do
        expect(cluster_config.host_group_drs_rule).to eq('MUST')
      end
      context 'when host group is not defined' do
        let(:config){ {'resource_pool' => 'fake-resource-pool'} }
        it "returns the default rule as 'MUST'" do
          expect(cluster_config.host_group_drs_rule).to eq('MUST')
        end
      end
      context 'when host group is defined in backward compatible way' do
        let(:config){ {'resource_pool' => 'fake-resource-pool', 'host_group' => 'vcpi-cl1-hg-1'} }
        it "returns the default rule as 'MUST'" do
          expect(cluster_config.host_group_drs_rule).to eq('MUST')
        end
      end
      context 'when host group is defined as a HASH of name and rule with rule not present' do
        let(:config){ {'resource_pool' => 'fake-resource-pool', 'host_group' => {'name' => 'vcpi-cl1-hg-1'}} }
        it "returns the default rule as 'SHOULD'" do
          expect(cluster_config.host_group_drs_rule).to eq('SHOULD')
        end
      end
    end
  end
end
