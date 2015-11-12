class LifecycleHelpers
  MISSING_KEY_MESSAGES = {
    'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN' => 'Please ensure you provide a pattern that match datastores that are only accessible by a single host.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER' => 'Please ensure you provide a datacenter that is in a sub-folder of the root folder.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN' => 'Please ensure you provide a datastore accessible datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER' => 'Please ensure you provide a cluster within the datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL' => 'Please ensure you provide a resource pool within the cluster referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN' => 'Please ensure you provide the name of the distributed switch within the datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_HOST' => 'Please ensure you provide a vSphere hostname to connect to.',
    'BOSH_VSPHERE_CPI_USER' => 'Please ensure you provide a vSphere username to authenticate with.',
    'BOSH_VSPHERE_CPI_PASSWORD' => 'Please ensure you provide a vSphere password to authenticate with.',
    'BOSH_VSPHERE_VLAN' => 'Please ensure you provide a VLAN network name.',
    'BOSH_VSPHERE_STEMCELL' => 'Please ensure you provide a path to a stemcell file.',
    'BOSH_VSPHERE_CPI_CLUSTER' => 'Please ensure you provide the name of the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER' => 'Please ensure you provide the name of the second cluster.',
    'BOSH_VSPHERE_CPI_DATASTORE_PATTERN' => 'Please ensure you provide a pattern of a first datastore attached to the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_DATASTORE' => 'Please ensure you provide a pattern of a second datastore attached to the first cluster.',
    'BOSH_VSPHERE_CPI_RESOURCE_POOL' => 'Please ensure you provide a name of a resource pool within the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL' => 'Please ensure you provide a name of the second resource pool within the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL' => 'Please ensure you provide a name of a resource pool within the second cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE' => 'Please ensure you provide a pattern of a second datastore attached to the second cluster.',
    'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN' => 'Please ensure you provide a pattern of a persistent datastore attached to all hosts in all provided clusters.',
    'BOSH_VSPHERE_CPI_DISK_PATH' => 'Please ensure you provide a disk path.',
    'BOSH_VSPHERE_CPI_TEMPLATE_FOLDER' => 'Please ensure you provide a template folder.',
    'BOSH_VSPHERE_CPI_VM_FOLDER' => 'Please ensure you provide a VM folder.',
    'BOSH_VSPHERE_CPI_DATACENTER' => 'Please ensure you provide a datacenter name.',
  }

  ALLOWED_PRIVILEGES_ON_ROOT = [
    'System.Anonymous',
    'System.Read',
    'System.View'
  ]

  ALLOWED_PRIVILEGES_ON_DATACENTER = [
    'System.Anonymous',
    'System.Read',
    'System.View',

    'Folder.Create',
    'Folder.Delete',
    'Folder.Rename',
    'Folder.Move',

    'Datastore.AllocateSpace',
    'Datastore.Browse',
    'Datastore.DeleteFile',
    'Datastore.UpdateVirtualMachineFiles',
    'Datastore.FileManagement',

    'Network.Assign',

    'VirtualMachine.Inventory.Create',
    'VirtualMachine.Inventory.CreateFromExisting',
    'VirtualMachine.Inventory.Register',
    'VirtualMachine.Inventory.Delete',
    'VirtualMachine.Inventory.Unregister',
    'VirtualMachine.Inventory.Move',
    'VirtualMachine.Interact.PowerOn',
    'VirtualMachine.Interact.PowerOff',
    'VirtualMachine.Interact.Suspend',
    'VirtualMachine.Interact.Reset',
    'VirtualMachine.Interact.AnswerQuestion',
    'VirtualMachine.Interact.ConsoleInteract',
    'VirtualMachine.Interact.DeviceConnection',
    'VirtualMachine.Interact.SetCDMedia',
    'VirtualMachine.Interact.ToolsInstall',
    'VirtualMachine.Interact.GuestControl',
    'VirtualMachine.Interact.DefragmentAllDisks',
    'VirtualMachine.GuestOperations.Query',
    'VirtualMachine.GuestOperations.Modify',
    'VirtualMachine.GuestOperations.Execute',
    'VirtualMachine.Config.Rename',
    'VirtualMachine.Config.Annotation',
    'VirtualMachine.Config.AddExistingDisk',
    'VirtualMachine.Config.AddNewDisk',
    'VirtualMachine.Config.RemoveDisk',
    'VirtualMachine.Config.RawDevice',
    'VirtualMachine.Config.CPUCount',
    'VirtualMachine.Config.Memory',
    'VirtualMachine.Config.AddRemoveDevice',
    'VirtualMachine.Config.EditDevice',
    'VirtualMachine.Config.Settings',
    'VirtualMachine.Config.Resource',
    'VirtualMachine.Config.ResetGuestInfo',
    'VirtualMachine.Config.AdvancedConfig',
    'VirtualMachine.Config.DiskLease',
    'VirtualMachine.Config.SwapPlacement',
    'VirtualMachine.Config.DiskExtend',
    'VirtualMachine.Config.ChangeTracking',
    'VirtualMachine.Config.Unlock',
    'VirtualMachine.Config.ReloadFromPath',
    'VirtualMachine.Config.MksControl',
    'VirtualMachine.Config.ManagedBy',
    'VirtualMachine.State.CreateSnapshot',
    'VirtualMachine.State.RevertToSnapshot',
    'VirtualMachine.State.RemoveSnapshot',
    'VirtualMachine.State.RenameSnapshot',
    'VirtualMachine.Provisioning.Customize',
    'VirtualMachine.Provisioning.Clone',
    'VirtualMachine.Provisioning.PromoteDisks',
    'VirtualMachine.Provisioning.DeployTemplate',
    'VirtualMachine.Provisioning.CloneTemplate',
    'VirtualMachine.Provisioning.MarkAsTemplate',
    'VirtualMachine.Provisioning.MarkAsVM',
    'VirtualMachine.Provisioning.ReadCustSpecs',
    'VirtualMachine.Provisioning.ModifyCustSpecs',
    'VirtualMachine.Provisioning.DiskRandomAccess',
    'VirtualMachine.Provisioning.DiskRandomRead',
    'VirtualMachine.Provisioning.GetVmFiles',
    'VirtualMachine.Provisioning.PutVmFiles',

    'Resource.AssignVMToPool',
    'Resource.ColdMigrate',
    'Resource.HotMigrate',

    'VApp.Import'
  ]

  class << self
    def fetch_property(key)
      fail "Missing Environment varibale #{key}: #{MISSING_KEY_MESSAGES[key]}" unless(ENV.has_key?(key))
      value = ENV[key]
      fail "Environment variable #{key} must not be blank: #{MISSING_KEY_MESSAGES[key]}" if(value =~ /^\s*$/)
      value
    end

    def fetch_optional_property(property)
      ENV[property]
    end

    def verify_vsphere_version(cpi_options, expected_version)
      return if expected_version.nil?
      cpi = VSphereCloud::Cloud.new(cpi_options)
      actual_version = cpi.client.service_content.about.version
      fail("vSphere version #{expected_version} required. Found #{actual_version}.") if expected_version != actual_version
    end

    def verify_datastore_within_cluster(datacenter, env_var_name, datastore_pattern, cluster_name)
      cluster = datacenter.find_cluster(cluster_name)
      datastores = matching_datastores_in_cluster(cluster, datastore_pattern)
      fail("Invalid Environment variable '#{env_var_name}': No datastores found matching /#{datastore_pattern}/. #{MISSING_KEY_MESSAGES[env_var_name]}") if (datastores.empty?)
    end

    def verify_cluster(datacenter, cluster_name, env_var_name)
      datacenter.find_cluster(cluster_name)
    rescue RuntimeError => e
      fail("#{e.message}\n#{env_var_name}: #{MISSING_KEY_MESSAGES[env_var_name]}")
    end

    def verify_local_disk_infrastructure(cpi_options, env_var_name)
      datastore_pattern = cpi_options['vcenters'].first['datacenters'].first['datastore_pattern']

      cpi = VSphereCloud::Cloud.new(cpi_options)
      all_ephemeral_datastores = matching_datastores(cpi, datastore_pattern)
      nonlocal_disk_ephemeral_datastores = all_ephemeral_datastores.select { |_, datastore| datastore.mob.summary.multiple_host_access }
      unless (nonlocal_disk_ephemeral_datastores.empty?)
        fail(
          <<-EOF
Some datastores found maching `#{env_var_name}`(/#{datastore_pattern}/)
are configured to allow multiple hosts to access them:
#{nonlocal_disk_ephemeral_datastores}.
#{MISSING_KEY_MESSAGES[env_var_name]}
        EOF
        )
      end
    end

    def verify_user_has_limited_permissions(cpi_options)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      root_folder_privileges = build_actual_privileges_list(cpi, cpi.client.service_content.root_folder)

      if root_folder_privileges.sort != ALLOWED_PRIVILEGES_ON_ROOT.sort
        disallowed_privileges = root_folder_privileges - ALLOWED_PRIVILEGES_ON_ROOT
        fail "User must have limited permissions on root folder. Disallowed permissions include: #{disallowed_privileges.inspect}"
      end

      cluster_mob = cpi.datacenter.clusters.first.last.mob
      datacenter_privileges = build_actual_privileges_list(cpi, cluster_mob)

      if datacenter_privileges.sort != ALLOWED_PRIVILEGES_ON_DATACENTER.sort
        disallowed_privileges = datacenter_privileges - ALLOWED_PRIVILEGES_ON_DATACENTER
        if disallowed_privileges.empty?
          missing_permissions = ALLOWED_PRIVILEGES_ON_DATACENTER - datacenter_privileges
          fail "User is missing permissions on datacenter `#{cpi.datacenter.name}`. Missing permssions: #{missing_permissions}"
        else
          fail "User must have limited permissions on datacenter `#{cpi.datacenter.name}`. Disallowed permissions include: #{disallowed_privileges.inspect}"
        end
      end
    end

    def verify_datacenter_is_nested(cpi_options, datacenter_name, env_var_name)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      datacenter_mob = cpi.datacenter.mob
      client = cpi.client
      datacenter_parent = client.cloud_searcher.get_property(datacenter_mob, datacenter_mob.class, 'parent', :ensure_all => true)
      root_folder = client.service_content.root_folder

      fail "Invalid Environment variable '#{env_var_name}': Datacenter '#{datacenter_name}'  is not in subfolder" if root_folder.to_str == datacenter_parent.to_str
    end

    def verify_resource_pool(cluster, resource_pool_name, env_var_name)
      cluster.resource_pool.mob
    rescue
      fail "Invalid Environment variable '#{env_var_name}': No resource pool named '#{resource_pool_name}' found in cluster named '#{cluster.name}'"
    end

    def stemcell_image(stemcell_path, destination_dir)
      raise "Invalid Environment variable 'BOSH_VSPHERE_STEMCELL': File not found: '#{stemcell_path}'" unless File.exists?(stemcell_path)
      output = `tar -C #{destination_dir} -xzf #{stemcell_path} 2>&1`
      fail "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
      "#{destination_dir}/image"
    end

    def verify_vlan(cpi_options, vlan, env_var_name)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      datacenter_name = cpi.datacenter.name
      network = cpi.client.find_by_inventory_path([datacenter_name, 'network', vlan])
      fail "Invalid Environment variable '#{env_var_name}': No network named '#{vlan}' found in datacenter named '#{datacenter_name}'" if network.nil?
    end

    def verify_datacenter_exists(cpi_options, env_var_name)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      cpi.datacenter.mob
    rescue => e
      fail "Invalid Environment variable '#{env_var_name}': #{e.message}"
    end

    def verify_non_overlapping_datastores(cpi_1, pattern_1, env_var_name_1, cpi_2, pattern_2, env_var_name_2)
      datastore_ids_1 = matching_datastores(cpi_1, pattern_1).map { |k, v| [k, v.mob.to_s] }
      datastore_ids_2 = matching_datastores(cpi_2, pattern_2).map { |k, v| [k, v.mob.to_s] }
      overlapping_datastore_ids = datastore_ids_1 & datastore_ids_2
      if (!overlapping_datastore_ids.empty?)
        fail("There were overlapping datastores (#{overlapping_datastore_ids.map(&:first).inspect}) found matching /#{pattern_1}/ and /#{pattern_2}/ which came from Environment varibales '#{env_var_name_1}' and '#{env_var_name_2}' respectively.")
      end
    end

    def verify_datastore_pattern_available_to_all_hosts(cpi_options, env_var_name, datastore_pattern)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      datastore_pattern_regex =  Regexp.new(datastore_pattern)
      cpi.datacenter.clusters.values.each do |cluster|
        cluster.mob.host.each do |host_mob|
          datastore_names = host_mob.datastore.map(&:name)
          fail("host: '#{host_mob.name}' does not have any datastores matching pattern /#{datastore_pattern}/. Found datastores are #{datastore_names.inspect}. The datasore pattern came from the environment varible:'#{env_var_name}'. #{MISSING_KEY_MESSAGES[env_var_name]}") unless datastore_names.any?{ |name| name =~ datastore_pattern_regex }
        end
      end
    end

    def any_vsan?(cpi, pattern)
      datastores = matching_datastores(cpi, pattern)
      datastores.any? { |datastore_name, _| is_vsan?(cpi, datastore_name)}
    end

    def is_vsan?(cpi, datastore_name)
      datastore_mob = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
      datastore_mob.summary.type == "vsan"
    end

    private

    def matching_datastores(cpi, pattern)
      clusters = cpi.datacenter.clusters
      clusters.inject({}) do |acc, kv|
        cluster = kv.last
        acc.merge!(matching_datastores_in_cluster(cluster, pattern))
      end
    end

    def matching_datastores_in_cluster(cluster, pattern)
      cluster.all_datastores.select { |ds_name| ds_name =~ /#{pattern}/ }
    end

    def build_actual_privileges_list(cpi, entity)
      all_privileges = cpi.client.service_content.authorization_manager.privilege_list.map(&:priv_id)
      current_session_id = cpi.client.service_content.session_manager.current_session.key
      privileges_response =
        cpi.client.service_content.authorization_manager.has_privilege_on_entity(entity, current_session_id, all_privileges)
      Hash[all_privileges.zip(privileges_response)].select { |_, privelege| privelege }.keys
    end
  end
end
