require 'integration/spec_helper'
require 'open3'
require 'tempfile'
require 'yaml'
require 'fileutils'

module VSphereCloud
  describe Cloud, external_cpi: true do
    before(:each) do
      @workspace_dir = Dir.mktmpdir('vsphere-cloud-spec')
      @config_path = File.join(@workspace_dir, 'vsphere_cpi_config')
      File.open(@config_path, 'w') { |f| f.write(YAML.dump(cloud_properties)) }
    end

    after(:each) do
      FileUtils.rm_rf(@workspace_dir)
    end

    let(:password) do
      ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD')
    end

    let(:cloud_properties) do
      {
          'cloud' => {
              'properties' => {
                  'agent' => {
                      'ntp' => ['10.80.0.44'],
                  },
                  'vcenters' => [context]
              }
          }
      }
    end

    let(:context) do
      datacenter_name = ENV.fetch('BOSH_VSPHERE_CPI_DATACENTER')
      cluster = ENV.fetch('BOSH_VSPHERE_CPI_CLUSTER')
      second_cluster = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER')

      host = ENV.fetch('BOSH_VSPHERE_CPI_HOST')
      user = ENV.fetch('BOSH_VSPHERE_CPI_USER')
      resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_RESOURCE_POOL')
      second_resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')

      ephemeral_datastore_pattern = ENV.fetch('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
      persistent_datastore_pattern = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_DATASTORE')

      logger = Logger.new(StringIO.new(""))
      client = VSphereCloud::VCenterClient.new(
          vcenter_api_uri: URI.parse("https://#{host}/sdk/vimService"),
          http_client: VSphereCloud::CpiHttpClient.new(logger),
          logger: logger,
      )
      client.login(user, password, 'en')

      vm_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_VM_FOLDER')
      template_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER')
      disk_folder_name = ENV.fetch('BOSH_VSPHERE_CPI_DISK_PATH')

      prepare_tests_folder(client, datacenter_name, vm_folder_name)
      prepare_tests_folder(client, datacenter_name, template_folder_name)
      prepare_tests_folder(client, datacenter_name, disk_folder_name)

      {
          'host' => host,
          'user' => user,
          'password' => password,
          'default_disk_type' => 'preallocated',
          'http_logging' => true,
          'datacenters' => [{
                                'name' => datacenter_name,
                                'vm_folder' => "#{vm_folder_name}/lifecycle_tests",
                                'template_folder' => "#{template_folder_name}/lifecycle_tests",
                                'disk_path' => "#{disk_folder_name}/lifecycle_tests",
                                'datastore_pattern' => ephemeral_datastore_pattern,
                                'persistent_datastore_pattern' => persistent_datastore_pattern,
                                'allow_mixed_datastores' => true,
                                'clusters' => [
                                    {
                                        cluster => {'resource_pool' => resource_pool_name},
                                    },
                                    {
                                        second_cluster => {'resource_pool' => second_resource_pool_name}
                                    }
                                ],
                            }]
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

    def external_cpi_response(method, context, *arguments)
      context = {'director_uuid' => '6d06b0cc-2c08-43c5-95be-f1b2dd247e18'}.merge(context)
      request = {
          'method' => method,
          'arguments' => arguments,
          'context' => context,
      }

      response = JSON.load(run_vsphere_cpi(request))

      raise 'Failure to parse response' unless response
      response
    end

    # Thin integration test so
    # We have had coverage in the lifecycle_spec
    describe 'getting vms' do
      it 'is successful' do
        resp = external_cpi_response('has_vm', {}, 'non-existent-vm-id')
        expect(resp['error']).to be_nil
        expect(resp['result']).to be(false)
      end

      context 'when given cpi config in the context argument' do
        let(:cloud_properties) do
          {
              'cloud' => {
                  'properties' => {
                      'agent' => {
                          'ntp' => ['10.80.0.44'],
                      },
                      'vcenters' => []
                  }
              }
          }
        end

        it 'merges context into cloud properties and is successful' do
          resp = external_cpi_response('has_vm', context, 'non-existent-vm-id')
          expect(resp['error']).to be_nil
          expect(resp['result']).to be(false)
        end


      end
    end

    describe 'logging' do
      let(:temp_dir) { Dir.mktmpdir('vsphere_cpi_test') }
      let(:stemcell_img) { stemcell_image(ENV.fetch('BOSH_VSPHERE_STEMCELL'), temp_dir) }

      after do
        _ = external_cpi_response('delete_stemcell', {}, @stemcell_id) if @stemcell_id
        FileUtils.rm_rf(temp_dir)
      end

      it 'returns http requests and responses in the `log` field' do
        resp = external_cpi_response('create_stemcell', {}, stemcell_img, nil)
        expect(resp['error']).to be_nil
        expect(resp['result']).to_not be_nil
        @stemcell_id = resp['result']

        expect(resp['log']).to include('200 OK', '<?xml')
      end
    end

    describe 'calculate vm cloud properties' do
      let(:vm_cloud_properties) { {
          'ram' => 512,
          'cpu' => 2,
          'ephemeral_disk_size' => 2048
      } }

      it 'returns a vSphere-specific set of cloud_properties' do
        resp = external_cpi_response('calculate_vm_cloud_properties', {}, vm_cloud_properties)

        expect(resp['result']).to eq({
                                         'ram' => 512,
                                         'cpu' => 2,
                                         'disk' => 2048
                                     })
      end
    end
  end
end
