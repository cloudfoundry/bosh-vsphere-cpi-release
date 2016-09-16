module VSphereCloud
  module Resources
    class VM
      include VimSdk
      include ObjectStringifier
      stringify_with :cid

      attr_reader :mob, :cid

      def initialize(cid, mob, client, logger)
        @client = client
        @mob = mob
        @cid = cid
        @logger = logger
      end

      def inspect
        "<VM: #{@mob} / #{@cid}>"
      end

      def cluster
        cluster = cloud_searcher.get_properties(host_properties['parent'], Vim::ClusterComputeResource, 'name', ensure_all: true)
        cluster['name']
      end

      def resource_pool
        properties['resourcePool'].name
      end

      def accessible_datastore_names
        host_properties['datastore'].map do |store|
          ds = cloud_searcher.get_properties(
            store,
            Vim::Datastore,
            ['name', 'summary.accessible'],
            ensure_all: true
          )
          if ds['summary.accessible']
            ds['name']
          else
            nil
          end
        end.compact
      end

      def mob_id
        @mob.__mo_id__
      end

      def datacenter_mob
        @client.find_parent(@mob, Vim::Datacenter)
      end

      def powered_on?
        power_state == Vim::VirtualMachine::PowerState::POWERED_ON
      end

      def devices
        properties['config.hardware.device']
      end

      def nics
        devices.select { |device| device.kind_of?(Vim::Vm::Device::VirtualEthernetCard) }
      end

      def cdrom
        devices.find { |device| device.kind_of?(Vim::Vm::Device::VirtualCdrom) }
      end

      def system_disk
        devices.find { |device| device.kind_of?(Vim::Vm::Device::VirtualDisk) }
      end

      def persistent_disks
        virtual_disks = devices.select do |device|
          device.kind_of?(Vim::Vm::Device::VirtualDisk)
        end

        # To account for disk modes that were changed outside of the CPI,
        # we can additionally look for the device key in the vapp config to ensure
        # all persistent disks are returned
        persistent_device_keys = persistent_disk_device_keys_from_vapp_config
        virtual_disks.select do |device|
          device.backing.disk_mode == Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_PERSISTENT ||
            persistent_device_keys.any? { |key| device.key == key }
        end
      end

      def ephemeral_disk
        devices.find do |device|
          device.kind_of?(Vim::Vm::Device::VirtualDisk) && device.backing.file_name =~ /#{Resources::EphemeralDisk::DISK_NAME}.vmdk$/
        end
      end

      def pci_controller
        devices.find { |device| device.kind_of?(Vim::Vm::Device::VirtualPCIController) }
      end

      def fix_device_unit_numbers(device_changes)
        controllers_available_unit_numbers = Hash.new { |h, k| h[k] = (0..15).to_a }
        devices.each do |device|
          if device.controller_key
            available_unit_numbers = controllers_available_unit_numbers[device.controller_key]
            available_unit_numbers.delete(device.unit_number)
          end
        end

        device_changes.each do |device_change|
          device = device_change.device
          if device.controller_key && device.unit_number.nil?
            available_unit_numbers = controllers_available_unit_numbers[device.controller_key]
            raise "No available unit numbers for device: #{device.inspect}" if available_unit_numbers.empty?
            device.unit_number = available_unit_numbers.shift
          end
        end
      end

      def shutdown
        check_for_nonpersistent_disk_modes

        @logger.debug('Waiting for the VM to shutdown')
        begin
          begin
            @mob.shutdown_guest
          rescue => e
            @logger.debug("Ignoring possible race condition when a VM has powered off by the time we ask it to shutdown: #{e.inspect}")
          end

          wait_until_off(60)
        rescue VSphereCloud::Cloud::TimeoutException
          @logger.debug('The guest did not shutdown in time, requesting it to power off')
          @client.power_off_vm(@mob)
        end
      end

      def power_off
        check_for_nonpersistent_disk_modes

        question = properties['runtime.question']
        if question
          choices = question.choice
          @logger.info("VM is blocked on a question: #{question.text}, " +
              "providing default answer: #{choices.choice_info[choices.default_index].label}")
          @client.answer_vm(@mob, question.id, choices.choice_info[choices.default_index].key)
        end

        # get current power state from the server
        power_state = cloud_searcher.get_property(@mob, Vim::VirtualMachine, 'runtime.powerState')

        if power_state != Vim::VirtualMachine::PowerState::POWERED_OFF
          @client.power_off_vm(@mob)
        else
          @logger.info("VM '#{@cid}' is already powered off, skipping power off task.")
        end
      end

      def disk_by_cid(disk_cid)
        disk = devices.find do |d|
          d.kind_of?(Vim::Vm::Device::VirtualDisk) &&
            d.backing.file_name.end_with?("/#{disk_cid}.vmdk")
        end
        if disk.nil?
          return disk_by_original_cid(disk_cid)
        else
          return disk
        end
      end

      def disk_path_by_cid(disk_cid)
        disk = disk_by_cid(disk_cid)
        disk.backing.file_name unless disk.nil?
      end

      def reboot
        check_for_nonpersistent_disk_modes
        @mob.reboot_guest
      end

      def power_on
        @client.power_on_vm(datacenter_mob, @mob)
      end

      def delete
        @client.delete_vm(@mob)
      end

      def reload
        @properties = nil
        @host_properties = nil
      end

      def wait_until_off(timeout)
        started = Time.now
        loop do
          power_state = cloud_searcher.get_property(@mob, Vim::VirtualMachine, 'runtime.powerState')
          break if power_state == Vim::VirtualMachine::PowerState::POWERED_OFF
          raise VSphereCloud::Cloud::TimeoutException if Time.now - started > timeout
          sleep(1.0)
        end
      end

      def power_state
        properties['runtime.powerState']
      end

      def has_persistent_disk_property_mismatch?(disk)
        found_property = get_vapp_property_by_key(disk.key)
        return false if found_property.nil? || !verify_persistent_disk_property?(found_property)

        # get full path without a datastore
        file_path = disk.backing.file_name[/([^\]]*)\.vmdk/, 1].strip
        original_file_path = found_property.value[/([^\]]*)\.vmdk/, 1].strip
        @logger.debug("Current file path is #{file_path}")
        @logger.debug("Original file path is #{original_file_path}")

        file_path != original_file_path
      end

      def get_old_disk_filepath(disk_key)
        property = get_vapp_property_by_key(disk_key)
        if property.nil? || !verify_persistent_disk_property?(property)
          @logger.debug("Can't find persistent disk property for disk #{disk_key}")
          return nil
        end

        property.value
      end

      def get_vapp_property_by_key(key)
        v_app_config = @mob.config.v_app_config
        return nil if v_app_config.nil?
        v_app_config.property.find { |property| property.key == key }
      end

      def attach_disk(disk_resource_object)
        disk = disk_resource_object
        disk_config_spec = disk.create_disk_attachment_spec(disk_controller_id: system_disk.controller_key)

        vm_config = Vim::Vm::ConfigSpec.new
        vm_config.device_change = []
        vm_config.device_change << disk_config_spec
        fix_device_unit_numbers(vm_config.device_change)

        @logger.info('Attaching disk')
        @client.reconfig_vm(@mob, vm_config)
        @logger.info('Finished attaching disk')

        reload
        @logger.debug("Adding persistent disk property to vm '#{@cid}'")
        @client.add_persistent_disk_property_to_vm(self, disk)
        @logger.debug('Finished adding persistent disk property to vm')
        return disk_config_spec
      end

      def detach_disks(virtual_disks)
        reload
        check_for_nonpersistent_disk_modes

        disks_to_move = []
        @logger.info("Found #{virtual_disks.size} persistent disk(s)")
        config = Vim::Vm::ConfigSpec.new
        config.device_change = []

        virtual_disks.each do |virtual_disk|
          @logger.info("Detaching: #{virtual_disk.backing.file_name}")
          config.device_change << Resources::VM.create_delete_device_spec(virtual_disk)

          disk_property = get_vapp_property_by_key(virtual_disk.key)
          unless disk_property.nil?
            if has_persistent_disk_property_mismatch?(virtual_disk) && !@client.disk_path_exists?(@mob, disk_property.value)
              @logger.info('Persistent disk was moved: moving disk to expected location')
              disks_to_move << virtual_disk
            end
          end
        end

        @client.reconfig_vm(@mob, config)
        @logger.info("Detached #{virtual_disks.size} persistent disk(s)")

        move_disks_to_old_path(disks_to_move)

        @logger.info('Finished detaching disk(s)')

        virtual_disks.each do |disk|
          @logger.debug("Deleting persistent disk property #{disk.key} from vm '#{@cid}'")
          @client.delete_persistent_disk_property_from_vm(self, disk.key)
        end
        @logger.debug('Finished deleting persistent disk properties from vm')
      end

      def move_disks_to_old_path(disks_to_move)
        @logger.info("Renaming #{disks_to_move.size} persistent disk(s)")
        disks_to_move.each do |virtual_disk|
          current_path = virtual_disk.backing.file_name

          current_datastore = current_path.split(" ").first
          original_disk_path = get_old_disk_filepath(virtual_disk.key)
          dest_filename = original_disk_path.split(" ").last
          dest_path = "#{current_datastore} #{dest_filename}"

          @client.move_disk(datacenter_mob, current_path, datacenter_mob, dest_path)
        end
      end

      def self.create_delete_device_spec(device, options = {})
        device_config_spec = Vim::Vm::Device::VirtualDeviceSpec.new
        device_config_spec.device = device
        device_config_spec.operation = Vim::Vm::Device::VirtualDeviceSpec::Operation::REMOVE
        if options[:destroy]
          device_config_spec.file_operation = Vim::Vm::Device::VirtualDeviceSpec::FileOperation::DESTROY
        end

        device_config_spec
      end

      def self.create_add_device_spec(device)
        device_config_spec = VimSdk::Vim::Vm::Device::VirtualDeviceSpec.new
        device_config_spec.device = device
        device_config_spec.operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD

        device_config_spec
      end

      def self.create_edit_device_spec(device)
        device_config_spec = Vim::Vm::Device::VirtualDeviceSpec.new
        device_config_spec.device = device
        device_config_spec.operation = Vim::Vm::Device::VirtualDeviceSpec::Operation::EDIT

        device_config_spec
      end

      private

      def verify_persistent_disk_property?(property)
        property.category == 'BOSH Persistent Disks'
      end

      def properties
        @properties ||= cloud_searcher.get_properties(
          @mob,
          Vim::VirtualMachine,
          ['runtime.powerState', 'runtime.question', 'config.hardware.device', 'name', 'runtime', 'resourcePool'],
          ensure: ['config.hardware.device', 'runtime']
        )
      end

      def host_properties
        @host_properties ||= cloud_searcher.get_properties(
          properties['runtime'].host,
          Vim::HostSystem,
          ['datastore', 'parent'],
          ensure_all: true
        )
      end

      def persistent_disk_device_keys_from_vapp_config
        v_app_config = @mob.config.v_app_config
        return [] if v_app_config.nil?

        disk_properties = v_app_config.property.select do |property|
          property.category == 'BOSH Persistent Disks'
        end
        disk_properties.map { |property| property.key }
      end

      def cloud_searcher
        @client.cloud_searcher
      end

      def disk_by_original_cid(disk_cid)
        disks = devices.select { |d| d.kind_of?(Vim::Vm::Device::VirtualDisk) }
        disks.each do |d|
          disk_property = get_vapp_property_by_key(d.key)
          if disk_property.nil?
            next
          end
          if verify_persistent_disk_property?(disk_property) && disk_property.label == disk_cid
            return d
          end
        end
        nil
      end

      def check_for_nonpersistent_disk_modes
        nonpersistent_file_names = []
        persistent_disks.each do |disk|
          if disk.backing.disk_mode == VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
            nonpersistent_file_names << disk.backing.file_name
          end
        end

        unless nonpersistent_file_names.empty?
          raise "The following disks are attached with non-persistent disk modes: [ #{nonpersistent_file_names.join(', ')} ]. Please change the disk modes to 'independent persistent' before attempting to power off the VM to avoid data loss."
        end
      end
    end
  end
end
