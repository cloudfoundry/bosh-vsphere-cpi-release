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

  def cpi_options(options = {})
    datastore_pattern = options.fetch(:datastore_pattern, @default_datastore_pattern)
    persistent_datastore_pattern = options.fetch(:persistent_datastore_pattern, @default_datastore_pattern)
    clusters = options.fetch(:clusters, [@default_cluster])
    datacenter_name = options.fetch(:datacenter_name, @datacenter_name)

    {
      'agent' => {
        'ntp' => ['10.80.0.44'],
      },
      'vcenters' => [{
        'host' => fetch_property('BOSH_VSPHERE_CPI_HOST'),
        'user' => fetch_property('BOSH_VSPHERE_CPI_USER'),
        'password' => fetch_property('BOSH_VSPHERE_CPI_PASSWORD'),
        'datacenters' => [{
          'name' => datacenter_name,
          'vm_folder' => fetch_property('BOSH_VSPHERE_CPI_VM_FOLDER'),
          'template_folder' => fetch_property('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER'),
          'disk_path' => fetch_property('BOSH_VSPHERE_CPI_DISK_PATH'),
          'datastore_pattern' => datastore_pattern,
          'persistent_datastore_pattern' => persistent_datastore_pattern,
          'allow_mixed_datastores' => true,
          'clusters' => clusters,
        }]
      }]
    }
  end
end
