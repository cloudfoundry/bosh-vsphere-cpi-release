require 'cloud/vsphere/logger'

module VSphereCloud
  class VCenterClient
    include VimSdk
    include Logger

    class TaskException < StandardError; end
    class FileNotFoundException < TaskException; end
    class DuplicateName < TaskException; end
    class AlreadyUpgraded < TaskException; end
    class AlreadyLoggedInException < StandardError; end
    class NotLoggedInException < StandardError; end

    attr_reader :cloud_searcher, :service_content, :service_instance, :soap_stub

    def initialize(vcenter_api_uri:, http_client:)
      @soap_stub = SoapStub.new(vcenter_api_uri, http_client).create

      @service_instance = Vim::ServiceInstance.new('ServiceInstance', @soap_stub)

      begin
        @service_content = @service_instance.content
      rescue HTTPClient::ConnectTimeoutError => e
        raise "Please make sure the CPI has proper network access to vSphere. (#{e.class}: #{e.message})"
      end

      @metrics_cache  = {}
      @lock = Mutex.new

      @cloud_searcher = CloudSearcher.new(service_content)

      @task_runner = TaskRunner.new(cloud_searcher: @cloud_searcher)
    end

    def login(username, password, locale)
      raise AlreadyLoggedInException if @session
      @session = @service_content.session_manager.login(username, password, locale)
    end

    def logout
      raise NotLoggedInException unless @session
      @session = nil
      @service_content.session_manager.logout
    rescue VimSdk::SoapError => e
      logger.info "Failed to logout: #{e.message}"
    end

    def wait_for_task(&task_block)
      @task_runner.run do
        task_block.call
      end
    end

    def find_parent(obj, parent_type)
      while obj && obj.class != parent_type
        obj = @cloud_searcher.get_property(obj, obj.class, "parent", :ensure_all => true)
      end
      obj
    end

    def reconfig_vm(vm, config)
      wait_for_task do
        vm.reconfigure(config)
      end
    end

    def delete_vm(vm)
      wait_for_task do
        vm.destroy
      end
    end

    def answer_vm(vm, question, answer)
      vm.answer(question, answer)
    end

    def upgrade_vm_virtual_hardware(vm)
      logger.info("Upgrading virtual hardware on VM")
      wait_for_task do
        vm.upgrade_virtual_hardware
      end
    end

    def power_on_vm(datacenter, vm)
      wait_for_task do
        result = wait_for_task do
          datacenter.power_on_vm([vm], nil)
        end

        raise 'Recommendations were detected, you may be running in Manual DRS mode. Aborting.' if result.recommendations.any?

        vms_powering_on = result.attempted
        if vms_powering_on.empty?
          # Since we are only powering on single vm, the not_attempted member
          # of result will have length equal to one. Thus getting first one
          # from not_attempted list is the right thing to do.
          fault = result.not_attempted.first.fault
          raise VSphereCloud::VMPowerOnError.new(fault), "Could not power on VM '#{vm}'"
        end
        vms_powering_on.first.task
      end
    end

    def power_off_vm(vm_mob)
      wait_for_task do
        vm_mob.power_off
      end
    end

    def get_cdrom_device(vm)
      devices = @cloud_searcher.get_property(vm, Vim::VirtualMachine, 'config.hardware.device', ensure_all: true)
      devices.find { |device| device.kind_of?(Vim::Vm::Device::VirtualCdrom) }
    end

    def delete_path(datacenter_mob, path)
      begin
        wait_for_task do
          @service_content.file_manager.delete_file(path, datacenter_mob)
        end
      rescue => e
        unless e.message =~ /File .* was not found/
          raise e
        end
      end
    end

    def delete_disk(datacenter_mob, path)
      begin
        wait_for_task do
          service_content.virtual_disk_manager.delete_virtual_disk(
            path,
            datacenter_mob
          )
        end
      rescue => e
        unless e.message =~ /File .* was not found/
          raise e
        end
      end
    end

    def move_disk(source_datacenter_mob, source_path, dest_datacenter_mob, dest_path)
      create_parent_folder(dest_datacenter_mob, dest_path)
      logger.info("Moving disk: #{source_path} to #{dest_path}")
      wait_for_task do
        service_content.virtual_disk_manager.move_virtual_disk(
          source_path,
          source_datacenter_mob,
          dest_path,
          dest_datacenter_mob,
          false,
          nil
        )
      end
      logger.info('Moved disk')
    end

    def create_datastore_folder(folder_path, datacenter)
      @service_content.file_manager.make_directory(folder_path, datacenter, true)
    end

    def create_folder(name)
      @service_content.root_folder.create_folder(name)
    end

    def delete_folder(folder)
      wait_for_task do
        folder.destroy
      end
    end

    def find_by_inventory_path(path)
      full_path = Array(path).join("/")
      @service_content.search_index.find_by_inventory_path(full_path)
    end

    def find_vm_by_ip(ip)
      @service_content.search_index.find_by_ip(nil, ip, true)
    end

    def find_vm_by_name(datacenter_mob, vm_name)
      @cloud_searcher.find_resource_by_property_path(datacenter_mob, 'VirtualMachine', 'name') do |name|
        name == vm_name
      end
    end

    def find_vm_by_disk_cid(datacenter_mob, disk_cid)
      @cloud_searcher.find_resource_by_property_path(datacenter_mob, 'VirtualMachine', 'config.vAppConfig.property') do |vapp_properties|
        vapp_properties.any? do |prop|
          prop.label == disk_cid
        end
      end
    end

    def find_all_stemcell_replicas(datacenter_mob, stemcell_id)
      @cloud_searcher.find_resources_by_property_path(datacenter_mob, 'VirtualMachine', 'name') do |name|
        name =~ Regexp.new(stemcell_id)
      end
    end

    def find_all_stemcell_replicas_in_datastore(datacenter_mob, stemcell_id, datastore_name)
      matches = []
      find_all_stemcell_replicas(datacenter_mob, stemcell_id).each do |vm_mob|
        vm_datastore = @cloud_searcher.get_property(vm_mob, Vim::VirtualMachine, 'datastore', ensure_all: true)
        if vm_datastore.first && vm_datastore.first.name == datastore_name
          matches << vm_mob
        end
      end
      matches
    end

    def find_network(datacenter, network_name)
      valid_networks = []
      if network_name.include?('/')
        container_name = File.dirname(network_name)
        network_name = File.basename(network_name)
        network_container = find_by_inventory_path([ datacenter.name, 'network', container_name])
        if network_container.nil?
          network_container = find_child_by_name(datacenter.mob.network_folder, container_name.split('/'))
        end
        if network_container.instance_of?(VimSdk::Vim::Dvs::VmwareDistributedVirtualSwitch)
          valid_networks = network_container.portgroup
        elsif network_container.instance_of?(VimSdk::Vim::Folder)
          valid_networks = network_container.child_entity
        end
      else
        valid_networks = datacenter.mob.network
      end

      target_network = nil
      matching_networks = valid_networks.select { |n| n.name == network_name }
      if matching_networks.length == 1
        target_network = matching_networks.first
      elsif matching_networks.length > 1
        # pick the Standard Portgroup if multiple networks exist with the given name
        target_network = matching_networks.find { |n| n.instance_of?(VimSdk::Vim::Network) }
        if target_network.nil?
          raise "Multiple networks found for #{network_name}. Please specify the full path, for example 'FOLDER_NAME/DISTRIBUTED_SWITCH_NAME/DISTRIBUTED_PORTGROUP_NAME'"
        end
      end

      target_network
    end

    def get_perf_counters(mobs, names, options = {})
      metrics = find_perf_metric_names(mobs.first, names)
      metric_ids = metrics.values

      metric_name_by_id = {}
      metrics.each { |name, metric| metric_name_by_id[metric.counter_id] = name }

      queries = []
      mobs.each do |mob|
        queries << Vim::PerformanceManager::QuerySpec.new(
            :entity => mob,
            :metric_id => metric_ids,
            :format => Vim::PerformanceManager::Format::CSV,
            :interval_id => options[:interval_id] || 20,
            :max_sample => options[:max_sample])
      end

      query_perf_response = @service_content.perf_manager.query_stats(queries)

      result = {}
      query_perf_response.each do |mob_stats|
        mob_entry = {}
        counters = mob_stats.value
        counters.each do |counter_stats|
          counter_id = counter_stats.id.counter_id
          values = counter_stats.value
          mob_entry[metric_name_by_id[counter_id]] = values
        end
        result[mob_stats.entity] = mob_entry
      end
      result
    end

    def find_disk(disk_cid, datastore, disk_folder)
      disk_size_in_mb = find_disk_size_using_browser(datastore, disk_cid, disk_folder)
      disk_size_in_mb.nil? ? nil : Resources::PersistentDisk.new(cid: disk_cid, size_in_mb: disk_size_in_mb, datastore: datastore, folder: disk_folder)
    end

    def create_disk(datacenter_mob, datastore, disk_cid, disk_folder, disk_size_in_mb, disk_type)
      if disk_type.nil?
        raise 'no disk type specified'
      end

      disk_path = "[#{datastore.name}] #{disk_folder}/#{disk_cid}.vmdk"

      create_parent_folder(datacenter_mob, disk_path)

      disk_spec = VimSdk::Vim::VirtualDiskManager::FileBackedVirtualDiskSpec.new
      disk_spec.disk_type = disk_type
      disk_spec.capacity_kb = disk_size_in_mb * 1024
      disk_spec.adapter_type = 'lsiLogic'

      wait_for_task do
        service_content.virtual_disk_manager.create_virtual_disk(
          disk_path,
          datacenter_mob,
          disk_spec
        )
      end

      Resources::PersistentDisk.new(cid: disk_cid, size_in_mb: disk_size_in_mb, datastore: datastore, folder: disk_folder)
    end

    def find_disk_size_using_browser(datastore, disk_cid, disk_folder)
      search_spec_details = VimSdk::Vim::Host::DatastoreBrowser::FileInfo::Details.new
      search_spec_details.file_type = true # actually return VmDiskInfos not FileInfos

      query_details = VimSdk::Vim::Host::DatastoreBrowser::VmDiskQuery::Details.new
      query_details.capacity_kb = true

      query = VimSdk::Vim::Host::DatastoreBrowser::VmDiskQuery.new
      query.details = query_details

      search_spec = VimSdk::Vim::Host::DatastoreBrowser::SearchSpec.new
      search_spec.details = search_spec_details
      search_spec.match_pattern = ["#{disk_cid}.vmdk"]
      search_spec.query = [query]

      datastore_path = "[#{datastore.name}] #{disk_folder}"
      logger.debug("Trying to find disk in : #{datastore_path}")
      result = wait_for_task do
        datastore.mob.browser.search(datastore_path, search_spec)
      end
      disk_infos = result.file
      return nil if disk_infos.empty?

      disk_infos.first.capacity_kb / 1024
    rescue VimSdk::SoapError, FileNotFoundException
      nil
    end

    def disk_path_exists?(vm_mob, disk_path)
      match = /\[(.+)\] (.+)\/(.+\.vmdk)/.match(disk_path)
      search_spec_details = VimSdk::Vim::Host::DatastoreBrowser::FileInfo::Details.new
      search_spec_details.file_type = true # actually return VmDiskInfos not FileInfos

      search_spec = VimSdk::Vim::Host::DatastoreBrowser::SearchSpec.new
      search_spec.details = search_spec_details
      search_spec.match_pattern = [match[3]]

      datastore_path = "[#{match[1]}] #{match[2]}"
      logger.debug("Trying to find disk in : #{datastore_path}")
      result = wait_for_task do
        vm_mob.environment_browser.datastore_browser.search(datastore_path, search_spec)
      end
      vm_disk_infos = result.file
      return false if vm_disk_infos.empty?

      true
    rescue VimSdk::SoapError, FileNotFoundException
      false
    end

    def add_persistent_disk_property_to_vm(vm, disk)
      vm_disk = vm.disk_by_cid(disk.cid)
      disk_device_key = vm_disk.key

      if vm.get_vapp_property_by_key(disk_device_key) != nil
        logger.debug("Disk property already exists '#{disk.cid}' on vm '#{vm.cid}'")
        return
      end

      v_app_property_info = VimSdk::Vim::VApp::PropertyInfo.new
      v_app_property_info.key = disk_device_key
      v_app_property_info.id = disk.cid
      v_app_property_info.label = disk.cid
      v_app_property_info.category = 'BOSH Persistent Disks'
      v_app_property_info.type = 'string'
      v_app_property_info.value = disk.path
      v_app_property_info.description = 'Used by BOSH to track persistent disks. Change at your own risk.'
      v_app_property_info.user_configurable = true

      v_app_property_spec = VimSdk::Vim::VApp::PropertySpec.new
      v_app_property_spec.info = v_app_property_info
      v_app_property_spec.operation = VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD

      v_app_config_spec = VimSdk::Vim::VApp::VmConfigSpec.new
      v_app_config_spec.property << v_app_property_spec

      vm_config = Vim::Vm::ConfigSpec.new
      vm_config.v_app_config = v_app_config_spec

      reconfig_vm(vm.mob, vm_config)
    end

    def delete_persistent_disk_property_from_vm(vm, disk_device_key)
      if vm.get_vapp_property_by_key(disk_device_key).nil?
        logger.debug("Disk property[#{disk_device_key}] does not exist on vm '#{vm.cid}'")
        return
      end

      v_app_property_spec = VimSdk::Vim::VApp::PropertySpec.new
      v_app_property_spec.remove_key = disk_device_key
      v_app_property_spec.operation = VimSdk::Vim::Option::ArrayUpdateSpec::Operation::REMOVE

      v_app_config_spec = VimSdk::Vim::VApp::VmConfigSpec.new
      v_app_config_spec.property << v_app_property_spec

      vm_config = Vim::Vm::ConfigSpec.new
      vm_config.v_app_config = v_app_config_spec

      reconfig_vm(vm.mob, vm_config)
    end

    def set_custom_field(mob, name, value)
      @fields_manager ||= @service_content.custom_fields_manager
      name = name.to_s
      value = value.to_s
      field = nil

      begin
        field = @fields_manager.add_field_definition(name, mob.class, nil, nil)
      rescue SoapError => e
        if e.fault.kind_of?(Vim::Fault::NoPermission)
          logger.warn("Can't create custom field definition due to lack of permission: #{e.message}")
        elsif e.fault.kind_of?(Vim::Fault::DuplicateName)
          logger.warn("Custom field definition already exists: #{e.message}")
          custom_fields = @fields_manager.field
          field = custom_fields.find do |field|
            field.name == name && field.managed_object_type == mob.class
          end
        else
          raise e
        end
      end

      unless field.nil?
        begin
        @fields_manager.set_field(mob, field.key, value)
        rescue SoapError => e
          if e.fault.kind_of?(Vim::Fault::NoPermission)
            logger.warn("Can't set custom fields due to lack of permission: #{e.message}")
          end
        end
      end
    end

    def remove_custom_field_def(name, mob_type)
      @fields_manager ||= @service_content.custom_fields_manager
      name = name.to_s
      custom_fields = @fields_manager.field
      field = custom_fields.find do |field|
        field.name == name && field.managed_object_type == mob_type
      end
      unless field.nil?
        @fields_manager.remove_field_definition(field.key)
      end
    end

    def find_child_by_name(mob, child_path)
      return mob if child_path.empty?
      child_entity_name = child_path.shift
      find_child_by_name(mob.child_entity.find {|c| c.name == child_entity_name }, child_path)
    end

    def clean_up_vm_groups(cluster, vm_group_names)
      return if vm_group_names.empty?
      empty_vm_groups = cluster.configuration_ex.group.select do |group|
        group.is_a?(VimSdk::Vim::Cluster::VmGroup) && vm_group_names.include?(group.name) && group.vm.empty?
      end
      empty_vm_groups = cluster.configuration_ex.group.select { |group| group.is_a?(VimSdk::Vim::Cluster::VmGroup) }
      return if empty_vm_groups.empty?
      group_specs = empty_vm_groups.collect do |vm_group|
        vm_group_spec = VimSdk::Vim::Cluster::VmGroup.new
        vm_group_spec.name = vm_group.name

        group_spec = VimSdk::Vim::Cluster::GroupSpec.new
        group_spec.info = vm_group_spec
        group_spec.operation =  'remove'
        group_spec.remove_key = vm_group.name
        group_spec
      end
      config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
      config_spec.group_spec = group_specs
      wait_for_task do
        cluster.reconfigure_ex(config_spec, true)
      end
    end

    private

    def find_perf_metric_names(mob, names)
      @lock.synchronize do
        unless @metrics_cache.has_key?(mob.class)
          @metrics_cache[mob.class] = fetch_perf_metric_names(mob)
        end
      end

      result = {}
      @metrics_cache[mob.class].each do |name, metric|
        result[name] = metric if names.include?(name)
      end

      result
    end

    def fetch_perf_metric_names(mob)
      metrics = @service_content.perf_manager.query_available_metric(mob, nil, nil, 300)
      metric_ids = metrics.collect { |metric| metric.counter_id }

      metric_names = {}
      metrics_info = @service_content.perf_manager.query_counter(metric_ids)
      metrics_info.each do |perf_counter_info|
        name = "#{perf_counter_info.group_info.key}.#{perf_counter_info.name_info.key}.#{perf_counter_info.rollup_type}"
        metric_names[perf_counter_info.key] = name
      end

      result = {}
      metrics.each { |metric| result[metric_names[metric.counter_id]] = metric }
      result
    end

    def create_parent_folder(datacenter_mob, disk_path)
      destination_folder = File.dirname(disk_path)
      create_datastore_folder(destination_folder, datacenter_mob)
    end
  end
end
