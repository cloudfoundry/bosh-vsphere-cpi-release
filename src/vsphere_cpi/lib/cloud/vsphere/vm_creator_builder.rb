require 'cloud/vsphere/vm_creator'

module VSphereCloud
  class VmCreatorBuilder
    def build(cloud_properties, client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, cluster=nil, drs_rules=[])
      VmCreator.new(
        cloud_properties.fetch('ram'),
        cloud_properties.fetch('disk'),
        cloud_properties.fetch('cpu'),
        cloud_properties.fetch('cpu_hot_add_enabled', false),
        cloud_properties.fetch('mem_hot_add_enabled', false),
        cloud_properties.fetch('nested_hardware_virtualization', false),
        drs_rules,
        client,
        cloud_searcher,
        logger,
        cpi,
        agent_env,
        file_provider,
        datacenter,
        cluster
      )
    end
  end
end
