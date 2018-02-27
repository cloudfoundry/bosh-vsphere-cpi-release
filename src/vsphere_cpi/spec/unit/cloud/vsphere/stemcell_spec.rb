require 'spec_helper'
require 'cloud/vsphere/stemcell'

describe VSphereCloud::Stemcell do
  subject { described_class.new(stemcell_id, logger) }
  let(:stemcell_id) { 'fake_stemcell_id' }

  let(:logger) { instance_double('Bosh::Cpi::Logger', info: nil, debug: nil) }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }

  describe '#replicate' do
    let(:template_folder) do
      double(:template_folder,
             path_components: ['fake_template_folder'],
             mob: 'fake_template_folder_mob'
      )
    end

    let(:datacenter) do
      double('fake datacenter',
             client: client,
             name: 'fake_datacenter',
             template_folder: template_folder,
             clusters: [],
             mob: 'fake-datacenter-mob'
      )
    end

    let(:cluster) { double('fake cluster', datacenter: datacenter) }
    let(:target_datastore) do
      instance_double('VSphereCloud::Resources::Datastore', name: 'fake-datastore')
    end

    before do
      mob = double(:mob, __mo_id__: 'fake_datastore_managed_object_id')
      allow(mob).to receive_message_chain(:info, :name).and_return('fake-datastore')
      allow(target_datastore).to receive(:mob).and_return(mob)
    end

    it 'raises an error when no stemcell replica is available' do
      expect(subject).to receive(:find_replica_in).with(datacenter.mob, client).and_return(nil)

      expect do
        subject.replicate(datacenter, cluster, target_datastore)
      end.to raise_error(/Could not find VM for stemcell/)
    end

    context 'when a stemcell vm is on the target datastore' do
      let(:stemcell_vm) { instance_double('VimSdk::Vim::VirtualMachine') }

      before do
        expect(subject).to receive(:find_replica_in).with(datacenter.mob, client).and_return(stemcell_vm)
        expect(subject).to receive(:find_replica_in).with(target_datastore.mob, client).and_return(stemcell_vm)
      end

      it 'returns the stemcell vm' do
        expect(subject.replicate(datacenter, cluster, target_datastore)).to eq(stemcell_vm)
      end
    end

    context 'when the stemcell replica is not found in the datastore' do
      let(:stemcell_vm) { instance_double('VimSdk::Vim::VirtualMachine') }
      let(:replicated_stemcell) { double('fake_replicated_stemcell') }
      let(:fake_task) {'fake_task'}

      it 'replicates the stemcell' do
        expect(subject).to receive(:find_replica_in).with(datacenter.mob, client).and_return(stemcell_vm)
        expect(subject).to receive(:find_replica_in).with(target_datastore.mob, client).and_return(nil)

        resource_pool = double(:resource_pool, mob: 'fake_resource_pool_mob')
        allow(cluster).to receive(:resource_pool).and_return(resource_pool)
        allow(stemcell_vm).to receive(:clone).with(any_args).and_return(fake_task)
        allow(client).to receive(:wait_for_task) do |*args, &block|
          expect(block.call).to eq(fake_task)
          replicated_stemcell
        end
        allow(replicated_stemcell).to receive(:create_snapshot).with(any_args).and_return(fake_task)

        expect(subject.replicate(datacenter, cluster, target_datastore)).to eql(replicated_stemcell)
      end
    end


    context 'when stemcell vm needs to be replicated to a datastore inside datastore_cluster' do
      let(:datastore_with_stemcell) { instance_double('VSphereCloud::Resources::Datastore', :name => 'datastore-with-stemcell') }
      let(:replicated_stemcell) { double('fake_replicated_stemcell') }
      let (:target_datastore_cluster) {instance_double(VSphereCloud::Resources::StoragePod, mob: 'fake_storage_pod_mob')}
      let(:recommended_datastore) { double('datastore', __mo_id__: 'recommended-datastore-id', name: 'fake-ds')}
      let(:fake_task) { 'fake_task' }
      let(:resource_pool) { double(:resource_pool, mob: 'fake_resource_pool_mob') }
      let(:srm) { instance_double(VimSdk::Vim::StorageResourceManager) }
      let(:recommendation) { instance_double(VimSdk::Vim::Cluster::Recommendation, key: 'abc', reason: 'storagePlacement')}

      before do
        expected_options = {datastore_cluster: target_datastore_cluster}
        allow(cluster).to receive(:resource_pool).and_return(resource_pool)
        allow(vsphere_cloud).to receive(:get_recommendation_for_stemcell).with(stemcell_vm, anything, anything, resource_pool.mob, expected_options).and_return(recommendation)
        allow(recommendation).to receive_message_chain(:action, :first, :destination).and_return(recommended_datastore)
        allow(recommendation).to receive_message_chain(:action, :first, :destination, :class).and_return(VimSdk::Vim::Datastore)
        allow(recommendation).to receive_message_chain(:action, :first, :destination, :name).and_return(recommended_datastore.name)
        allow(client).to receive(:find_all_stemcell_replicas).with(datacenter.mob, stemcell_id).and_return([stemcell_vm])
        allow(cloud_searcher).to receive(:get_property).with(stemcell_vm, anything, 'datastore', anything).and_return([datastore_with_stemcell])
        @name_of_replicated_stemcell = "#{stemcell_id} %2f #{recommended_datastore.__mo_id__}"
      end

      it 'replicates the stemcell and disables sdrs for replicated stemcell' do
        allow(client).to receive(:find_vm_by_name).with(datacenter.mob, @name_of_replicated_stemcell).and_return(nil)
        allow(client).to receive_message_chain(:service_instance, :content, :storage_resource_manager).and_return(srm)
        allow(stemcell_vm).to receive(:clone).with(anything, @name_of_replicated_stemcell, an_instance_of(VimSdk::Vim::Vm::CloneSpec)).and_return(fake_task)

        allow(client).to receive(:wait_for_task) do |*args, &block|
          expect(block.call).to eq(fake_task)
          replicated_stemcell
        end
        allow(replicated_stemcell).to receive(:create_snapshot).with(any_args).and_return(fake_task)
        expect(srm).to receive(:configure_storage_drs_for_pod).with(target_datastore_cluster.mob, an_instance_of(VimSdk::Vim::StorageDrs::ConfigSpec), true)
        expect(subject.replicate(datacenter, cluster, nil, target_datastore_cluster)).to eql(replicated_stemcell)
      end

      it 'returns the found replica if stemcell resides on recommended datastore' do
        allow(client).to receive(:find_vm_by_name).with(datacenter.mob, @name_of_replicated_stemcell).and_return(stemcell_vm)
        expect(subject.replicate(datacenter, cluster, nil, target_datastore_cluster)).to eql(stemcell_vm)
      end
    end
  end
  describe '#get_recommendation_for_stemcell' do
    let(:vm_config) { double('VmConfig', name: 'vm-123456') }
    let(:config_spec) { instance_double(VimSdk::Vim::Vm::ConfigSpec) }
    let(:vm_folder_mob) { double('fake folder mob') }
    let(:resource_pool) { double(:resource_pool, mob: 'fake_resource_pool_mob') }
    let(:relocation_spec) { VimSdk::Vim::Vm::RelocateSpec.new }
    let(:datastore_cluster) {instance_double(VSphereCloud::Resources::StoragePod, mob: 'fake_storage_pod_mob')}
    let(:recommendation) { double('Recommendation', key: 'first_recommendation') }
    let(:srm) { instance_double(VimSdk::Vim::StorageResourceManager) }
    let(:storage_placement_result) { instance_double(VimSdk::Vim::StorageDrs::StoragePlacementResult, drs_fault: nil) }

    before do
      allow(VimSdk::Vim::Vm::RelocateSpec).to receive(:new).and_return(relocation_spec)
      allow(relocation_spec).to receive(:pool=).with(resource_pool.mob).and_return(resource_pool.mob)
      allow(relocation_spec).to receive(:disk_move_type=).with('createNewChildDiskBacking').and_return('createNewChildDiskBacking')
    end

    it 'raises an error when spec is incorrect' do
      error = VimSdk::SoapError.new("A specified parameter was not correct: cloneSpec", false)
      allow(client).to receive_message_chain(:service_instance, :content, :storage_resource_manager).and_return(srm)
      expect(srm).to receive(:recommend_datastores).with(an_instance_of(VimSdk::Vim::StorageDrs::StoragePlacementSpec)).and_raise(error)
      expect {
        vsphere_cloud.get_recommendation_for_stemcell(
            vm_mob,
            vm_config.name,
            vm_folder_mob,
            resource_pool.mob,
            linked: true,
            config: config_spec,
            datastore_cluster: datastore_cluster
        )
      }.to raise_error(/A specified parameter was not correct/)
    end
    it 'returns a recommendation' do
      expect(vm_mob).to receive(:clone).never
      allow(client).to receive_message_chain(:service_instance, :content, :storage_resource_manager).and_return(srm)
      expect(srm).to receive(:recommend_datastores).with(an_instance_of(VimSdk::Vim::StorageDrs::StoragePlacementSpec)).and_return(storage_placement_result)
      expect(storage_placement_result).to receive(:recommendations).and_return([recommendation])
      received_recommendation = vsphere_cloud.get_recommendation_for_stemcell(
          vm_mob,
          vm_config.name,
          vm_folder_mob,
          resource_pool.mob,
          linked: true,
          config: config_spec,
          datastore_cluster: datastore_cluster
      )
      expect(received_recommendation).to eq(recommendation)
    end
    it 'raises an exception when there are no recommendations' do
      expect(vm_mob).to receive(:clone).never
      allow(client).to receive_message_chain(:service_instance, :content, :storage_resource_manager).and_return(srm)
      expect(srm).to receive(:recommend_datastores).with(an_instance_of(VimSdk::Vim::StorageDrs::StoragePlacementSpec)).and_return(storage_placement_result)
      expect(storage_placement_result).to receive(:recommendations).and_return([])
      expect {
        vsphere_cloud.get_recommendation_for_stemcell(
            vm_mob,
            vm_config.name,
            vm_folder_mob,
            resource_pool.mob,
            linked: true,
            config: config_spec,
            datastore_cluster: datastore_cluster
        )
      }.to raise_error(/Storage DRS failed to make a recommendation for stemcell/)
    end
    it 'raises an exception when there is a DrsFault error' do
      drs_fault = VimSdk::Vim::Cluster::DrsFaults.new(reason: 'storageVmotion error')
      expect(vm_mob).to receive(:clone).never
      allow(client).to receive_message_chain(:service_instance, :content, :storage_resource_manager).and_return(srm)
      expect(srm).to receive(:recommend_datastores).with(an_instance_of(VimSdk::Vim::StorageDrs::StoragePlacementSpec)).and_return(storage_placement_result)
      allow(storage_placement_result).to receive(:drs_fault).and_return(drs_fault)
      expect {
        vsphere_cloud.get_recommendation_for_stemcell(
            vm_mob,
            vm_config.name,
            vm_folder_mob,
            resource_pool.mob,
            linked: true,
            config: config_spec,
            datastore_cluster: datastore_cluster
        )
      }.to raise_error(/Storage DRS failed to make a recommendation: storageVmotion error/)
    end
  end
end