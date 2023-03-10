require 'spec_helper'
require 'cloud/vsphere/disk_placement_selection_pipeline'
require 'cloud/vsphere/resources/datastore'

describe VSphereCloud::VmPlacementSelectionPipeline do
  subject { described_class.new(*criteria) {[placement_1, placement_2]} }

  def fake_placement(cluster)
    VSphereCloud::VmPlacement.new(cluster: cluster, datastores: cluster.accessible_datastores.values, hosts: nil)
  end


  def fake_datastore(name, free_space: 4096)
    VSphereCloud::Resources::Datastore.new(
      name, instance_double('VimSdk::Vim::Datastore'), true, 8192, free_space
    ).tap do |resource|
      allow(resource).to receive(:accessible?).and_return(true)
    end
  end

  def fake_cluster(name, *args)
    instance_double('VSphereCloud::Resources::Cluster',
      :name => name,
      :free_memory => VSphereCloud::Resources::Cluster::FreeMemory.new(8192),
      :accessible_datastores => args.map{|ds| [ds.name, ds]}.to_h )
  end

  # Simulating a mini datacenter with two clusters. Each cluster has two dedicated datastores and one shared datastore.
  let(:criteria) { [disk_config: disk_config, req_memory: 1024] }
  let(:ds_cl1_1) { fake_datastore('fake-ds-cl1-1') }
  let(:ds_cl1_2) { fake_datastore('fake-ds-cl1-2') }
  let(:ds_cl2_1) { fake_datastore('fake-ds-cl2-1') }
  let(:ds_cl2_2) { fake_datastore('fake-ds-cl2-2') }
  let(:ds_shared) { fake_datastore('fake-ds-shared') }
  let(:cluster_1) { fake_cluster('fake-cluster-1', ds_cl1_1, ds_cl1_2, ds_shared) }
  let(:cluster_2) { fake_cluster('fake-cluster-2', ds_cl2_1, ds_cl2_2, ds_shared) }
  let(:placement_1) { fake_placement(cluster_1) }
  let(:placement_2) { fake_placement(cluster_2) }
  let(:disk_config) {[]}

  context 'when there are no disks to be configured' do
    it 'only generates placements with enough cluster memory' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow(cluster_1).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(1024, 1024))
      allow(cluster_2).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(2048, 2048))
      expect(subject.to_a).to contain_exactly(placement_2)
    end

    it 'sorts the placements in ascending order of migration size' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow(placement_1).to receive(:migration_size).and_return (20)
      allow(placement_2).to receive(:migration_size).and_return (10)
      expect(subject.to_a.first).to eq(placement_2)
    end

    it 'sorts the placements in descending order of balance score if migration size is same' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow_any_instance_of(VSphereCloud::VmPlacement).to receive(:migration_size).and_return(10)
      allow(placement_1).to receive(:balance_score).and_return (10)
      allow(placement_2).to receive(:balance_score).and_return (20)
      expect(subject.to_a.first).to eq(placement_2)
    end

    it 'sorts the placements in descending order of free memory in the host group if migration size and balance score are same' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow_any_instance_of(VSphereCloud::VmPlacement).to receive(:migration_size).and_return(10)
      allow_any_instance_of(VSphereCloud::VmPlacement).to receive(:balance_score).and_return(10)
      allow(placement_1).to receive(:host_group_free_memory).and_return (10000)
      allow(placement_2).to receive(:host_group_free_memory).and_return (20000)
      expect(subject.to_a.first).to eq(placement_2)
    end

    it 'sorts the placements in ascending order of migration size then descending order of balance score and then free memory' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      placement_4 = placement_3 = placement_5 = placement_1.dup
      allow(placement_1).to receive_messages(:host_group_free_memory => 10000, :balance_score => 10 , :migration_size => 10)
      allow(placement_2).to receive_messages(:host_group_free_memory => 20000, :balance_score => 10 , :migration_size => 10)
      allow(placement_3).to receive_messages(:host_group_free_memory => 10000, :balance_score => 4 , :migration_size => 5)
      allow(placement_4).to receive_messages(:host_group_free_memory => 10000, :balance_score => 7 , :migration_size => 5)
      allow(placement_5).to receive_messages(:host_group_free_memory => 40000, :balance_score => 10 , :migration_size => 1)
      pipeline = described_class.new(*criteria) {[placement_1, placement_2, placement_3, placement_4, placement_5]}
      expect(pipeline.to_a).to eq([placement_5, placement_4, placement_3, placement_2, placement_1])
    end

    it 'returns the cluster when it has enough cluster memory and does not have enough host group memory' do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow(cluster_1).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(2048, 1024))
      allow(cluster_2).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(1024, 1024))
      expect(subject.to_a).to contain_exactly(placement_1)
    end
  end

  context 'when there are three disks to be configured' do
    let(:disk_config_1) { VSphereCloud::DiskConfig.new(size: 10, ephemeral: true, target_datastore_pattern: '.*') }
    let(:disk_config_2) { VSphereCloud::DiskConfig.new(size: 10, target_datastore_pattern: '.*') }
    let(:disk_config_3) { VSphereCloud::DiskConfig.new(size: 10, target_datastore_pattern: '.*') }
    let(:disk_config) { [disk_config_1, disk_config_3, disk_config_2] }
    before do
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
      allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:accessible_from?).with(anything).and_return(true)
    end
    it 'generates placements that satisfy all criteria' do
      expect(subject.to_a).to match_array([placement_2, placement_1])
    end

    context 'when one of the disk config has datastore pattern that matches only datastore belonging to one cluster' do
      let(:disk_config_1) { VSphereCloud::DiskConfig.new(size: 10, ephemeral: true, target_datastore_pattern: '.*cl1-1') }
      it 'only generates placement which has datastore matching the target datastore pattern for a disk config' do
        expect(subject.to_a).to contain_exactly(placement_1)
      end
    end

    context 'when disk config are such that their sizes cannot fit onto all datastores of one of the cluster' do
      before do
        allow(ds_cl1_1).to receive(:free_space).and_return(0)
        allow(ds_cl1_2).to receive(:free_space).and_return(0)
        allow(ds_shared).to receive(:free_space).and_return(0)
      end
      it 'only generates placement which has datastores with enough free space to accommodate the disk' do
        expect(subject.to_a).to contain_exactly(placement_2)
      end
    end

    context 'when there is only one datastore with each cluster and datastore is shared' do
      let(:cluster_1) { fake_cluster('fake-cluster-1', ds_shared) }
      let(:cluster_2) { fake_cluster('fake-cluster-2', ds_shared) }
      context 'when shared datastores is not accessible from one of the cluster' do
        it 'only generates placement which has datastores accessible from the cluster in the placement' do
          allow(ds_shared).to receive(:accessible_from?).with(cluster_1).and_return(false)
          allow(ds_shared).to receive(:accessible_from?).with(cluster_2).and_return(true)
          expect(subject.to_a).to contain_exactly(placement_2)
        end
      end
    end
    context 'when there alternative datastores available' do
      before do
        allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:maintenance_mode?).and_return(false)
        allow_any_instance_of(VSphereCloud::Resources::Datastore).to receive(:accessible_from?).with(anything).and_return(true)
        allow(cluster_1).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(2048, 1024))
        allow(cluster_2).to receive(:free_memory).and_return(VSphereCloud::Resources::Cluster::FreeMemory.new(1024, 1024))
      end

      let(:disk_config_1) { VSphereCloud::DiskConfig.new(size: 10, ephemeral: true, target_datastore_pattern: 'fake-ds-cl1-.*') }
      let(:disk_config) { [disk_config_1] }

      it 'it sets them on the VmPlacement object' do
        primary_placement = subject.each.first
        fallback = primary_placement.disk_placement == ds_cl1_1 ? ds_cl1_2 : ds_cl1_1
        expect(primary_placement.fallback_disk_placements).to contain_exactly(fallback)
      end
    end
  end
end
