require 'json'
require 'membrane'
require 'cloud'

module VSphereCloud
  class Cloud < Bosh::Cloud
    include VimSdk

    class TimeoutException < StandardError; end
    class NetworkException < StandardError
      attr_accessor :vm_cid

      def message
        super + (vm_cid ? " for VM '#{vm_cid}'" : '')
      end
    end

    attr_accessor :client, :logger # exposed for testing
    attr_reader :config, :datacenter, :heartbeat_thread

    def enable_telemetry
      http_client = VSphereCloud::CpiHttpClient.new
      other_client = VCenterClient.new(
        vcenter_api_uri: @config.vcenter_api_uri,
        http_client: http_client,
        logger: Logger.new('/dev/null'),
      )
      other_client.login(@config.vcenter_user, @config.vcenter_password, 'en')
      option = Vim::Option::OptionValue.new
      option.key = 'config.SDDC.cpi'
      option.value = 'true'
      other_client.service_content.setting.query_view(option.key)
    rescue => e
      return unless e.fault.is_a?(Vim::Fault::InvalidName)
      other_client.service_content.setting.update_values([option]) rescue nil
    ensure
      other_client.logout rescue nil
    end

    def initialize(options)
      @config = Config.build(options)

      @logger = config.logger

      request_id = options['vcenters'][0]['request_id']
      if request_id
        @logger.set_request_id(request_id)
      end

      @http_client = VSphereCloud::CpiHttpClient.new(@config.soap_log)

      @client = VCenterClient.new(
        vcenter_api_uri: @config.vcenter_api_uri,
        http_client: @http_client,
        logger: @logger,
      )
      @client.login(@config.vcenter_user, @config.vcenter_password, 'en')

      @cloud_searcher = CloudSearcher.new(@client.service_content, @logger)
      @cluster_provider = Resources::ClusterProvider.new(
        datacenter_name: @config.datacenter_name,
        client: @client,
        logger: @logger,
      )
      @datacenter = Resources::Datacenter.new(
        client: @client,
        ephemeral_pattern: @config.datacenter_datastore_pattern,
        persistent_pattern: @config.datacenter_persistent_datastore_pattern,
        use_sub_folder: @config.datacenter_use_sub_folder,
        vm_folder: @config.datacenter_vm_folder,
        template_folder: @config.datacenter_template_folder,
        name: @config.datacenter_name,
        disk_path: @config.datacenter_disk_path,
        clusters: @config.datacenter_clusters,
        cluster_provider: @cluster_provider,
        logger: @logger,
      )
      @file_provider = FileProvider.new(
        http_client: @http_client,
        vcenter_host: @config.vcenter_host,
        logger: @logger
      )
      @agent_env = AgentEnv.new(
        client: client,
        file_provider: @file_provider,
        cloud_searcher: @cloud_searcher,
        logger: @logger,
      )

      # Setup NSX-T Provider
      @nsxt_provider = NSXTProvider.new(@config.nsxt, @logger) if @config.nsxt_enabled?

      # We get disconnected if the connection is inactive for a long period.
      @heartbeat_thread = Thread.new do
        while true do
          sleep(60)
          @client.service_instance.current_time
        end
      end

      setup_at_exit
    end

    def setup_at_exit
      # HACK: finalizer not getting called, so we'll rely on at_exit
      at_exit do
        begin
          @client.logout
        rescue VSphereCloud::VCenterClient::NotLoggedInException
        end
      end
    end

    def has_vm?(vm_cid)
      vm_provider.find(vm_cid)
      true
    rescue Bosh::Clouds::VMNotFound
      false
    end

    def has_disk?(raw_director_disk_cid)
      director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)
      @datacenter.find_disk(director_disk_cid)
      true
    rescue Bosh::Clouds::DiskNotFound
      false
    end

    def create_stemcell(image, _)
      with_thread_name("create_stemcell(#{image}, _)") do
        # Add cpi telemetry advanced config to vc in a separate thread
        telemetry_thread = Thread.new { enable_telemetry }
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
          vm_type = VmType.new(@datacenter, {'ram' => 0})

          # TODO: this code re-use is messy, extract the necessary functionality out of vm_config
          manifest_params = {
            vm_type: vm_type,
            global_clusters: @datacenter.clusters,
            disk_configurations: [
              VSphereCloud::DiskConfig.new(
                size: stemcell_size,
                target_datastore_pattern: @datacenter.ephemeral_pattern,
                ephemeral: true
              )
            ],
          }
          vm_config = VmConfig.new(
            manifest_params: manifest_params,
            cluster_picker: ClusterPicker.new,
          )
          datastore_name = vm_config.ephemeral_datastore_name
          cluster = vm_config.cluster
          datastore = @datacenter.find_datastore(datastore_name)

          @logger.info("Deploying to: #{cluster.mob} / #{datastore.mob}")

          import_spec_result = import_ovf(name, ovf_file, cluster.resource_pool.mob, datastore.mob)

          system_disk = import_spec_result.import_spec.config_spec.device_change.find do |change|
            change.device.kind_of?(Vim::Vm::Device::VirtualDisk)
          end.device
          system_disk.backing.thin_provisioned = @config.vcenter_default_disk_type == 'thin'

          lease_obtainer = LeaseObtainer.new(@cloud_searcher, @logger)
          nfc_lease = lease_obtainer.obtain(
            cluster.resource_pool,
            import_spec_result.import_spec,
            @datacenter.template_folder,
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
          client.wait_for_task do
            vm.create_snapshot('initial', nil, false, false)
          end
        end
        telemetry_thread.join #Join back the thread created to enable telemetry

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
      matches = client.find_all_stemcell_replicas(@datacenter.mob, name)
      if matches.nil?
        return nil
      else
        matches[0]
      end
    end

    def create_vm(agent_id, stemcell_cid, vm_type, networks_spec, existing_disk_cids = [], environment = nil)
      with_thread_name("create_vm(#{agent_id}, ...)") do
        verify_props('VM', [ 'cpu', 'ram', 'disk' ], vm_type)

        stemcell_vm = stemcell_vm(stemcell_cid)
        raise "Could not find VM for stemcell '#{stemcell_cid}'" if stemcell_vm.nil?
        begin
          stemcell_size = @cloud_searcher.get_property(
            stemcell_vm,
            VimSdk::Vim::VirtualMachine,
            'summary.storage.committed',
            ensure_all: true
          )
          stemcell_size /= 1024 * 1024

          vm_type = VmType.new(@datacenter, vm_type)

          manifest_params = {
            vm_type: vm_type,
            networks_spec: networks_spec,
            agent_id: agent_id,
            agent_env: environment,
            stemcell: {
              cid: stemcell_cid,
              size: stemcell_size
            },
            global_clusters: @datacenter.clusters,
            disk_configurations: disk_configurations(vm_type,  existing_disk_cids),
          }

          vm_config = VmConfig.new(
            manifest_params: manifest_params,
            cluster_picker: ClusterPicker.new,
            cluster_provider: @cluster_provider
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
            default_disk_type: @config.vcenter_default_disk_type,
            enable_auto_anti_affinity_drs_rules: @config.vcenter_enable_auto_anti_affinity_drs_rules,
            stemcell: Stemcell.new(stemcell_cid, @logger)
          )
          created_vm = vm_creator.create(vm_config)
        rescue => e
          @logger.error("Error in creating vm: #{e}, Backtrace - #{e.backtrace.join("\n")}")
          raise e
        end

        begin
          if @config.nsxt_enabled?
            @nsxt_provider.add_vm_to_nsgroups(created_vm, vm_type.nsxt)
            @nsxt_provider.set_vif_type(created_vm, vm_type.nsxt)
          end
        rescue => e
          @logger.info("Failed to add VM '#{created_vm.cid}' to NSGroups with error: #{e}")
          begin
            @logger.info("Deleting VM '#{created_vm.cid}'...")
            delete_vm(created_vm.cid)
          rescue => ex
            @logger.info("Failed to delete VM '#{created_vm.cid}' with message: #{ex.inspect}")
          end
          raise e
        end

        begin

          vm_type.nsx_security_groups.each do |security_group|
            nsx.add_vm_to_security_group(security_group, created_vm.mob_id)
          end unless vm_type.nsx_security_groups.nil?


          if @config.nsx_enabled?
            bosh_groups = (environment || {}).fetch('bosh', {}).fetch('groups', [])
            bosh_groups.each do |security_group|
              nsx.add_vm_to_security_group(security_group, created_vm.mob_id)
            end
          end

          unless vm_type.nsx_lbs.nil?
            security_groups = vm_type.nsx_lbs.map { |m| m['security_group'] }.uniq
            security_groups.each { |sg| nsx.add_vm_to_security_group(sg, created_vm.mob_id) }
            nsx.add_members_to_lbs(vm_type.nsx_lbs)
          end
        rescue => e
          @logger.info("Failed to apply NSX properties to VM '#{created_vm.cid}' with error: #{e}")
          begin
            @logger.info("Deleting VM '#{created_vm.cid}'...")
            delete_vm(created_vm.cid)
          rescue => ex
            @logger.info("Failed to delete vm '#{created_vm.cid}' with message:  #{ex.inspect}")
          end
          raise e
        end

        created_vm.cid
      end
    end

    def calculate_vm_cloud_properties(vm_properties)
      required_properties = ['ram', 'cpu', 'ephemeral_disk_size']
      missing_properties = required_properties.reject { |name| vm_properties.has_key?(name) }
      raise "Missing VM cloud properties: #{missing_properties.map{ |sym| "'#{sym}'"}.join(', ')}" unless missing_properties.empty?
      vm_properties['disk'] = vm_properties.delete 'ephemeral_disk_size'
      vm_properties
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
        @agent_env.clean_env(vm.mob) if vm.cdrom

        if @config.nsxt_enabled?
          begin
            @nsxt_provider.remove_vm_from_nsgroups(vm)
          rescue => e
            @logger.info("Failed to remove VM from NSGroups: #{e.message}")
          end
        end

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
          vm.power_off if vm.powered_on?

          vm.power_on
        end
      end
    end

    def set_vm_metadata(vm_cid, metadata)
      with_thread_name("set_vm_metadata(#{vm_cid}, ...)") do
        vm = vm_provider.find(vm_cid)
        metadata.each do |name, value|
          client.set_custom_field(vm.mob, name, value)
        end
        @nsxt_provider.update_vm_metadata_on_logical_ports(vm, metadata) if @config.nsxt_enabled?
      end
    end

    def set_disk_metadata(disk_id, metadata)
      # not implemented
    end

    def resize_disk(disk_id, new_size)
      # not implemented
    end

    def configure_networks(vm_cid, networks)
      raise Bosh::Clouds::NotSupported, 'configure_networks is no longer supported'
    end

    def attach_disk(vm_cid, raw_director_disk_cid)
      with_thread_name("attach_disk(#{vm_cid}, #{raw_director_disk_cid})") do
        director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)
        vm = vm_provider.find(vm_cid)

        disk_to_attach = @datacenter.find_disk(director_disk_cid)

        disk_config = VSphereCloud::DiskConfig.new(
          cid: disk_to_attach.cid,
          size: disk_to_attach.size_in_mb,
          existing_datastore_name: disk_to_attach.datastore.name,
          target_datastore_pattern: director_disk_cid.target_datastore_pattern || @datacenter.persistent_pattern
        )

        accessible_datastores = @datacenter.accessible_datastores
        reachable_datastores = vm.accessible_datastore_names
        accessible_datastores.select! { |name| reachable_datastores.include?(name) }
        disk_is_accessible = accessible_datastores.include?(disk_config.existing_datastore_name)

        disk_is_in_target_datastore = disk_config.existing_datastore_name =~ Regexp.new(disk_config.target_datastore_pattern)

        unless disk_is_accessible && disk_is_in_target_datastore
          datastore_picker = DatastorePicker.new
          datastore_picker.update(accessible_datastores)
          datastore_name = datastore_picker.pick_datastore_for_single_disk(disk_config)

          destination_datastore = @datacenter.find_datastore(datastore_name)
          disk_to_attach = @datacenter.move_disk_to_datastore(disk_to_attach, destination_datastore)
        end

        disk_spec = vm.attach_disk(disk_to_attach)
        # Overwrite cid with the director cid
        # Since director sends messages with "director cid" to agent, the agent needs that ID in its env, not the clean_cid
        add_disk_to_agent_env(vm, director_disk_cid, disk_spec.device.unit_number)
      end
    end

    def detach_disk(vm_cid, raw_director_disk_cid)
      with_thread_name("detach_disk(#{vm_cid}, #{raw_director_disk_cid})") do
        director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)

        @logger.info("Detaching disk: #{director_disk_cid.value} from vm: #{vm_cid}")

        vm = vm_provider.find(vm_cid)
        disk = vm.disk_by_cid(director_disk_cid.value)
        raise Bosh::Clouds::DiskNotAttached.new(true), "Disk '#{director_disk_cid.value}' is not attached to VM '#{vm_cid}'" if disk.nil?

        vm.detach_disks([disk])
        delete_disk_from_agent_env(vm, director_disk_cid)
      end
    end

    def create_disk(size_in_mb, cloud_properties, vm_cid = nil)
      with_thread_name("create_disk(#{size_in_mb}, _)") do
        @logger.info("Creating disk with size: #{size_in_mb}")
        if vm_cid
          vm = vm_provider.find(vm_cid)
          accessible_datastores = vm.accessible_datastores
        else
          accessible_datastores = @datacenter.accessible_datastores
        end

        disk_pool = DiskPool.new(@datacenter,  cloud_properties['datastores'])
        target_datastore_pattern = StoragePicker.choose_persistent_pattern(disk_pool, @logger)
        datastore_name = StoragePicker.choose_persistent_storage(size_in_mb, target_datastore_pattern, accessible_datastores)

        if vm_cid
          #This is to take into account datastore which might be accessible from cluster defined in cloud config
          ##datacenter.accessible_datastores includes datastores based on global config, so cannot use that here
          datastore = accessible_datastores[datastore_name]
          raise "Can't find datastore '#{datastore_name}'" if datastore.nil?
        else
          datastore = @datacenter.find_datastore(datastore_name)
        end


        @logger.info("Using datastore #{datastore.name} to store persistent disk")

        disk_type = cloud_properties.fetch('type', @config.vcenter_default_disk_type)
        disk = @datacenter.create_disk(datastore, size_in_mb, disk_type)
        @logger.info("Created disk: #{disk.inspect}")

        disk_pool.storage_list.any? ? DirectorDiskCID.encode(disk.cid, target_datastore_pattern: target_datastore_pattern) : disk.cid
      end
    end

    def delete_disk(raw_director_disk_cid)
      with_thread_name("delete_disk(#{raw_director_disk_cid})") do
        director_disk_cid = DirectorDiskCID.new(raw_director_disk_cid)
        @logger.info("Deleting disk: #{director_disk_cid.value}")
        disk = @datacenter.find_disk(director_disk_cid)
        client.delete_disk(@datacenter.mob, disk.path)

        @logger.info('Finished deleting disk')
      end
    end

    def generate_network_env(devices, networks, dvs_index)
      nics = {}

      devices.each do |device|
        if device.kind_of?(Vim::Vm::Device::VirtualEthernetCard)
          backing = device.backing
          if backing.kind_of?(Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo)
            v_network_name = dvs_index[backing.port.portgroup_key]
          elsif backing.kind_of?(Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo)
            v_network_name = dvs_index[backing.opaque_network_id]
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
      with_thread_name('get_vms') do
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
      'pong'
    end

    def vm_provider
      VMProvider.new(
        @datacenter,
        @client,
        @logger
      )
    end

    def nsx
      return @nsx if @nsx

      @config.validate_nsx_options

      nsx_http_client = NsxHttpClient.new(
        @config.nsx_user,
        @config.nsx_password,
        @config.soap_log,
      )
      @nsx = NSX.new(@config.nsx_url, nsx_http_client, @logger)
    end

    def cleanup
      @heartbeat_thread.terminate
      @client.logout
      rescue VSphereCloud::VCenterClient::NotLoggedInException
    end

    def info
      {'stemcell_formats' =>  ['vsphere-ovf', 'vsphere-ova']}
    end

    #creates T1 router and virtual switch attached to it
    def create_subnet(subnet_definition)
      cloud_properties = subnet_definition['cloud_properties']
      raise 'cloud_properties must be provided' if cloud_properties.nil?
      subnet = create_subnet_obj(subnet_definition['range'], subnet_definition['gateway'])

      t1_router = @nsxt_provider.create_t1_router(cloud_properties['edge_cluster_id'], cloud_properties['t1_name'])
      @nsxt_provider.enable_route_advertisement(t1_router.id)
      @nsxt_provider.attach_t1_to_t0(cloud_properties['t0_router_id'], t1_router.id)
      switch = @nsxt_provider.create_logical_switch(cloud_properties['transport_zone_id'], cloud_properties['switch_name'])
      @nsxt_provider.attach_switch_to_t1(switch.id, t1_router.id, subnet)
      {:network_cid => switch.id, :cloud_properties => {:name => switch.display_name } }
    end

    def delete_subnet(switch_id)
      raise 'switch id must be provided for deleting a subnet' if switch_id.nil?
      t1_router_id = @nsxt_provider.get_attached_router_id(switch_id)
      @nsxt_provider.delete_logical_switch(switch_id)
      attached_switches = @nsxt_provider.get_attched_switches_ids(t1_router_id)
      raise "Can not delete router #{t1_router_id}. It has extra ports that are not created by BOSH." if attached_switches.length != 0
      @nsxt_provider.delete_t1_router(t1_router_id)
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

            @file_provider.upload_file_to_url(device_url.url,
                             disk_file,
                             { 'Content-Type' => 'application/x-vnd.vmware-streamVmdk' })

            progress_thread.kill
            disk_file.close
          end
        end
      end
      lease_updater.finish
      info.entity
    end

    def get_vm_env_datastore_name(vm)
      cdrom = @client.get_cdrom_device(vm.mob)
      cdrom.backing.datastore.name
    end

    def add_disk_to_agent_env(vm, director_disk_cid, device_unit_number)
      env = @agent_env.get_current_env(vm.mob, @datacenter.name)
      env['disks']['persistent'][director_disk_cid.raw] = device_unit_number.to_s
      location = { datacenter: @datacenter.name, datastore: get_vm_env_datastore_name(vm), vm: vm.cid }
      @agent_env.set_env(vm.mob, location, env)
    end

    def delete_disk_from_agent_env(vm, director_disk_cid)
      env = @agent_env.get_current_env(vm.mob, @datacenter.name)
      location = { datacenter: @datacenter.name, datastore: get_vm_env_datastore_name(vm), vm: vm.cid }

      if env['disks']['persistent'][director_disk_cid.raw]
        env['disks']['persistent'].delete(director_disk_cid.raw)

        @agent_env.set_env(vm.mob, location, env)
      end
    end

    def verify_props(type, required_properties, properties)
      for prop in required_properties
        if properties[prop].nil?
          raise "Must specify '#{prop}' in #{type} cloud properties."
        end
      end
    end

    #returns disk_configuration for existing_disks and ephemeral_disk
    def disk_configurations(vm_type, existing_disk_cids=[])
      #existing persistent disk configurations
      disk_configurations = existing_disk_cids.map do |cid|
        directory_disk_cid = DirectorDiskCID.new(cid)
        disk = @datacenter.find_disk(directory_disk_cid)
        VSphereCloud::DiskConfig.new(
          cid: disk.cid,
          size: disk.size_in_mb,
          existing_datastore_name: disk.datastore.name,
          target_datastore_pattern: directory_disk_cid.target_datastore_pattern || @datacenter.persistent_pattern
        )
      end
      #ephemeral disk configuration
      ephemeral_pattern = StoragePicker.choose_ephemeral_pattern(vm_type, @logger)
      ephemeral_disk_config = VSphereCloud::DiskConfig.new(
        size: vm_type.disk,
        ephemeral: true,
        target_datastore_pattern: ephemeral_pattern
      )
      disk_configurations.push(ephemeral_disk_config)
    end

    #This subnet will be used in create_logical_router_port.
    # ip_addresses is going to be a gateway IP for subnet - aka IP for router.
    def create_subnet_obj(range, gateway)
      if (!range.nil? && range.include?('/'))
        _, mask = range.split("/")
        return NSXT::IPSubnet.new({:ip_addresses => [gateway],
                                   :prefix_length => mask.to_i})
      end
      raise 'Incorrect subnet definition. Proper CIDR block must be given'
    end
  end
end
