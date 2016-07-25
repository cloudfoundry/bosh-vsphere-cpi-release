module LifecycleProperties
  def fetch_properties
    @host = fetch_property('BOSH_VSPHERE_CPI_HOST')
    @user = fetch_property('BOSH_VSPHERE_CPI_USER')
    @password = fetch_property('BOSH_VSPHERE_CPI_PASSWORD')
    @vlan = fetch_property('BOSH_VSPHERE_VLAN')
    @stemcell_path = fetch_property('BOSH_VSPHERE_STEMCELL')

    @second_datastore_within_cluster = fetch_property('BOSH_VSPHERE_CPI_SECOND_DATASTORE')
    @second_resource_pool_within_cluster = fetch_property('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    @datacenter_name = fetch_property('BOSH_VSPHERE_CPI_DATACENTER')
    @vm_folder = fetch_optional_property('BOSH_VSPHERE_CPI_VM_FOLDER', '')
    @template_folder = fetch_optional_property('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER', '')
    @disk_path = fetch_property('BOSH_VSPHERE_CPI_DISK_PATH')

    @datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @persistent_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN')
    @inactive_datastore_pattern = fetch_property('BOSH_VSPHERE_CPI_INACTIVE_DATASTORE_PATTERN')
    @cluster = fetch_property('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = fetch_property('BOSH_VSPHERE_CPI_RESOURCE_POOL')

    @second_cluster = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_resource_pool_name = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')
    @second_cluster_datastore = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE')

    @vsphere_version = fetch_optional_property('BOSH_VSPHERE_VERSION')

    @second_resource_pool_cpi_options = cpi_options(
      clusters: [{@cluster => {'resource_pool' => @second_resource_pool_within_cluster}}]
    )
  end

  def verify_properties
    verify_vsphere_version(cpi_options, @vsphere_version)
    verify_datacenter_exists(cpi_options, 'BOSH_VSPHERE_CPI_DATACENTER')
    verify_vlan(cpi_options, @vlan, 'BOSH_VSPHERE_VLAN')
    verify_user_has_limited_permissions(cpi_options)

    datacenter = VSphereCloud::Cloud.new(cpi_options).datacenter
    verify_cluster(cpi_options, @cluster, 'BOSH_VSPHERE_CPI_CLUSTER')
    verify_resource_pool(cpi_options, @cluster, @resource_pool_name, 'BOSH_VSPHERE_CPI_RESOURCE_POOL')
    verify_cluster(cpi_options, @second_cluster, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    verify_resource_pool(cpi_options, @second_cluster, @second_cluster_resource_pool_name, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')

    verify_resource_pool(@second_resource_pool_cpi_options, @cluster, @second_resource_pool_within_cluster, 'BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    verify_datastore_within_cluster(
      cpi_options,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @datastore_pattern,
      @cluster
    )

    verify_datastore_within_cluster(
      cpi_options,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
      @cluster
    )

    verify_datastore_within_cluster(
      cpi_options,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE',
      @second_datastore_within_cluster,
      @cluster
    )

    verify_non_overlapping_datastores(
      datacenter,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN'
    )

    verify_non_overlapping_datastores(
      datacenter,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @second_datastore_within_cluster,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )

    verify_datastore_within_cluster(
      cpi_options,
      'BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE',
      @second_cluster_datastore,
      @second_cluster
    )

    verify_datastore_pattern_available_to_all_hosts(
      cpi_options,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
    )
  end

  def cpi_options(options = {})
    datastore_pattern = options.fetch(:datastore_pattern, @datastore_pattern)
    persistent_datastore_pattern = options.fetch(:persistent_datastore_pattern, @persistent_datastore_pattern)
    default_clusters = [
      { @cluster => {'resource_pool' => @resource_pool_name} },
      { @second_cluster => {'resource_pool' => @second_cluster_resource_pool_name } },
    ]
    clusters = options.fetch(:clusters, default_clusters)
    datacenter_name = options.fetch(:datacenter_name, @datacenter_name)

    {
      'agent' => {
        'ntp' => ['10.80.0.44'],
      },
      'vcenters' => [{
        'host' => @host,
        'user' => @user,
        'password' => @password,
        'datacenters' => [{
          'name' => datacenter_name,
          'vm_folder' => @vm_folder,
          'template_folder' => @template_folder,
          'disk_path' => @disk_path,
          'datastore_pattern' => datastore_pattern,
          'persistent_datastore_pattern' => persistent_datastore_pattern,
          'allow_mixed_datastores' => true,
          'clusters' => clusters,
        }]
      }]
    }
  end
end
