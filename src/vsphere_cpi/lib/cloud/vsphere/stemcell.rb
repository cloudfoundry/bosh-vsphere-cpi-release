require 'securerandom'

module VSphereCloud
  class Stemcell
    attr_reader :id

    def initialize(id, logger)
      @id, @logger = id, logger
    end

    def ==(other)
      instance_of?(other.class) && id == other.id
    end
    alias eql? ==

    def hash
      id.hash
    end

    def inspect
      "#<Stemcell id=#{id.inspect}>"
    end

    # Replicating a stemcell allows the creation of linked clones which can share files with a snapshot.
    # For details see https://www.vmware.com/support/ws55/doc/ws_clone_overview.html.
    #
    # @param [Resources::Datacenter] datacenter
    # @param [Resources::Cluster] cluster
    # @param [Resources::Datastore] to_datastore
    # @param [Resources::StoragePod] datastore_cluster
    def replicate(datacenter, cluster, to_datastore, datastore_cluster = nil)
      client = datacenter.client

      # Find a replica of this stemcell to act as the source of the replication.
      # This lets stemcell replication work even if the original VM is deleted by a user.
      vm = find_replica_in(datacenter.mob, client)
      raise "Could not find VM for stemcell '#{id}'" unless vm

      # if datastore cluster, then find the recommended datastore and then proceed as usual
      to_datastore_mob = if datastore_cluster
        srm = client.service_instance.content.storage_resource_manager
        get_recommended_datastore(srm, vm, datacenter.template_folder.mob, cluster.resource_pool.mob, datastore_cluster)
      else
        to_datastore.mob
      end

      datastore_name = to_datastore_mob.info.name

      # Check if original stemcell lives on same datastore.
      @logger.info("Searching for stemcell #{id} on datastore #{datastore_name}")
      replica_vm = find_replica_in(datacenter.mob,  client, datastore_name)
      return replica_vm if replica_vm

      replica_name = "#{id} %2f #{to_datastore_mob.__mo_id__}"

      @logger.info("No stemcell #{id} on datastore #{datastore_name}, replicating as #{replica_name}")

      begin
        clone_spec = VimSdk::Vim::Vm::CloneSpec.new
        clone_spec.location = VimSdk::Vim::Vm::RelocateSpec.new(
          datastore: to_datastore_mob,
          pool: cluster.resource_pool.mob
        )
        clone_spec.template = false

        replica_vm = client.wait_for_task do
          vm.clone(datacenter.template_folder.mob, replica_name, clone_spec)
        end
      rescue VSphereCloud::VCenterClient::DuplicateName
        @logger.info("Stemcell is already being replicated, waiting for #{replica_name} to be ready")
        path_array = [datacenter.name, 'vm', datacenter.template_folder.path_components, replica_name]
        replica_vm = client.find_by_inventory_path(path_array.flatten)
        # cloud_searcher#get_properties will ensure the existence of a snapshot
        # by retrying. This forces us to wait for a valid snapshot before
        # returning with the replicated stemcell vm. If a snapshot is not found
        # then an exception is thrown.
        client.cloud_searcher.get_properties(replica_vm, VimSdk::Vim::VirtualMachine, ['snapshot'], ensure_all: true)
        @logger.info("Stemcell #{replica_name} has been replicated.")
      else
        @logger.info("Replicated #{id} to #{replica_name}")
      end

      disable_sdrs(srm, datastore_cluster.mob, replica_vm) if datastore_cluster

      @logger.info("Creating initial snapshot for linked clones on #{replica_vm}")
      client.wait_for_task do
        replica_vm.create_snapshot('initial', nil, false, false)
      end
      @logger.info("Created initial snapshot for linked clones on #{replica_vm}")
      replica_vm
    end

    # Uses StorageResourceManager to get recommended datastore for replicating the stemcell
    #
    # @param [Vim::StorageResourceManager] srm
    # @param [Vim::VirtualMachine] vm
    # @param [Vim.Folder] folder
    # @param [Vim::ResourcePool] resource_pool
    # @param [Resources::StoragePod] datastore_cluster
    def get_recommended_datastore(srm, vm, folder, resource_pool, datastore_cluster)
      replica_name = SecureRandom.uuid
      relocation_spec = VimSdk::Vim::Vm::RelocateSpec.new(pool: resource_pool)
      clone_spec = VimSdk::Vim::Vm::CloneSpec.new(
        location: relocation_spec,
        template: false
      )

      initial_vm_config = VimSdk::Vim::StorageDrs::PodSelectionSpec::VmPodConfig.new
      initial_vm_config.storage_pod = datastore_cluster.mob
      initial_vm_config.vm_config = VimSdk::Vim::StorageDrs::VmConfigInfo.new(enabled: false) # disable DRS for stemcell

      pod_selection_spec = VimSdk::Vim::StorageDrs::PodSelectionSpec.new(storage_pod: datastore_cluster.mob)
      pod_selection_spec.initial_vm_config = initial_vm_config

      storage_placement_spec = VimSdk::Vim::StorageDrs::StoragePlacementSpec.new
      storage_placement_spec.vm = vm
      storage_placement_spec.clone_name = replica_name
      storage_placement_spec.type = VimSdk::Vim::StorageDrs::StoragePlacementSpec::PlacementType::CLONE
      storage_placement_spec.folder = folder
      storage_placement_spec.clone_spec = clone_spec
      storage_placement_spec.pod_selection_spec = pod_selection_spec

      storage_placement_result = srm.recommend_datastores(storage_placement_spec)
      if storage_placement_result.drs_fault
        @logger.info("Error raised when fetching recommendation for replicating #{id} from Storage DRS: #{storage_placement_result.drs_fault.reason}")
        raise "Storage DRS failed to make a recommendation for #{id}, Reason: #{storage_placement_result.drs_fault.reason}"
      end

      # pick first recommendation as that's the best one
      recommendation = storage_placement_result.recommendations.first
      raise "Storage DRS failed to make a recommendation for stemcell #{id} replication" unless recommendation
      @logger.info("Recommendation from Storage DRS for: #{replica_name}, Destination: #{recommendation.action.first.destination.name}")

      #TODO: loop over all actions to pick one with reason as storagePlacement
      if recommendation.reason == 'storagePlacement' && recommendation.action.first.destination.class == VimSdk::Vim::Datastore
        recommended_datastore = recommendation.action.first.destination
        #cancel storage drs recommendation as we are not going to apply it
        srm.cancel_recommendation(recommendation.key)
        recommended_datastore
      else
        @logger.info("No recommendation from Storage DRS for replicating #{id}")
        raise "No recommendation from Storage DRS for replicating #{id}"
      end
    end

    private

    def find_replica_in(object, client, datastore_name=nil)
      if datastore_name
        client.find_all_stemcell_replicas_in_datastore(object, id, datastore_name).first
      else
        client.find_all_stemcell_replicas(object, id).first
      end
    end

    def disable_sdrs(srm, datastore_cluster_mob, vm)
      @logger.info("Disabling Storage DRS on replicated stemcell")
      vm_info = VimSdk::Vim::StorageDrs::VmConfigInfo.new(vm: vm, enabled: false)
      vm_config_spec = VimSdk::Vim::StorageDrs::VmConfigSpec.new(info: vm_info, operation: VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT)
      storage_drs_config_spec = VimSdk::Vim::StorageDrs::ConfigSpec.new(vm_config_spec: [vm_config_spec])
      srm.configure_storage_drs_for_pod(datastore_cluster_mob, storage_drs_config_spec, true)
    end
  end
end
