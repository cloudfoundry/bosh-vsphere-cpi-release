module VSphereCloud
  class VMSDRSConfigurator
    include Logger

    def initialize(client, datastores, vm_mob)
      @client =  client
      @datastores = datastores
      @vm = vm_mob
    end

    def with_sdrs_disabled
      @datastores.each do |ds_mob|
        disable_sdrs_for_ds(ds_mob)
      end
      begin
        yield
      ensure
        @datastores.each do |ds_mob|
          enable_sdrs_for_ds(ds_mob)
        end
      end
    end

    def disable_sdrs_for_ds(ds_mob)
      parent_datstastore = ds_mob.parent
      unless parent_datstastore.is_a?(VimSdk::Vim::StoragePod)
        logger.info("Datastore #{@datastore.name} is not part of any storage pod. No need to disable SDRS")
        return
      end
      disable_sdrs_for_pod(parent_datstastore)
    end

    def enable_sdrs_for_ds(ds_mob)
      parent_datstastore = ds_mob.parent
      unless parent_datstastore.is_a?(VimSdk::Vim::StoragePod)
        logger.info("Datastore #{ds_mob.name} is not part of any storage pod. No need to enable SDRS")
        return
      end
      enable_sdrs_for_pod(parent_datstastore)
    end

    private

    def enable_sdrs_for_pod(storage_pod_mob)
      logger.info("Enabling Storage DRS on #{@vm.name} for storage pod #{storage_pod_mob.name}")
      vm_info = VimSdk::Vim::StorageDrs::VmConfigInfo.new(vm: @vm, enabled: true)
      vm_config_spec = VimSdk::Vim::StorageDrs::VmConfigSpec.new(info: vm_info, operation: VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT)
      storage_drs_config_spec = VimSdk::Vim::StorageDrs::ConfigSpec.new(vm_config_spec: [vm_config_spec])
      srm = client.service_instance.content.storage_resource_manager
      @client.wait_for_task do
        srm.configure_storage_drs_for_pod(storage_pod_mob, storage_drs_config_spec, true)
      end
      logger.info("Enabled Storage DRS on #{@vm.name} for storage pod #{storage_pod_mob.name}")
    end

    def disable_sdrs_for_pod(storage_pod_mob)
      logger.info("Disabling Storage DRS on #{@vm.name} for storage pod #{storage_pod_mob.name}")
      vm_info = VimSdk::Vim::StorageDrs::VmConfigInfo.new(vm: @vm, enabled: false)
      vm_config_spec = VimSdk::Vim::StorageDrs::VmConfigSpec.new(info: vm_info, operation: VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT)
      storage_drs_config_spec = VimSdk::Vim::StorageDrs::ConfigSpec.new(vm_config_spec: [vm_config_spec])
      srm = @client.service_instance.content.storage_resource_manager
      @client.wait_for_task do
        srm.configure_storage_drs_for_pod(storage_pod_mob, storage_drs_config_spec, true)
      end
      logger.info("Disabled Storage DRS on #{@vm.name} for storage pod #{storage_pod_mob.name}")
    end
  end
end