require 'spec_helper'

describe VSphereCloud::Resources::ResourcePool, fake_logger: true do
  subject { VSphereCloud::Resources::ResourcePool.new(fake_client, cluster_config, root_resource_pool_mob, datacenter_name) }
  let(:fake_client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:datacenter_name) { 'fake- dc' }
  let(:cluster_config) do
    instance_double('VSphereCloud::ClusterConfig', name: 'fake -cluster-name', resource_pool: cluster_resource_pool)
  end
  let(:cluster_resource_pool) { nil }
  let(:root_resource_pool_mob) { instance_double('VimSdk::Vim::ResourcePool', name: 'fake-rp') }

  describe '#initialize' do

    context 'when the cluster config does not provide a resource pool' do
      it 'uses the root resource pool' do
        expect(subject.mob).to eq(root_resource_pool_mob)
      end
    end

    context 'when the cluster config provides a resource pool' do
      let(:resource_pool_mob) { instance_double('VimSdk::Vim::ResourcePool') }
      context 'when CPI is able to locate resource pool with inventory path' do
        let(:cluster_resource_pool) { 'cluster-resource-pool' }
        before do
          allow(fake_client).to receive_message_chain(:service_content, :search_index, :find_by_inventory_path)
                                       .with("fake- dc/host/fake -cluster-name/Resources/#{cluster_resource_pool}")
                                       .and_return(resource_pool_mob)
        end
        it 'uses the cluster config resource pool' do
          expect(subject.mob).to eq(resource_pool_mob)
        end
      end
      context 'when CPI is not able to locate resource pool with inventory path' do
        let(:cluster_resource_pool) { 'cluster-resource-pool' }
        let(:resource_pool_mob) { instance_double('VimSdk::Vim::ResourcePool', name: 'fake-rp') }
        before do
          expect(fake_client).to receive_message_chain(:service_content, :search_index, :find_by_inventory_path)
                               .with("fake- dc/host/fake -cluster-name/Resources/#{cluster_resource_pool}")
                               .and_return(nil)
        end
        it 'uses the property collector to fetch the resource pool' do
          expect(cloud_searcher).to receive(:get_managed_object)
                                       .with(VimSdk::Vim::ResourcePool, root: root_resource_pool_mob, name: cluster_resource_pool)
                                       .and_return(resource_pool_mob).once

          expect(subject.mob).to eq(resource_pool_mob)
        end
      end
      context 'when provided resource pool name is malformed' do
        context 'when provided resource pool path has extra /<s>' do
          let(:cluster_config) do
            instance_double('VSphereCloud::ClusterConfig', name: 'fake&-cluster-name', resource_pool: '///////vcpi-rp///vcpi-sub-rp//')
          end
          it 'removes the extra slashes and then finds resource pool' do
            expect(fake_client).to receive_message_chain(:service_content, :search_index, :find_by_inventory_path)
                                        .with("fake- dc/host/fake&-cluster-name/Resources/vcpi-rp/vcpi-sub-rp")
                                        .and_return(resource_pool_mob)
            expect(subject.mob).to eq(resource_pool_mob)
          end
        end
      end
    end
  end

  describe '#inspect' do
    it 'returns the printable form' do
      expect(subject.inspect).to eq("<Resource Pool: #{root_resource_pool_mob}>")
    end
  end
end
