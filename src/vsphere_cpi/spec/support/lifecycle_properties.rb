module LifecycleProperties
  def fetch_properties(helper)
    @host = helper.fetch_property('BOSH_VSPHERE_CPI_HOST')
    @user = helper.fetch_property('BOSH_VSPHERE_CPI_USER')
    @password = helper.fetch_property('BOSH_VSPHERE_CPI_PASSWORD')
    @vlan = helper.fetch_property('BOSH_VSPHERE_VLAN')
    @stemcell_path = helper.fetch_property('BOSH_VSPHERE_STEMCELL')

    @second_datastore_within_cluster = helper.fetch_property('BOSH_VSPHERE_CPI_SECOND_DATASTORE')
    @second_resource_pool_within_cluster = helper.fetch_property('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    @datacenter_name = helper.fetch_property('BOSH_VSPHERE_CPI_DATACENTER')
    @vm_folder = helper.fetch_optional_property('BOSH_VSPHERE_CPI_VM_FOLDER', '')
    @template_folder = helper.fetch_optional_property('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER', '')
    @disk_path = helper.fetch_property('BOSH_VSPHERE_CPI_DISK_PATH')

    @datastore_pattern = helper.fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @local_datastore_pattern = helper.fetch_property('BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN')
    @persistent_datastore_pattern = helper.fetch_property('BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN')
    @cluster = helper.fetch_property('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = helper.fetch_property('BOSH_VSPHERE_CPI_RESOURCE_POOL')

    @second_cluster = helper.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_resource_pool_name = helper.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')
    @second_cluster_datastore = helper.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE')

    nested_datacenter_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    nested_datacenter_datastore_pattern = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    nested_datacenter_cluster_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    nested_datacenter_resource_pool_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL')
    @nested_datacenter_vlan = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')

    @vsphere_version = helper.fetch_optional_property('BOSH_VSPHERE_VERSION')

    @nested_datacenter_cpi_options = cpi_options(
      datacenter_name: nested_datacenter_name,
      datastore_pattern: nested_datacenter_datastore_pattern,
      persistent_datastore_pattern: nested_datacenter_datastore_pattern,
      clusters: [{nested_datacenter_cluster_name => {'resource_pool' => nested_datacenter_resource_pool_name}}]
    )

    @local_disk_cpi_options = cpi_options(
      datastore_pattern: @local_datastore_pattern,
      persistent_datastore_pattern: @persistent_datastore_pattern,
      clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
    )

    @second_resource_pool_cpi_options = cpi_options(
      clusters: [{@cluster => {'resource_pool' => @second_resource_pool_within_cluster}}]
    )
  end

  def verify_properties(helper)
    helper.verify_vsphere_version(cpi_options, @vsphere_version)
    helper.verify_datacenter_exists(cpi_options, 'BOSH_VSPHERE_CPI_DATACENTER')
    helper.verify_vlan(cpi_options, @vlan, 'BOSH_VSPHERE_VLAN')
    helper.verify_user_has_limited_permissions(cpi_options)

    datacenter = described_class.new(cpi_options).datacenter
    helper.verify_cluster(datacenter, @cluster, 'BOSH_VSPHERE_CPI_CLUSTER')
    helper.verify_resource_pool(datacenter.find_cluster(@cluster), @resource_pool_name, 'BOSH_VSPHERE_CPI_RESOURCE_POOL')
    helper.verify_cluster(datacenter, @second_cluster, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    helper.verify_resource_pool(datacenter.find_cluster(@second_cluster), @second_cluster_resource_pool_name, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')

    second_resource_pool_datacenter = described_class.new(@second_resource_pool_cpi_options).datacenter
    helper.verify_resource_pool(second_resource_pool_datacenter.find_cluster(@cluster), @second_resource_pool_within_cluster, 'BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    helper.verify_datastore_within_cluster(
      described_class.new(@local_disk_cpi_options).datacenter,
      'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN',
      @local_datastore_pattern,
      @cluster
    )

    nested_datacenter_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    nested_datacenter_datastore_pattern = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    nested_datacenter_cluster_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    nested_datacenter_resource_pool_name = helper.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL')
    helper.verify_local_disk_infrastructure(@local_disk_cpi_options, 'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN')
    helper.verify_datacenter_exists(@nested_datacenter_cpi_options, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    helper.verify_datacenter_is_nested(@nested_datacenter_cpi_options, nested_datacenter_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    nested_datacenter = described_class.new(@nested_datacenter_cpi_options).datacenter
    helper.verify_cluster(nested_datacenter, nested_datacenter_cluster_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    helper.verify_datastore_within_cluster(
      nested_datacenter,
      'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN',
      nested_datacenter_datastore_pattern,
      nested_datacenter_cluster_name
    )

    helper.verify_resource_pool(nested_datacenter.find_cluster(nested_datacenter_cluster_name), nested_datacenter_resource_pool_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    helper.verify_vlan(@nested_datacenter_cpi_options, @nested_datacenter_vlan, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')

    helper.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @datastore_pattern,
      @cluster
    )

    helper.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
      @cluster
    )

    helper.verify_datastore_within_cluster(
      second_datastore_cpi.datacenter,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE',
      @second_datastore_within_cluster,
      @cluster
    )

    cpi_instance = described_class.new(cpi_options)
    helper.verify_non_overlapping_datastores(
      cpi_instance,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      cpi_instance,
      @persistent_datastore_pattern,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN'
    )

    helper.verify_non_overlapping_datastores(
      described_class.new(cpi_options),
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      second_datastore_cpi,
      @second_datastore_within_cluster,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )

    helper.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE',
      @second_cluster_datastore,
      @second_cluster
    )

    helper.verify_datastore_pattern_available_to_all_hosts(
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

  def second_datastore_cpi
    options = cpi_options(
      datastore_pattern: @second_datastore_within_cluster,
      persistent_datastore_pattern: @second_datastore_within_cluster
    )
    described_class.new(options)
  end
end
