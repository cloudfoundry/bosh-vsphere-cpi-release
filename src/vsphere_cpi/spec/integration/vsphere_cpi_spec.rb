require 'spec_helper'
require 'open3'
require 'tempfile'
require 'yaml'
require 'fileutils'

describe VSphereCloud::Cloud, external_cpi: true do
  before(:all) do
    @workspace_dir = Dir.mktmpdir('vsphere-cloud-spec')
    @config_path = File.join(@workspace_dir, 'vsphere_cpi_config')
    File.open(@config_path, 'w') { |f| f.write(YAML.dump(config)) }
  end

  after(:all) do
    FileUtils.rm_rf(@workspace_dir)
  end

  def config
    return @config if @config
    datacenter_name          = ENV.fetch('BOSH_VSPHERE_CPI_DATACENTER', 'BOSH_DC')
    cluster                  = ENV.fetch('BOSH_VSPHERE_CPI_CLUSTER', 'BOSH_CL')
    second_cluster           = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER', 'BOSH_CL2')

    host                      = ENV.fetch('BOSH_VSPHERE_CPI_HOST')
    user                      = ENV.fetch('BOSH_VSPHERE_CPI_USER')
    password                  = ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD', '')
    resource_pool_name        = ENV.fetch('BOSH_VSPHERE_CPI_RESOURCE_POOL', 'ACCEPTANCE_RP')
    second_resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL', 'ACCEPTANCE_RP')

    logger = Logger.new(StringIO.new(""))
    client = VSphereCloud::VCenterClient.new(
      vcenter_api_uri: URI.parse("https://#{host}/sdk/vimService"),
      http_client: VSphereCloud::CpiHttpClient.new(logger),
      logger: logger,
    )
    client.login(user, password, 'en')

    vm_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_VM_FOLDER', 'ACCEPTANCE_BOSH_VMs')
    template_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER', 'ACCEPTANCE_BOSH_Templates')
    disk_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_DISK_PATH', 'ACCEPTANCE_BOSH_Disks')

    prepare_tests_folder(client, datacenter_name, vm_folder_name)
    prepare_tests_folder(client, datacenter_name, template_folder_name)
    prepare_tests_folder(client, datacenter_name, disk_folder_name)

    @config = {
      'cloud' => {
        'properties' => {
          'agent' => {
            'ntp' => ['10.80.0.44'],
          },
          'vcenters' => [{
            'host' => host,
            'user' => user,
            'password' => password,
            'datacenters' => [{
              'name' => datacenter_name,
              'vm_folder' => "#{vm_folder_name}/lifecycle_tests",
              'template_folder' => "#{template_folder_name}/lifecycle_tests",
              'disk_path' => "#{disk_folder_name}/lifecycle_tests",
              'datastore_pattern' => ENV.fetch('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', 'jalapeno'),
              'persistent_datastore_pattern' => ENV.fetch('BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN', 'jalapeno'),
              'allow_mixed_datastores' => true,
              'clusters' => [
                {
                  cluster => { 'resource_pool' => resource_pool_name },
                },
                {
                  second_cluster  => { 'resource_pool' => second_resource_pool_name }
                }
              ],
            }]
          }]
        }
      }
    }
  end

  def prepare_tests_folder(client, datacenter_name, parent_folder_name)
    tests_vm_folder = client.find_by_inventory_path([datacenter_name, 'vm', parent_folder_name, 'lifecycle_tests'])
    client.delete_folder(tests_vm_folder) if tests_vm_folder
    parent_folder = client.find_by_inventory_path([datacenter_name, 'vm', parent_folder_name])
    parent_folder.create_folder('lifecycle_tests') if parent_folder
  end

  def run_vsphere_cpi(json)
    bin_path = File.expand_path('../../../bin/vsphere_cpi', __FILE__)
    stdout, stderr, exit_status = Open3.capture3("#{bin_path} #{@config_path}", stdin_data: JSON.dump(json))
    raise "Failure running vsphere cpi #{stderr}" unless exit_status.success?
    stdout
  end

  def external_cpi_response(method, *arguments)
    request = {
      'method' => method,
      'arguments' => arguments,
      'context' => {
        'director_uuid' => '6d06b0cc-2c08-43c5-95be-f1b2dd247e18'
      }
    }

    response = JSON.load(run_vsphere_cpi(request))

    raise 'Failure to parse response' unless response
    response
  end

  # Thin integration test so
  # We have had coverage in the lifecycle_spec
  describe 'getting vms' do
    it 'is successful' do
      resp = external_cpi_response('has_vm', 'non-existent-vm-id')
      expect(resp['error']).to be_nil
      expect(resp['result']).to be(false)
    end
  end

  describe 'logging' do
    let(:temp_dir) { Dir.mktmpdir('vsphere_cpi_test') }
    let(:stemcell_image) { LifecycleHelpers.stemcell_image(ENV.fetch('BOSH_VSPHERE_STEMCELL'), temp_dir) }

    after do
      _ = external_cpi_response('delete_stemcell', @stemcell_id) if @stemcell_id
      FileUtils.rm_rf(temp_dir)
    end

    it 'logs http requests and responses' do
      resp = external_cpi_response('create_stemcell', stemcell_image, nil)
      expect(resp['error']).to be_nil
      expect(resp['result']).to_not be_nil
      @stemcell_id = resp['result']

      expect(resp['log']).to include('200 OK', '<?xml')
    end
  end

  describe 'calculate vm cloud properties' do
    let(:vm_cloud_properties) { {
      'ram' => 1024,
      'cpu' => 2,
      'ephemeral_disk_size' => 2048
    } }

    it 'returns a vSphere-specific set of cloud_properties' do
      resp = external_cpi_response('calculate_vm_cloud_properties', vm_cloud_properties)

      expect(resp['result']).to eq({
        'ram' => 1024,
        'cpu' => 2,
        'disk' => 2048
      })
    end
  end
end
