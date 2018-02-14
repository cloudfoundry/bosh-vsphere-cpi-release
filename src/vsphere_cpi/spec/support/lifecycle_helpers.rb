require 'oga'
require 'bosh/cpi'

module LifecycleHelpers
  PRIVILEGES_INPUT_FILE = 'docs/required_vcenter_privileges.md'

  MISSING_KEY_MESSAGES = {
    'BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN' => 'Please provide a pattern that match datastores that are only accessible by a single host.',
    'BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN' => 'Please provide a pattern that matches at least two datastores each of which is accessible by a single, but unique, host.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER' => 'Please provide a datacenter that is in a sub-folder of the root folder.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN' => 'Please provide a datastore accessible datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER' => 'Please provide a cluster within the datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL' => 'Please provide a resource pool within the cluster referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER.',
    'BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN' => 'Please provide the name of the distributed switch within the datacenter referenced by BOSH_VSPHERE_CPI_NESTED_DATACENTER.',
    'BOSH_VSPHERE_CPI_HOST' => 'Please provide a vSphere hostname to connect to.',
    'BOSH_VSPHERE_CPI_USER' => 'Please provide a vSphere username to authenticate with.',
    'BOSH_VSPHERE_CPI_PASSWORD' => 'Please provide a vSphere password to authenticate with.',
    'BOSH_VSPHERE_VLAN' => 'Please provide a VLAN network name.',
    'BOSH_VSPHERE_STEMCELL' => 'Please provide a path to a stemcell file.',
    'BOSH_VSPHERE_CPI_CLUSTER' => 'Please provide the name of the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER' => 'Please provide the name of the second cluster.',
    'BOSH_VSPHERE_CPI_DATASTORE_PATTERN' => 'Please provide a pattern of a first datastore attached to the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_DATASTORE' => 'Please provide a pattern of a second datastore attached to the first cluster.',
    'BOSH_VSPHERE_CPI_RESOURCE_POOL' => 'Please provide a name of a resource pool within the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL' => 'Please provide a name of the second resource pool within the first cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL' => 'Please provide a name of a resource pool within the second cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE' => 'Please provide a pattern of a second datastore attached to the second cluster.',
    'BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE' => 'Please provide a pattern of a local datastore attached to the second cluster.',
    'BOSH_VSPHERE_CPI_DISK_PATH' => 'Please provide a disk path.',
    'BOSH_VSPHERE_CPI_TEMPLATE_FOLDER' => 'Please provide a template folder.',
    'BOSH_VSPHERE_CPI_VM_FOLDER' => 'Please provide a VM folder.',
    'BOSH_VSPHERE_CPI_DATACENTER' => 'Please provide a datacenter name.',
  }

  def setup_global_config
    vsphere_config = VSphereSpecConfig.new
    vsphere_config.logger = Bosh::Cpi::Logger.new(STDOUT)
    vsphere_config.logger.level = Logger::DEBUG
    vsphere_config.uuid = '123'
    Bosh::Clouds::Config.configure(vsphere_config)
  end

  def fetch_boolean(key, default)
    value = ENV.fetch(key, default)
    value = false if value == "false"
    value
  end

  def fetch_property(key)
    fail "Missing Environment variable #{key}: #{MISSING_KEY_MESSAGES[key]}" unless (ENV.has_key?(key))
    value = ENV[key]
    fail "Environment variable #{key} must not be blank: #{MISSING_KEY_MESSAGES[key]}" if (value =~ /^\s*$/)
    value
  end

  def fetch_integer(key)
    fetch_property(key).to_i
  end

  def fetch_optional_property(property, default = nil)
    ENV[property] || default
  end

  def verify_vsphere_version(cpi, expected_version)
    return if expected_version.nil?
    actual_version = cpi.client.service_content.about.version
    fail("vSphere version #{expected_version} required. Found #{actual_version}.") if expected_version != actual_version
  end

  def verify_datastore_within_cluster(cpi, env_var_name, datastore_pattern, cluster_name)
    cluster = cpi.datacenter.find_cluster(cluster_name)
    datastores = matching_datastores_in_cluster(cluster, datastore_pattern)
    fail("Invalid Environment variable '#{env_var_name}': No datastores found matching /#{datastore_pattern}/. #{MISSING_KEY_MESSAGES[env_var_name]}") if (datastores.empty?)
  end

  def verify_cluster(cpi, cluster_name, env_var_name)
    cpi.datacenter.find_cluster(cluster_name)
  rescue RuntimeError => e
    fail("#{e.message}\n#{env_var_name}: #{MISSING_KEY_MESSAGES[env_var_name]}")
  end
  
  def verify_cluster_free_space(cpi, cluster1_name, cluster2_name)
    cluster1 = cpi.datacenter.find_cluster(cluster1_name)
    cluster2 = cpi.datacenter.find_cluster(cluster2_name)

    cluster1_free_datastore_space = cluster1.accessible_datastores.map { |_, props| props.free_space }.inject(0, :+)
    cluster2_free_datastore_space = cluster2.accessible_datastores.map { |_, props| props.free_space }.inject(0, :+)

    fail("Primary cluster, #{cluster1_name}, must have more free space (#{cluster1_free_datastore_space}) than secondary cluster, #{cluster2_name} (#{cluster2_free_datastore_space})") unless cluster1_free_datastore_space > cluster2_free_datastore_space
  end
  
  def verify_local_disk_infrastructure(cpi, env_var_name, local_datastore_pattern)
    all_matching_datastores = matching_datastores(cpi.datacenter, local_datastore_pattern)
    nonlocal_disk_datastores = all_matching_datastores.select { |_, datastore| datastore.mob.summary.multiple_host_access }
    unless (nonlocal_disk_datastores.empty?)
      fail(
        <<-EOF
      Some datastores found matching `#{env_var_name}`(/#{local_datastore_pattern}/)
      are configured to allow multiple hosts to access them:
      #{nonlocal_disk_datastores}.
      #{MISSING_KEY_MESSAGES[env_var_name]}
      EOF
      )
    end
  end

  def verify_user_has_limited_permissions(cpi)
    root_folder_privileges = build_actual_privileges_list(cpi, cpi.client.service_content.root_folder)

    expected_privileges = build_expected_privileges_list

    disallowed_root_privileges = root_folder_privileges - expected_privileges[:root]
    unless disallowed_root_privileges.empty?
      fail "User must have limited permissions on root folder. Disallowed permissions include: #{disallowed_root_privileges.inspect}"
    end

    cluster_mob = cpi.datacenter.clusters.first.mob
    datacenter_privileges = build_actual_privileges_list(cpi, cluster_mob)

    if datacenter_privileges.sort != expected_privileges[:datacenter].sort
      disallowed_privileges = datacenter_privileges - expected_privileges[:datacenter]
      if disallowed_privileges.empty?
        missing_permissions = expected_privileges[:datacenter] - datacenter_privileges
        fail "User is missing permissions on datacenter `#{cpi.datacenter.name}`. Missing permssions: #{missing_permissions}"
      else
        fail "User must have limited permissions on datacenter `#{cpi.datacenter.name}`. Disallowed permissions include: #{disallowed_privileges.inspect}"
      end
    end
  end

  def verify_datacenter_is_nested(cpi, datacenter_name, env_var_name)
    datacenter_mob = cpi.datacenter.mob
    client = cpi.client
    datacenter_parent = client.cloud_searcher.get_property(datacenter_mob, datacenter_mob.class, 'parent', :ensure_all => true)
    root_folder = client.service_content.root_folder

    fail "Invalid Environment variable '#{env_var_name}': Datacenter '#{datacenter_name}'  is not in subfolder" if root_folder.to_str == datacenter_parent.to_str
  end

  def verify_resource_pool(cpi, cluster_name, resource_pool_name, env_var_name)
    cluster_mob = cpi.datacenter.find_cluster(cluster_name).mob
    resource_pool_mob = cpi.client.cloud_searcher.get_managed_objects(
      VimSdk::Vim::ResourcePool,
      :root => cluster_mob,
      :name => resource_pool_name).first

    if resource_pool_mob.nil?
      fail "Invalid Environment variable '#{env_var_name}': Expected to find resource pool '#{resource_pool_name}' in cluster '#{cluster_name}'"
    end
  end

  def stemcell_image(stemcell_path, destination_dir)
    raise "Invalid Environment variable 'BOSH_VSPHERE_STEMCELL': File not found: '#{stemcell_path}'" unless File.exists?(stemcell_path)
    output = `tar -C #{destination_dir} -xzf #{stemcell_path} 2>&1`
    fail "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
    "#{destination_dir}/image"
  end

  def verify_vlan(cpi, vlan, env_var_name)
    datacenter_name = cpi.datacenter.name
    network = cpi.client.find_network(cpi.datacenter, vlan)
    fail "Invalid Environment variable '#{env_var_name}': No network named '#{vlan}' found in datacenter named '#{datacenter_name}'" if network.nil?
  end

  def get_network_spec
  network_spec = {
    'static' => {
      'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
      'netmask' => '255.255.254.0',
      'cloud_properties' => {'name' => @vlan},
      'default' => ['dns', 'gateway'],
      'dns' => ['169.254.1.2'],
      'gateway' => '169.254.1.3'
      }
    }
  end

  def verify_datacenter_exists(cpi, env_var_name)
    cpi.datacenter.mob
  rescue => e
    fail "Invalid Environment variable '#{env_var_name}': #{e.message}"
  end

  def verify_non_overlapping_datastores(cpi_options, pattern_1, env_var_name_1, pattern_2, env_var_name_2)
    cpi = VSphereCloud::Cloud.new(cpi_options)
    datacenter = cpi.datacenter
    datastore_ids_1 = matching_datastores(datacenter, pattern_1).map { |k, v| [k, v.mob.to_s] }
    datastore_ids_2 = matching_datastores(datacenter, pattern_2).map { |k, v| [k, v.mob.to_s] }
    overlapping_datastore_ids = datastore_ids_1 & datastore_ids_2
    if (!overlapping_datastore_ids.empty?)
      fail("There were overlapping datastores (#{overlapping_datastore_ids.map(&:first).inspect}) found matching /#{pattern_1}/ and /#{pattern_2}/ which came from Environment variables '#{env_var_name_1}' and '#{env_var_name_2}' respectively.")
    end
  end

  def verify_datastore_pattern_available_to_all_hosts(cpi, env_var_name, datastore_pattern, cluster_name)
    datastore_pattern_regex = Regexp.new(datastore_pattern)
    cluster = cpi.datacenter.find_cluster(cluster_name)
    if cluster.nil?
      cluster_names = cpi.datacenter.clusters.map {|cluster| cluster.name}
      fail "Failed to find cluster '#{cluster_name}' in known clusters: #{cluster_names.join(', ')}"
    end

    cluster.mob.host.each do |host_mob|
      datastore_names = host_mob.datastore.map(&:name)
      fail("host: '#{host_mob.name}' does not have any datastores matching pattern /#{datastore_pattern}/. Found datastores are #{datastore_names.inspect}. The datasore pattern came from the environment varible:'#{env_var_name}'. #{MISSING_KEY_MESSAGES[env_var_name]}") unless datastore_names.any? { |name| name =~ datastore_pattern_regex }
    end
  end

  def verify_vsan_datastore(cpi_options, datastore_name, env_var_name)
    cpi = VSphereCloud::Cloud.new(cpi_options)
    unless is_vsan?(cpi, datastore_name)
      fail("datastore: '#{datastore_name}' is not of type 'vsan'. The datasore pattern came from the environment variable:'#{env_var_name}'.")
    end
  end

  def verify_disk_is_in_datastores(cpi, disk_id, datastores)
    expect(is_disk_in_datastores(cpi, disk_id, datastores)).to eq(true), "Expected disk '#{disk_id}' to be in datastores '#{datastores.join(', ')}' but was not"
  end

  def is_vsan?(cpi, datastore_name)
    datastore_mob = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
    datastore_mob.summary.type == "vsan"
  end

  def matching_datastores(datacenter, pattern)
    clusters = datacenter.clusters
    clusters.inject({}) do |acc, cluster|
      acc.merge!(matching_datastores_in_cluster(cluster, pattern))
    end
  end

  def matching_datastores_in_cluster(cluster, pattern)
    cluster.accessible_datastores.select { |ds_name| ds_name =~ /#{pattern}/ }
  end

  class VMWareToolsNotFound < StandardError;
  end

  def block_on_vmware_tools(cpi, vm_name)
    # wait for vsphere tools to be detected by vCenter :(

    start_time = Time.now
    cpi.logger.info("Waiting for VMWare Tools on the VM...")
    Bosh::Common.retryable(tries: 20, on: VMWareToolsNotFound) do
      wait_for_vmware_tools(cpi, vm_name)
    end
    cpi.logger.info("Finished waiting for VMWare Tools. Took #{Time.now - start_time} seconds.")
  end

  def wait_for_vmware_tools(cpi, vm_name)
    vm_mob = cpi.vm_provider.find(vm_name).mob
    raise VMWareToolsNotFound if vm_mob.guest.ip_address.nil?
    nics = vm_mob.guest.net.map { |net| net.ip_config }
    ip_available = nics.all? do |nic|
      nic.ip_address.all? { |ip_config| ip_config.state == 'preferred' }
    end
    raise VMWareToolsNotFound unless ip_available
    true
  end

  def simple_vm_lifecycle(cpi, network_name, vm_type = {}, network_spec = {})
    default_network_spec = {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => network_name },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }

    default_vm_type = {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }

    vm_id = cpi.create_vm(
      'agent-007',
      @stemcell_id,
      default_vm_type.merge(vm_type),
      default_network_spec.merge(network_spec)
    )

    expect(vm_id).to_not be_nil
    expect(cpi.has_vm?(vm_id)).to be(true)

    yield vm_id if block_given?
  ensure
    delete_vm(cpi, vm_id)
  end

  def vm_lifecycle(cpi, disk_locality, vm_type, network_spec, stemcell_id, env = {'key' => 'value'})
    vm_id = cpi.create_vm(
      'agent-007',
      stemcell_id,
      vm_type,
      network_spec,
      disk_locality,
      env
    )

    expect(vm_id).to_not be_nil
    expect(cpi.has_vm?(vm_id)).to be(true)

    yield vm_id if block_given?

    metadata = {
      deployment: 'deployment',
      job: 'cpi_spec',
      index: '0'
    }
    cpi.set_vm_metadata(vm_id, metadata)

    disk_id = cpi.create_disk(2048, {}, vm_id)
    expect(disk_id).to_not be_nil

    cpi.attach_disk(vm_id, disk_id)
    expect(cpi.has_disk?(disk_id)).to be(true)

    metadata[:bosh_data] = 'bosh data'
    metadata[:instance_id] = 'instance'
    metadata[:agent_id] = 'agent'
    metadata[:director_name] = 'Director'
    metadata[:director_uuid] = '6d06b0cc-2c08-43c5-95be-f1b2dd247e18'

    expect {
      cpi.snapshot_disk(disk_id, metadata)
    }.to raise_error Bosh::Clouds::NotImplemented

    expect {
      cpi.delete_snapshot('some snapshot_id')
    }.to raise_error Bosh::Clouds::NotImplemented
  ensure
    detach_disk(cpi, vm_id, disk_id)
    delete_vm(cpi, vm_id)
    delete_disk(cpi, disk_id)
  end

  def create_vm_with_cpi(cpi, stemcell_id)
    cpi.create_vm(
      'agent-007',
      stemcell_id,
      vm_type,
      network_spec,
      [],
      {}
    )
  end

  def create_vm_with_vm_type(cpi, vm_type, stemcell_id)
    cpi.create_vm(
      'agent-007',
      stemcell_id,
      vm_type,
      network_spec,
      [],
      {'key' => 'value'}
    )
  end


  def delete_vm(cpi, vm_id)
    begin
      cpi.delete_vm(vm_id) if vm_id
    rescue Bosh::Clouds::VMNotFound => e
      cpi.logger.info("Failure: 'delete_vm' for VM ID: #{vm_id.inspect}. Error: #{e.inspect}")
    end
  end

  def detach_disk(cpi, vm_id, disk_id)
    begin
      cpi.detach_disk(vm_id, disk_id) if vm_id && disk_id
    rescue Bosh::Clouds::DiskNotAttached, Bosh::Clouds::VMNotFound, Bosh::Clouds::DiskNotFound => e
      cpi.logger.info("Failure: 'detach_disk' for VM ID: #{vm_id.inspect} and Disk ID: #{disk_id.inspect}. Error: #{e.inspect}")
    end
  end

  def delete_disk(cpi, disk_id)
    begin
      cpi.delete_disk(disk_id) if disk_id
    rescue Bosh::Clouds::DiskNotFound => e
      cpi.logger.info("Failure: 'delete_disk' for Disk ID: #{disk_id.inspect}. Error: #{e.inspect}")
    end
  end

  def upload_stemcell(cpi)
    stemcell_id = nil
    Dir.mktmpdir do |temp_dir|
      stemcell_image = stemcell_image(@stemcell_path, temp_dir)
      stemcell_id = cpi.create_stemcell(stemcell_image, nil)
    end
    stemcell_id
  end

  def delete_stemcell(cpi, stemcell_id)
    cpi.delete_stemcell(stemcell_id) if stemcell_id
  end

  def delete_only_this_stemcell(stemcell_name, cpi)
    stemcell_vm = cpi.client.find_vm_by_name(cpi.datacenter.mob, stemcell_name)
    cpi.logger.info("Found: #{stemcell_name}")
    cpi.logger.info("Deleting: #{stemcell_name}")
    cpi.client.delete_vm(stemcell_vm)
    cpi.logger.info("Deleted: #{stemcell_name}")
  end

  def half_pattern_datastore_enter_maintenance_mode(cpi, cluster_name, pattern)
    @ds_maintenance_tasks = []
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    ds_mob_array = cluster.datastore
    ds_mob_array.keep_if do |ds|
      ds.name =~ Regexp.new(pattern)
    end
    half_ds_mob_array = ds_mob_array[0, ds_mob_array.length/2]
    half_ds_mob_array.each do |ds|
      result = ds.enter_maintenance_mode
      @ds_maintenance_tasks << {task: result.task, datastore: ds}
      sleep 5
    end
  end

  def all_pattern_datastore_enter_maintenance_mode(cpi, cluster_name, pattern)
    @ds_maintenance_tasks = []
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    ds_mob_array = cluster.datastore
    ds_mob_array.keep_if do |ds|
      ds.name =~ Regexp.new(pattern)
    end
    ds_mob_array.each do |ds|
      result = ds.enter_maintenance_mode
      @ds_maintenance_tasks << {task: result.task, datastore: ds}
      sleep 5
    end
  end

  def all_pattern_datastore_exit_maintenance_mode()
    @ds_maintenance_tasks.each do |task_ds_tuple|
      ds = task_ds_tuple[:datastore]
      task = task_ds_tuple[:task]
      if task.info.state == "success"
        ds.exit_maintenance_mode
      else
        begin
          task.cancel
        rescue
          raise "Unable to cancel the task in state #{task.info.state} for the ds #{ds.name}"
        end
      end
    end
  end

  def datastores_accessible_from_cluster(cpi, cluster_name)
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    cluster.datastore.map(&:name)
  end

  def datastore_names_matching_pattern(cpi, cluster_name, pattern)
    all_datastore_names = datastores_accessible_from_cluster(cpi, cluster_name)
    all_datastore_names.select { |name| name =~ Regexp.new(pattern) }
  end

  def turn_maintenance_on_for_half_hosts(cpi, cluster_name)
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    half_host_mob_array = cluster.host[0, cluster.host.length/2]
    half_host_mob_array.each { |host_mob| host_mob.enter_maintenance_mode(0, true, nil) }
    # Sleep for 10 seconds to allow hosts to enter maintenance mode
    sleep 10
  end

  def turn_maintenance_off_for_all_hosts(cpi, cluster_name)
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    host_mob_array = cluster.host
    host_mob_array.each { |host_mob| host_mob.exit_maintenance_mode(0) }
    # Sleep for 10 seconds to allow hosts to exit maintenance mode
    sleep 10
  end

  def turn_maintenance_on_for_all_hosts(cpi, cluster_name)
    cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    host_mob_array = cluster.host
    host_mob_array.each { |host_mob| host_mob.enter_maintenance_mode(0, true, nil) }
    # Sleep for 10 seconds to allow hosts to enter maintenance mode
    sleep 10
  end


  private

  def is_disk_in_datastores(cpi, disk_id, accessible_datastores)
    disk = cpi.datacenter.find_disk(VSphereCloud::DirectorDiskCID.new(disk_id))
    accessible_datastores.include?(disk.datastore.name)
  end

  def build_expected_privileges_list
    handle = File.open(File.join(project_root, PRIVILEGES_INPUT_FILE))
    document = Oga.parse_html(handle)

    expected_permissions = {
      root: [],
      datacenter: [],
    }

    document.css('table#vcenter-root-privileges td:nth-child(2)').each do |td|
      expected_permissions[:root] << td.text
    end
    document.css('table#vcenter-datacenter-privileges td:nth-child(2)').each do |td|
      expected_permissions[:datacenter] << td.text
    end

    expected_permissions
  end

  def build_actual_privileges_list(cpi, entity)
    all_privileges = cpi.client.service_content.authorization_manager.privilege_list.map(&:priv_id)
    current_session_id = cpi.client.service_content.session_manager.current_session.key
    privileges_response =
      cpi.client.service_content.authorization_manager.has_privilege_on_entity(entity, current_session_id, all_privileges)
    Hash[all_privileges.zip(privileges_response)].select { |_, privelege| privelege }.keys
  end

  def project_root
    File.join(File.dirname(__FILE__), '../../../..')
  end
end
