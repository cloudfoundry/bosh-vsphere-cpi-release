require 'spec_helper'

describe VSphereCloud::VmPlacement do
  subject do
    described_class.new(cluster: 'cluster', hosts: 'hosts', datastores: 'datastores')
  end

  describe '#initialize' do
    it 'initializes all the variables correctly' do
      expect(subject.balance_score_set).to be_empty
      expect(subject.migration_size).to eq(0)
      expect(subject.cluster).to eq('cluster')
      expect(subject.hosts).to eq('hosts')
      expect(subject.datastores).to eq('datastores')
    end
  end
end
