require 'json'
require 'membrane'
require 'cloud'

module VSphereCloud
  class Cloud < Bosh::Cloud
    include VimSdk
    include RetryBlock

    class TimeoutException < StandardError; end
    class NetworkException < StandardError
      attr_accessor :vm_cid

      def message
        super + (vm_cid ? " for VM '#{vm_cid}'" : '')
      end
    end

    attr_accessor :client
    attr_reader :config, :datacenter

    def initialize(options)
      @config = Config.build(options)

      @logger = config.logger
      @client = config.client
      @cloud_searcher = CloudSearcher.new(@client.service_content, @logger)
      @datacenter = Resources::Datacenter.new({
        client: @client,
        use_sub_folder: @config.datacenter_use_sub_folder,
        vm_folder: @config.datacenter_vm_folder,
        template_folder: @config.datacenter_template_folder,
        name: @config.datacenter_name,
        disk_path: @config.datacenter_disk_path,
        ephemeral_pattern: @config.datacenter_datastore_pattern,
        persistent_pattern: @config.datacenter_persistent_datastore_pattern,
        clusters: @config.datacenter_clusters,
        logger: @config.logger,
        mem_overcommit: @config.mem_overcommit
      })

      @file_provider = FileProvider.new(config.rest_client, config.vcenter_host)
      @agent_env = AgentEnv.new(client, @file_provider, @cloud_searcher)

      # We get disconnected if the connection is inactive for a long period.
      Thread.new do
        while true do
          sleep(60)
          @client.service_instance.current_time
        end
      end

      setup_at_exit
    end

    def setup_at_exit
      # HACK: finalizer not getting called, so we'll rely on at_exit
      at_exit { @client.logout }
    end

    def has_vm?(vm_cid)
      vm_provider.find(vm_cid)
      true
    rescue Bosh::Clouds::VMNotFound
      false
    end

    def has_disk?(disk_cid)
      @datacenter.find_disk(disk_cid)
      true
    rescue Bosh::Clouds::DiskNotFound
      false
    end

    def create_stemcell(image, _)
      with_thread_name("create_stemcell(#{image}, _)") do
        result = nil
        Dir.mktmpdir do |temp_dir|
          @logger.info("Extracting stemcell to: #{temp_dir}")
          output = `tar -C #{temp_dir} -xzf #{image} 2>&1`
          raise "Corrupt image '#{image}', tar exit status: #{$?.exitstatus}, output: #{output}" if $?.exitstatus != 0

          ovf_file = Dir.entries(temp_dir).find { |entry| File.extname(entry) == '.ovf' }
          raise "Missing OVF for stemcell '#{stemcell}'" if ovf_file.nil?
          ovf_file = File.join(temp_dir, ovf_file)

          name = "sc-#{SecureRandom.uuid}"
          @logger.info("Generated name: #{name}")

          stemcell_size = File.size(image) / (1024 * 1024)

          clusters = @datacenter.clusters_hash
          cluster_picker = ClusterPicker.new(@datacenter.ephemeral_pattern, @datacenter.persistent_pattern)
          cluster_picker.update(clusters)
          cluster_name = cluster_picker.pick_cluster(0, stemcell_size, {})
          cluster = @datacenter.find_cluster(cluster_name)

          datastore_picker = DatastorePicker.new
          datastore_picker.update(clusters[cluster_name][:datastores])
          datastore_name = datastore_picker.pick_datastore(stemcell_size, @datacenter.ephemeral_pattern)
          datastore = @datacenter.find_datastore(datastore_name)

          @logger.info("Deploying to: #{cluster.mob} / #{datastore.mob}")

          import_spec_result = import_ovf(name, ovf_file, cluster.resource_pool.mob, datastore.mob)

          lease_obtainer = LeaseObtainer.new(@cloud_searcher, @logger)
          nfc_lease = lease_obtainer.obtain(
            cluster.resource_pool,
            import_spec_result.import_spec,
            cluster.datacenter.template_folder,
          )

          @logger.info('Uploading')
          vm = upload_ovf(ovf_file, nfc_lease, import_spec_result.file_item)
          result = name

          @logger.info('Removing NICs')
          devices = @cloud_searcher.get_property(vm, Vim::VirtualMachine, 'config.hardware.device', ensure_all: true)
          config = Vim::Vm::ConfigSpec.new
          config.device_change = []

          nics = devices.select { |device| device.kind_of?(Vim::Vm::Device::VirtualEthernetCard) }
          nics.each do |nic|
            nic_config = Resources::VM.create_delete_device_spec(nic)
            config.device_change << nic_config
          end
          client.reconfig_vm(vm, config)

          @logger.info('Taking initial snapshot')

          # Despite the naming, this has nothing to do with the Cloud notion of a disk snapshot
          # (which comes from AWS). This is a vm snapshot.
          task = vm.create_snapshot('initial', nil, false, false)
          client.wait_for_task(task)
        end
        result
      end
    end

    def delete_stemcell(stemcell)
      with_thread_name("delete_stemcell(#{stemcell})") do
        Bosh::ThreadPool.new(max_threads: 32, logger: @logger).wrap do |pool|
          @logger.info("Looking for stemcell replicas in: #{@datacenter.name}")
          matches = client.find_all_stemcell_replicas(@datacenter.mob, stemcell)

          matches.each do |sc|
            sc_name = sc.name
            @logger.info("Found: #{sc_name}")
            pool.process do
              @logger.info("Deleting: #{sc_name}")
              client.delete_vm(sc)
              @logger.info("Deleted: #{sc_name}")
            end
          end

        end
      end
    end

    def stemcell_vm(name)
      client.find_vm_by_name(@datacenter.mob, name)
    end

    def create_vm(agent_id, stemcell_cid, resource_pool, networks_spec, disk_locality = [], environment = nil)
      with_thread_name("create_vm(#{agent_id}, ...)") do
        stemcell_vm = stemcell_vm(stemcell_cid)
        raise "Could not find VM for stemcell '#{stemcell_cid}'" if stemcell_vm.nil?
        stemcell_size = @cloud_searcher.get_property(
          stemcell_vm,
          VimSdk::Vim::VirtualMachine,
          'summary.storage.committed',
          ensure_all: true
        )
        stemcell_size /= 1024 * 1024

        manifest_params = {
          resource_pool: resource_pool,
          networks_spec: networks_spec,
          agent_id: agent_id,
          agent_env: environment,
          stemcell: {
            cid: stemcell_cid,
            size: stemcell_size
          },
          available_clusters: @datacenter.clusters_hash,
          existing_disks: @datacenter.disks_hash(disk_locality || []),
          ephemeral_datastore_pattern: @datacenter.ephemeral_pattern,
        }

        vm_config = VmConfig.new(
          manifest_params: manifest_params,
          datastore_picker: DatastorePicker.new,
          cluster_picker: ClusterPicker.new(@datacenter.ephemeral_pattern, @datacenter.persistent_pattern)
        )

        vm_config.validate

        vm_creator = VmCreator.new(
          client: @client,
          cloud_searcher: @cloud_searcher,
          logger: @logger,
          cpi: self,
          datacenter: @datacenter,
          agent_env: @agent_env,
          ip_conflict_detector: IPConflictDetector.new(@logger, @client),
        )
        vm_creator.create(vm_config)
      end
    end

    def delete_vm(vm_cid)
      with_thread_name("delete_vm(#{vm_cid})") do
        @logger.info("Deleting vm: #{vm_cid}")

        vm = vm_provider.find(vm_cid)
        vm.power_off

        persistent_disks = vm.persistent_disks
        unless persistent_disks.empty?
          vm.detach_disks(persistent_disks)
        end

        # Delete env.iso and VM specific files managed by the director
        retry_block { @agent_env.clean_env(vm.mob) } if vm.cdrom

        vm.delete
        @logger.info("Deleted vm: #{vm_cid}")
      end
    end

    def reboot_vm(vm_cid)
      with_thread_name("reboot_vm(#{vm_cid})") do
        vm = vm_provider.find(vm_cid)

        @logger.info("Reboot vm = #{vm_cid}")

        unless vm.powered_on?
          @logger.info("VM not in POWERED_ON state. Current state : #{vm.power_state}")
        end

        begin
          vm.reboot
        rescue => e
          @logger.error("Soft reboot failed #{e} -#{e.backtrace.join("\n")}")
          @logger.info('Try hard reboot')

          # if we fail to perform a soft-reboot we force a hard-reboot
          retry_block { vm.power_off } if vm.powered_on?

          retry_block { vm.power_on }
        end
      end
    end

    def set_vm_metadata(vm_cid, metadata)
      with_thread_name("set_vm_metadata(#{vm_cid}, ...)") do
        vm = vm_provider.find(vm_cid)
        metadata.each do |name, value|
          client.set_custom_field(vm.mob, name, value)
        end
      end
    end

    def configure_networks(vm_cid, networks)
      raise Bosh::Clouds::NotSupported, "configure_networks is no longer supported"
    end

    def attach_disk(vm_cid, disk_cid)
      with_thread_name("attach_disk(#{vm_cid}, #{disk_cid})") do
        @logger.info("Attaching disk: #{disk_cid} on vm: #{vm_cid}")
        vm = vm_provider.find(vm_cid)
        disk = @datacenter.find_disk(disk_cid)

        accessible_datastores = {}
        all_datastores = @datacenter.datastores_hash
        vm.accessible_datastore_names.each do |name|
          accessible_datastores[name] = all_datastores[name]
        end

        disk_is_accessible = accessible_datastores.include?(disk.datastore.name)
        disk_is_in_persistent_datastore = @datacenter.persistent_datastores.include?(disk.datastore.name)
        unless disk_is_accessible && disk_is_in_persistent_datastore
          datastore_picker = DatastorePicker.new
          datastore_picker.update(accessible_datastores)
          datastore_name = datastore_picker.pick_datastore(disk.size_in_mb, @datacenter.persistent_pattern)
          destination_datastore = @datacenter.find_datastore(datastore_name)

          disk = @datacenter.move_disk_to_datastore(disk, destination_datastore)
        end

        disk_config_spec = vm.attach_disk(disk)
        add_disk_to_agent_env(vm, disk, disk_config_spec.device.unit_number)
      end
    end

    def detach_disk(vm_cid, disk_cid)
      with_thread_name("detach_disk(#{vm_cid}, #{disk_cid})") do
        @logger.info("Detaching disk: #{disk_cid} from vm: #{vm_cid}")

        vm = vm_provider.find(vm_cid)
        disk = vm.disk_by_cid(disk_cid)
        raise Bosh::Clouds::DiskNotAttached.new(true), "Disk '#{disk_cid}' is not attached to VM '#{vm_cid}'" if disk.nil?

        vm.detach_disks([disk])
        delete_disk_from_agent_env(vm, disk_cid)
      end
    end

    def create_disk(size_in_mb, cloud_properties, vm_cid = nil)
      with_thread_name("create_disk(#{size_in_mb}, _)") do
        @logger.info("Creating disk with size: #{size_in_mb}")

        all_datastores = @datacenter.datastores_hash
        if vm_cid
          accessible_datastores = {}
          vm = vm_provider.find(vm_cid)
          vm.accessible_datastore_names.each do |name|
            accessible_datastores[name] = all_datastores[name]
          end
        else
          accessible_datastores = all_datastores
        end

        datastore_picker = DatastorePicker.new
        datastore_picker.update(accessible_datastores)
        datastore_name = datastore_picker.pick_datastore(size_in_mb, @datacenter.persistent_pattern)
        datastore = @datacenter.find_datastore(datastore_name)

        disk_type = cloud_properties.fetch('type', Resources::PersistentDisk::DEFAULT_DISK_TYPE)
        disk = @datacenter.create_disk(datastore, size_in_mb, disk_type)
        @logger.info("Created disk: #{disk.inspect}")

        disk.cid
      end
    end

    def delete_disk(disk_cid)
      with_thread_name("delete_disk(#{disk_cid})") do
        @logger.info("Deleting disk: #{disk_cid}")
        disk = @datacenter.find_disk(disk_cid)
        client.delete_disk(@datacenter.mob, disk.path)

        @logger.info('Finished deleting disk')
      end
    end

    # Replicating a stemcell allows the creation of linked clones which can share files with a snapshot.
    # For details see https://www.vmware.com/support/ws5/doc/ws_clone_overview.html.
    def replicate_stemcell(cluster, to_datastore, stemcell_id)
      original_stemcell_vm = self.client.find_vm_by_name(@datacenter.mob, stemcell_id)
      raise "Could not find VM for stemcell '#{stemcell_id}'" if original_stemcell_vm.nil?

      return original_stemcell_vm if vm_datastore_name(original_stemcell_vm) == to_datastore.name

      @logger.info("Stemcell lives on a different datastore, looking for a local copy of: #{stemcell_id}.")

      name_of_replicated_stemcell = "#{stemcell_id} %2f #{to_datastore.mob.__mo_id__}"

      replicated_stemcell_vm = client.find_vm_by_name(@datacenter.mob, name_of_replicated_stemcell)
      return replicated_stemcell_vm if replicated_stemcell_vm

      @logger.info("Cluster doesn't have stemcell #{stemcell_id}, replicating")
      @logger.info("Replicating #{stemcell_id} (#{original_stemcell_vm}) to #{name_of_replicated_stemcell}")
      begin
        replicated_stemcell_vm = client.wait_for_task(clone_vm(
          original_stemcell_vm,
          name_of_replicated_stemcell,
          cluster.datacenter.template_folder.mob,
          cluster.resource_pool.mob,
          datastore: to_datastore.mob
        ))
        @logger.info("Replicated #{stemcell_id} (#{original_stemcell_vm}) to #{name_of_replicated_stemcell} (#{replicated_stemcell_vm})")

        @logger.info("Creating initial snapshot for linked clones on #{replicated_stemcell_vm}")
        client.wait_for_task(replicated_stemcell_vm.create_snapshot('initial', nil, false, false))
        @logger.info("Created initial snapshot for linked clones on #{replicated_stemcell_vm}")
      rescue VSphereCloud::VCenterClient::DuplicateName
        @logger.info("Stemcell is being replicated by another thread, waiting for #{name_of_replicated_stemcell} to be ready")
        replicated_stemcell_vm = client.find_by_inventory_path([
          cluster.datacenter.name,
          'vm',
          cluster.datacenter.template_folder.path_components,
          name_of_replicated_stemcell
        ])
        # get_properties will ensure the existence of the snapshot by retrying.
        # This forces us to wait for a valid snapshot before returning with the
        # replicated stemcell vm, if a snapshot is not found then an exception is thrown.
        client.cloud_searcher.get_properties(replicated_stemcell_vm,
          VimSdk::Vim::VirtualMachine,
          ['snapshot'], ensure_all: true)
        @logger.info("Stemcell #{name_of_replicated_stemcell} has been replicated.")
      end

      replicated_stemcell_vm
    end


    def vm_datastore_name(vm)
      vm_datacenters = @cloud_searcher.get_property(
        vm,
        Vim::VirtualMachine,
        'datastore',
        ensure_all: true
      )

      if vm_datacenters.size > 1
        raise "stemcell VM #{vm.inspect} found in multiple datacenters #{datacenters.inspect}"
      end

      if vm_datacenters.size == 0
        raise "no datacenter found for stemcell VM #{vm.inspect}"
      end

      vm_datacenters.first.name
    end


    def generate_network_env(devices, networks, dvs_index)
      nics = {}

      devices.each do |device|
        if device.kind_of?(Vim::Vm::Device::VirtualEthernetCard)
          backing = device.backing
          if backing.kind_of?(Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo)
            v_network_name = dvs_index[backing.port.portgroup_key]
          else
            v_network_name = PathFinder.new.path(backing.network)
          end
          allocated_networks = nics[v_network_name] || []
          allocated_networks << device
          nics[v_network_name] = allocated_networks
        end
      end

      network_env = {}
      networks.each do |network_name, network|
        network_entry = network.dup
        v_network_name = network['cloud_properties']['name']
        network = nics[v_network_name]
        raise NetworkException, "Could not find network '#{v_network_name}'" if network.nil?
        nic = network.pop
        network_entry['mac'] = nic.mac_address
        network_env[network_name] = network_entry
      end
      network_env
    end

    def generate_disk_env(system_disk, ephemeral_disk)
      {
        'system' => system_disk.unit_number.to_s,
        'ephemeral' => ephemeral_disk.unit_number.to_s,
        'persistent' => {}
      }
    end

    def generate_agent_env(name, vm, agent_id, networking_env, disk_env)
      vm_env = {
        'name' => name,
        'id' => vm.__mo_id__
      }

      env = {}
      env['vm'] = vm_env
      env['agent_id'] = agent_id
      env['networks'] = networking_env
      env['disks'] = disk_env
      env.merge!(config.agent)
      env
    end

    def get_vm_location(vm, options = {})
      datacenter_name = options[:datacenter]
      datastore_name = options[:datastore]
      vm_name = options[:vm]

      unless datacenter_name
        datacenter_name = config.datacenter_name
      end

      if vm_name.nil? || datastore_name.nil?
        vm_properties =
          @cloud_searcher.get_properties(vm, Vim::VirtualMachine, ['config.hardware.device', 'name'], ensure_all: true)
        vm_name = vm_properties['name']

        unless datastore_name
          devices = vm_properties['config.hardware.device']
          datastore = get_primary_datastore(devices, vm_name)
          datastore_name = @cloud_searcher.get_property(datastore, Vim::Datastore, 'name')
        end
      end

      { datacenter: datacenter_name, datastore: datastore_name, vm: vm_name }
    end

    def get_primary_datastore(devices, vm_name = nil)
      ephemeral_disks = devices.select { |device| device.kind_of?(Vim::Vm::Device::VirtualDisk) &&
        device.backing.disk_mode != Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT }

      datastore = ephemeral_disks.first.backing.datastore
      disk_in_wrong_datastore = ephemeral_disks.find { |disk| !datastore.eql?(disk.backing.datastore) }
      if disk_in_wrong_datastore
        error_msg = vm_name ? "for VM '#{vm_name}'" : ""
        raise "Ephemeral disks #{error_msg} should all be on the same datastore. " +
            "Expected datastore '#{datastore}' to match datastore '#{disk_in_wrong_datastore.backing.datastore}'"
      end

      datastore
    end

    def clone_vm(vm, name, folder, resource_pool, options={})
      relocation_spec = Vim::Vm::RelocateSpec.new
      relocation_spec.datastore = options[:datastore] if options[:datastore]
      if options[:linked]
        relocation_spec.disk_move_type = Vim::Vm::RelocateSpec::DiskMoveOptions::CREATE_NEW_CHILD_DISK_BACKING
      end
      relocation_spec.pool = resource_pool

      clone_spec = Vim::Vm::CloneSpec.new
      clone_spec.config = options[:config] if options[:config]
      clone_spec.location = relocation_spec
      clone_spec.power_on = options[:power_on] ? true : false
      clone_spec.snapshot = options[:snapshot] if options[:snapshot]
      clone_spec.template = false

      vm.clone(folder, name, clone_spec)
    end


    # This method is used by micro bosh deployment cleaner
    def get_vms
      subfolders = []
      with_thread_name("get_vms") do
        @logger.info("Looking for VMs in: #{@datacenter.name} - #{@datacenter.master_vm_folder.path}")
        subfolders += @datacenter.master_vm_folder.mob.child_entity
        @logger.info("Looking for Stemcells in: #{@datacenter.name} - #{@datacenter.master_template_folder.path}")
        subfolders += @datacenter.master_template_folder.mob.child_entity
      end
      mobs = subfolders.map { |folder| folder.child_entity }.flatten
      mobs.map do |mob|
        VSphereCloud::Resources::VM.new(mob.name, mob, @client, @logger)
      end
    end

    def ping
      "pong"
    end

    def vm_provider
      VMProvider.new(
        @datacenter,
        @client,
        @logger
      )
    end

    private

    def import_ovf(name, ovf, resource_pool, datastore)
      import_spec_params = Vim::OvfManager::CreateImportSpecParams.new
      import_spec_params.entity_name = name
      import_spec_params.locale = 'US'
      import_spec_params.deployment_option = ''

      ovf_file = File.open(ovf)
      ovf_descriptor = ovf_file.read
      ovf_file.close

      @client.service_content.ovf_manager.create_import_spec(ovf_descriptor,
                                                             resource_pool,
                                                             datastore,
                                                             import_spec_params)
    end

    def upload_ovf(ovf, lease, file_items)
      info = @cloud_searcher.get_property(lease, Vim::HttpNfcLease, 'info', ensure_all: true)
      lease_updater = LeaseUpdater.new(client, lease)

      info.device_url.each do |device_url|
        device_key = device_url.import_key
        file_items.each do |file_item|
          if device_key == file_item.device_id
            http_client = VSphereCloud::CpiHttpClient.build

            disk_file_path = File.join(File.dirname(ovf), file_item.path)
            disk_file = File.open(disk_file_path)
            disk_file_size = File.size(disk_file_path)

            progress_thread = Thread.new do
              loop do
                lease_updater.progress = disk_file.pos * 100 / disk_file_size
                sleep(2)
              end
            end

            @logger.info("Uploading disk to: #{device_url.url}")

            http_client.post(device_url.url,
                             disk_file,
                             { 'Content-Type' => 'application/x-vnd.vmware-streamVmdk', 'Content-Length' => disk_file_size })

            progress_thread.kill
            disk_file.close
          end
        end
      end
      lease_updater.finish
      info.entity
    end

    def add_disk_to_agent_env(vm, disk, device_unit_number)
      env = @agent_env.get_current_env(vm.mob, @datacenter.name)
      @logger.info("Reading current agent env: #{env.pretty_inspect}")
      env['disks']['persistent'][disk.cid] = device_unit_number.to_s
      location = get_vm_location(vm.mob, datacenter: @datacenter.name)
      @agent_env.set_env(vm.mob, location, env)
      @logger.info("Updated agent env to: #{env.pretty_inspect}")
    end

    def delete_disk_from_agent_env(vm, disk_cid)
      vm_mob = vm.mob
      location = get_vm_location(vm_mob)
      env = @agent_env.get_current_env(vm_mob, location[:datacenter])
      @logger.info("Reading current agent env: #{env.pretty_inspect}")
      if env['disks']['persistent'][disk_cid]
        env['disks']['persistent'].delete(disk_cid)
        @logger.info("Updating agent env to: #{env.pretty_inspect}")

        @agent_env.set_env(vm_mob, location, env)
      end
    end
  end
end
