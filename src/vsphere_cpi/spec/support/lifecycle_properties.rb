module LifecycleProperties
  def fetch_global_properties
    @vlan = fetch_property('BOSH_VSPHERE_VLAN')

    @stemcell_path = fetch_property('BOSH_VSPHERE_STEMCELL')

    @vsphere_version = fetch_optional_property('BOSH_VSPHERE_VERSION')

    @datacenter_name = fetch_property('BOSH_VSPHERE_CPI_DATACENTER')

    @default_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @default_cluster = fetch_property('BOSH_VSPHERE_CPI_CLUSTER')

    verify_vsphere_version(cpi_options, @vsphere_version)
    verify_datacenter_exists(cpi_options, 'BOSH_VSPHERE_CPI_DATACENTER')
    verify_vlan(cpi_options, @vlan, 'BOSH_VSPHERE_VLAN')
    verify_user_has_limited_permissions(cpi_options)

    verify_cluster(cpi_options, @default_cluster, 'BOSH_VSPHERE_CPI_CLUSTER')

    verify_datastore_within_cluster(
      cpi_options,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @default_datastore_pattern,
      @default_cluster
    )
  end

  def fetch_and_verify_datastore(env_var, cluster_name)
    datastore = fetch_property(env_var)
    verify_datastore_within_cluster(
      cpi_options,
      env_var,
      datastore,
      cluster_name
    )
    verify_datastore_pattern_available_to_all_hosts(
      cpi_options,
      env_var,
      datastore,
      cluster_name
    )
    datastore
  end

  def fetch_and_verify_cluster(env_var)
    cluster = fetch_property(env_var)
    verify_cluster(cpi_options, cluster, env_var)
    cluster
  end

  def fetch_and_verify_resource_pool(env_var, cluster_name)
    resource_pool_name = fetch_property(env_var)
    verify_resource_pool(cpi_options, cluster_name, resource_pool_name, env_var)
    resource_pool_name
  end

  def fetch_and_verify_datacenter(env_var)
    datacenter_name = fetch_property(env_var)
    verify_datacenter_exists(cpi_options, datacenter_name)
    datacenter_name
  end

  def cpi_options(overrides = {})
    overrides = stringify_keys(overrides)

    datacenter_overrides = overrides.delete('datacenters') || []
    datacenter_config = deep_merge({
      'name' => @datacenter_name,
      'vm_folder' => fetch_property('BOSH_VSPHERE_CPI_VM_FOLDER'),
      'template_folder' => fetch_property('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER'),
      'disk_path' => fetch_property('BOSH_VSPHERE_CPI_DISK_PATH'),
      'datastore_pattern' => @default_datastore_pattern,
      'persistent_datastore_pattern' => @default_datastore_pattern,
      'allow_mixed_datastores' => true,
      'clusters' => [@default_cluster],
    }, datacenter_overrides.first || {})

    vcenter_options = deep_merge({
      'host' => fetch_property('BOSH_VSPHERE_CPI_HOST'),
      'user' => fetch_property('BOSH_VSPHERE_CPI_USER'),
      'password' => fetch_property('BOSH_VSPHERE_CPI_PASSWORD'),
      'datacenters' => [datacenter_config]
    }, overrides)

    {
      'agent' => {
        'ntp' => ['10.80.0.44'],
      },
      'vcenters' => [vcenter_options]
    }
  end

  def deep_merge(first, second)
    # adapted from http://stackoverflow.com/a/30225093
    # merge nested hashes, arrays will override each other rather than merging
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    first.merge(second, &merger)
  end

  def stringify_keys(hash)
    new_hash = {}
    hash.each do |key,value|
      new_value = if value.is_a?(Hash)
        stringify_keys(value)
      elsif value.is_a?(Array)
        value.map { |v| v.is_a?(Hash) ? stringify_keys(v) : v }
      else
        value
      end
      new_hash[key.to_s] = new_value
    end
    new_hash
  end
end
