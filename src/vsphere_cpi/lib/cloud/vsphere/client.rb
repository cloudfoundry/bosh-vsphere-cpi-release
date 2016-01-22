module VSphereCloud
  class Client
    include VimSdk

    class TaskException < StandardError; end
    class FileNotFoundException < TaskException; end
    class DuplicateName < TaskException; end
    class AlreadyLoggedInException < StandardError; end
    class NotLoggedInException < StandardError; end

    attr_reader :cloud_searcher, :service_content, :service_instance, :soap_stub

    def initialize(host, options={})
      @soap_stub = SoapStub.new(host, options[:soap_log]).create

      @service_instance = Vim::ServiceInstance.new('ServiceInstance', @soap_stub)

      begin
        @service_content = @service_instance.content
      rescue HTTPClient::ConnectTimeoutError => e
        raise "Please make sure the CPI has proper network access to vSphere. (#{e.class}: #{e.message})"
      end

      @metrics_cache  = {}
      @lock = Mutex.new
      @logger = options.fetch(:logger) { Bosh::Clouds::Config.logger }

      @cloud_searcher = CloudSearcher.new(service_content, @logger)
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
      @logger.info "Failed to logout: #{e.message}"
    end

    def find_parent(obj, parent_type)
      while obj && obj.class != parent_type
        obj = @cloud_searcher.get_property(obj, obj.class, "parent", :ensure_all => true)
      end
      obj
    end

    def reconfig_vm(vm, config)
      task = vm.reconfigure(config)
      wait_for_task(task)
    end

    def delete_vm(vm)
      task = vm.destroy
      wait_for_task(task)
    end

    def answer_vm(vm, question, answer)
      vm.answer(question, answer)
    end

    def power_on_vm(datacenter, vm)
      task = datacenter.power_on_vm([vm], nil)
      result = wait_for_task(task)

      raise 'Recommendations were detected, you may be running in Manual DRS mode. Aborting.' if result.recommendations.any?

      if result.attempted.empty?
        raise "Could not power on VM '#{vm}': #{result.not_attempted.map(&:fault).map(&:msg).join(', ')}"
      else
        task = result.attempted.first.task
        wait_for_task(task)
      end
    end

    def power_off_vm(vm_mob)
      task = vm_mob.power_off
      wait_for_task(task)
    end

    def get_cdrom_device(vm)
      devices = @cloud_searcher.get_property(vm, Vim::VirtualMachine, 'config.hardware.device', ensure_all: true)
      devices.find { |device| device.kind_of?(Vim::Vm::Device::VirtualCdrom) }
    end

    def delete_path(datacenter_mob, path)
      task = @service_content.file_manager.delete_file(path, datacenter_mob)
      begin
        wait_for_task(task)
      rescue => e
        unless e.message =~ /File .* was not found/
          raise e
        end
      end
    end

    def delete_disk(datacenter_mob, path)
      task = service_content.virtual_disk_manager.delete_virtual_disk(
        path,
        datacenter_mob
      )

      begin
        wait_for_task(task)
      rescue => e
        unless e.message =~ /File .* was not found/
          raise e
        end
      end
    end

    def move_disk(source_datacenter_mob, source_path, dest_datacenter_mob, dest_path)
      create_parent_folder(dest_datacenter_mob, dest_path)
      @logger.info("Moving disk: #{source_path} to #{dest_path}")
      task = service_content.virtual_disk_manager.move_virtual_disk(
        source_path,
        source_datacenter_mob,
        dest_path,
        dest_datacenter_mob,
        false,
        nil
      )

      wait_for_task(task)
      @logger.info('Moved disk')
    end

    def create_datastore_folder(folder_path, datacenter)
      @service_content.file_manager.make_directory(folder_path, datacenter, true)
    end

    def create_folder(name)
      @service_content.root_folder.create_folder(name)
    end

    def delete_folder(folder)
      task = folder.destroy
      wait_for_task(task)
    end

    def find_by_inventory_path(path)
      full_path = Array(path).join("/")
      @service_content.search_index.find_by_inventory_path(full_path)
    end

    def find_vm_by_ip(ip)
      @service_content.search_index.find_by_ip(nil, ip, true)
    end

    def find_vm_by_name(datacenter, vm_name)
      yield_all_resources_by_name(datacenter, 'VirtualMachine') do |vm_mob, name|
        if name == vm_name
          return vm_mob
        end
      end

      nil
    end

    def find_all_stemcell_replicas(datacenter, stemcell_id)
      matches = []
      yield_all_resources_by_name(datacenter, 'VirtualMachine') do |vm_mob, name|
        if name =~ Regexp.new(stemcell_id)
          matches << vm_mob
        end
      end

      matches
    end

    def find_all_stemcell_replicas_in_datastore(datacenter, stemcell_id, datastore_name)
      matches = []
      yield_all_resources_by_name(datacenter, 'VirtualMachine') do |vm_mob, name|
        if name =~ Regexp.new(stemcell_id)
          vm_datastore = @cloud_searcher.get_property(vm_mob,
            Vim::VirtualMachine, 'datastore', ensure_all: true)
          if vm_datastore.first.name == datastore_name
            matches << vm_mob
          end
        end
      end

      matches
    end

    def wait_for_task(task)
      interval = 1.0
      started = Time.now
      loop do
        properties = @cloud_searcher.get_properties(
          [task],
          Vim::Task,
          ["info.progress", "info.state", "info.result", "info.error"],
          ensure: ["info.state"]
        )[task]

        duration = Time.now - started
        raise "Task exceeded 60 minutes, task properties: #{properties}" if duration > 3600 # 1 hour

        # Update the polling interval based on task progress
        if properties["info.progress"] && properties["info.progress"] > 0
          interval = ((duration * 100 / properties["info.progress"]) - duration) / 5
          if interval < 1
            interval = 1
          elsif interval > 10
            interval = 10
          elsif interval > duration
            interval = duration
          end
        end

        case properties["info.state"]
          when Vim::TaskInfo::State::RUNNING
            sleep(interval)
          when Vim::TaskInfo::State::QUEUED
            sleep(interval)
          when Vim::TaskInfo::State::SUCCESS
            return properties["info.result"]
          when Vim::TaskInfo::State::ERROR
            raise task_exception_for_vim_fault(properties["info.error"])
        end
      end
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
      disk_size_in_mb.nil? ? nil : Resources::PersistentDisk.new(disk_cid, disk_size_in_mb, datastore, disk_folder)
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

      task = service_content.virtual_disk_manager.create_virtual_disk(
        disk_path,
        datacenter_mob,
        disk_spec
      )
      wait_for_task(task)

      Resources::PersistentDisk.new(disk_cid, disk_size_in_mb, datastore, disk_folder)
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
      @logger.debug("Trying to find disk in : #{datastore_path}")
      vm_disk_infos = wait_for_task(datastore.mob.browser.search(datastore_path, search_spec)).file
      return nil if vm_disk_infos.empty?

      vm_disk_infos.first.capacity_kb / 1024
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
      @logger.debug("Trying to find disk in : #{datastore_path}")
      vm_disk_infos = wait_for_task(vm_mob.environment_browser.datastore_browser.search(datastore_path, search_spec)).file
      return false if vm_disk_infos.empty?

      true
    rescue VimSdk::SoapError, FileNotFoundException
      false
    end

    def add_persistent_disk_property_to_vm(vm, disk)
      vm_disk = vm.disk_by_cid(disk.cid)
      disk_device_key = vm_disk.key

      if vm.get_vapp_property_by_key(disk_device_key) != nil
        @logger.debug("Disk property already exists '#{disk.cid}' on vm '#{vm.cid}'")
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
        @logger.debug("Disk property[#{disk_device_key}] does not exist on vm '#{vm.cid}'")
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

    private

    def task_exception_for_vim_fault(fault)
      exceptions_by_fault = {
        VimSdk::Vim::Fault::FileNotFound => FileNotFoundException,
        VimSdk::Vim::Fault::DuplicateName => DuplicateName,
      }
      exceptions_by_fault.fetch(fault.class, TaskException).new(fault.msg)
    end

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

    def create_filter_spec(datacenter, resource_type, property_names)
      # Create a view to list all the resources in the root folder
      container_view = @service_content.view_manager.create_container_view(datacenter.mob, [resource_type], true)

      # Create an object spec to define the beginning of the traversal
      object_spec = VimSdk::Vmodl::Query::PropertyCollector::ObjectSpec.new
      object_spec.obj = container_view
      object_spec.skip = false

      # Create a traversal spec to select all objects in the 'view' of the ContainerView
      vm_traversal_spec = VimSdk::Vmodl::Query::PropertyCollector::TraversalSpec.new
      vm_traversal_spec.name = 'searchTraversalSpec'
      vm_traversal_spec.path = 'view'
      vm_traversal_spec.type = 'ContainerView'
      object_spec.select_set << vm_traversal_spec

      # Specify the properties for retrieval
      property_spec = VimSdk::Vmodl::Query::PropertyCollector::PropertySpec.new
      property_spec.type = resource_type
      property_spec.path_set.concat(property_names)
      property_spec.all = false

      filter_spec = VimSdk::Vmodl::Query::PropertyCollector::FilterSpec.new
      filter_spec.object_set << object_spec
      filter_spec.prop_set << property_spec
      filter_spec
    end

    def yield_all_resources_by_name(datacenter, type)
      raise 'Requires a vSphere object type' if type.nil?
      # Collect all the 'name' attributes of all VMs in the datacenter
      vm_filter_spec = create_filter_spec(datacenter, type, ['name'])
      ro = VimSdk::Vmodl::Query::PropertyCollector::RetrieveOptions.new
      result = @service_content.property_collector.retrieve_properties_ex([vm_filter_spec], ro)

      # Retrieve Properties Ex returns paginated results, so we continue retrieving
      # more pages if the token indicates there are more pages.
      token = "not nil"
      until token.nil?
        result.objects.each do |object_content|
          # Yield the object MOB and its name
          yield object_content.obj, object_content.prop_set.first.val
        end
        token = result.token
        unless token.nil?
          result = @service_content.property_collector.continue_retrieve_properties_ex(token)
        end
      end
    end

    def create_parent_folder(datacenter_mob, disk_path)
      destination_folder = File.dirname(disk_path)
      create_datastore_folder(destination_folder, datacenter_mob)
    end
  end
end
