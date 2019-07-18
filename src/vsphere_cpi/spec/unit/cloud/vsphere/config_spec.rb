require 'spec_helper'

module VSphereCloud
  describe Config do
    subject(:config) { described_class.new(config_hash) }
    let(:agent_config) { { 'fake-agent' => 'configuration' } }
    let(:user) { 'foo-user' }
    let(:password) { 'bar-password' }
    let(:host) { 'some-host' }
    let(:datacenter_name) { 'fancy-datacenter' }
    let(:vm_folder) { 'vm-folder' }
    let(:template_folder) { 'template-folder' }
    let(:disk_path) { '/a/path/on/disk' }
    let(:datastore_pattern) { 'fancy-datastore*' }
    let(:persistent_datastore_pattern) { 'long-lasting-datastore*' }
    let(:cluster_name) { 'grubby-cluster' }
    let(:cluster_name_witout_resource_pool) { 'shiny-cluster' }
    let(:resource_pool) { 'wading-pool' }
    let(:default_disk_type) { 'preallocated' }
    let(:datacenters) do
      [{
         'name' => datacenter_name,
         'vm_folder' => vm_folder,
         'template_folder' => template_folder,
         'disk_path' => disk_path,
         'datastore_pattern' => datastore_pattern,
         'persistent_datastore_pattern' => persistent_datastore_pattern,
         'clusters' => [
           cluster_name => {'resource_pool' => resource_pool},
           cluster_name_witout_resource_pool => {},
         ],
       }]
    end
    let(:service_content) { double(:service_content) }
    let(:nsx_url) { 'fake-nsx-url' }
    let(:nsx_user) { 'fake-nsx-user' }
    let(:nsx_password) { 'fake-nsx-password' }
    let(:vm_storage_policy_name)  { 'VM Storage Policy' }
    before do
      allow(VimSdk::Vim::ServiceInstance).to receive(:new).
        and_return(double(:service_instance, content: service_content))
    end

    let(:config_hash) do
      {
        'agent' => agent_config,
        'vcenters' => [
          'host' => host,
          'user' => user,
          'password' => password,
          'default_disk_type' => default_disk_type,
          'vm_storage_policy_name' => vm_storage_policy_name,
          'enable_human_readable_name' => false,
          'datacenters' => datacenters,
          'nsx' => {
            'address' => nsx_url,
            'user' => nsx_user,
            'password' => nsx_password,
          },
        ],
        'soap_log' => 'fake-soap-log'
      }
    end

    let(:logger) { instance_double('Logger') }
    before { allow(Bosh::Clouds::Config).to receive(:logger).and_return(logger) }

    describe '.build' do
      context 'when the config is valid' do
        it 'returns a Config' do
          config = described_class.build(config_hash)
          expect(config).to be_a(VSphereCloud::Config)
          expect(config.agent).to eq(agent_config)
        end
      end

      context 'when the config is invalid' do
        before { config_hash['vcenters'] = [{ 'one' => 'vcenter' }, { 'two' => 'vcenter' }] }
        it 'raises' do
          expect do
            described_class.build(config_hash)
          end.to raise_error(RuntimeError, 'vSphere CPI only supports a single vCenter')
        end
      end
    end

    describe '#validate' do
      context 'when the config is valid' do
        it 'does not raise' do
          expect { config.validate }.to_not raise_exception
        end
      end

      context 'when already validated' do
        before { config.validate }

        it 'does nothing' do
          expect(config).to_not receive(:validate_schema)
        end
      end

      context 'when multiple vcenters are passed in config' do
        before { config_hash['vcenters'] = [{ 'one' => 'vcenter' }, { 'two' => 'vcenter' }] }

        it 'raises' do
          expect do
            config.validate
          end.to raise_error(RuntimeError, 'vSphere CPI only supports a single vCenter')
        end
      end

      context 'when multiple datacenters are passed in config' do
        before { config_hash.merge!({ 'vcenters' => [{ 'datacenters' => [{ 'name' => 'datacenter' }, { 'name' => 'datacenter2' }] }] }) }

        it 'raises' do
          expect do
            config.validate
          end.to raise_error(RuntimeError, 'vSphere CPI only supports a single datacenter')
        end
      end

      context 'when the configuration hash does not match the schema' do
        before { config_hash.delete('agent') }

        it 'raises' do
          expect do
            config.validate
          end.to raise_error(Membrane::SchemaValidationError)
        end
      end

      context 'when the configuration hash does not match the schema' do
        before { config_hash.delete('agent') }

        it 'raises' do
          expect do
            config.validate
          end.to raise_error(Membrane::SchemaValidationError)
        end
      end

      context 'when the vcenter_default_disk_type is missing' do
        let(:default_disk_type) { nil }
        it 'raises an error' do
          expect do
            config.validate
          end.to raise_error(RuntimeError, /default_disk_type/)
        end
      end

      context 'when the vcenter_default_disk_type is an invalid type' do
        let(:default_disk_type) { 'invalid-type' }
        it 'returns value from config' do
          expect do
            config.validate
          end.to raise_error(RuntimeError, /invalid-type/)
        end
      end

      context 'when the vcenter_default_disk_type is "thin"' do
        let(:default_disk_type) { 'thin' }
        it 'returns value from config' do
          expect do
            config.validate
          end.to_not raise_error
        end
      end

      context 'when the vcenter_default_disk_type is "preallocated"' do
        let(:default_disk_type) { 'preallocated' }
        it 'returns value from config' do
          expect do
            config.validate
          end.to_not raise_error
        end
      end

      context 'when a valid nsxt is passed in config' do
        before do
          config_hash.merge! 'nsxt' => {
            'host' => 'fake-host',
            'username' => 'fake-username',
            'password' => 'fake-password',
            'certificate' => nil,
            'private_key' => nil
          }
        end

        it 'returns value from config' do
          expect do
            config.validate
          end.to_not raise_error
        end
      end

      context 'when a valid nsxt with remote auth is passed in config' do
        before do
          config_hash.merge! 'nsxt' => {
            'host' => 'fake-host',
            'username' => 'fake-username',
            'password' => 'fake-password',
            'remote_auth' => true,
            'certificate' => nil,
            'private_key' => nil
          }
        end

        it 'returns value from config' do
          expect do
            config.validate
          end.to_not raise_error
        end
      end

      context 'when a valid nsxt with cert auth is passed in config' do
        before do
          config_hash.merge! 'nsxt' => {
              'host' => 'fake-host',
              'username' => nil,
              'password' => nil,
              'certificate' => 'cert-path',
              'private_key' => 'key-path'
          }
        end

        it 'returns value from config' do
          expect do
            config.validate
          end.to_not raise_error
        end
      end

      context 'when an invalid nsxt is passed in config' do
        before do
          config_hash.merge! 'nsxt' => {
            'host' => 'fake-host',
            'username' => 'fake-username',
            'password' => nil,
          }
        end

        it 'raises a schema validation error' do
          expect do
            config.validate
          end.to raise_error(Membrane::SchemaValidationError)
        end
      end

      context 'when an invalid nsxt with cert auth is passed in config' do
        before do
          config_hash.merge! 'nsxt' => {
              'host' => 'fake-host',
              'username' => nil,
              'password' => nil,
              'private_key' => 'path',
              'certificate' => nil
          }
        end

        it 'raises a schema validation error' do
          expect do
            config.validate
          end.to raise_error(Membrane::SchemaValidationError)
        end
      end
    end

    describe '#logger' do
      it 'delegates to global Config.logger' do
        expect(config.logger).to eq(logger)
      end
    end

    describe '#agent' do
      it 'returns configuration values from config' do
        expect(config.agent).to eq(agent_config)
      end
    end

    describe '#vcenter_host' do
      it 'returns value from config' do
        expect(config.vcenter_host).to eq(host)
      end
    end

    describe '#vcenter_api_uri' do
      it 'returns vcenter API endpoint as URI' do
        expect(config.vcenter_api_uri).to eq(URI.parse("https://#{host}/sdk/vimService"))
      end
    end

    describe '#pbm_api_uri' do
      it 'returns PBM API endpoint as URI' do
        expect(config.pbm_api_uri).to eq(URI.parse("https://#{host}/pbm/sdk"))
      end
    end

    describe '#vcenter_user' do
      it 'returns value from config' do
        expect(config.vcenter_user).to eq(user)
      end
    end

    describe '#vcenter_password' do
      it 'returns value from config' do
        expect(config.vcenter_password).to eq(password)
      end
    end

    describe '#vcenter_default_disk_type' do
      context 'when the vcenter_default_disk_type is "thin"' do
        let(:default_disk_type) { 'thin' }
        it 'returns value from config' do
          expect(config.vcenter_default_disk_type).to eq('thin')
        end
      end
    end

    describe '#datacenter_name' do
      it 'returns the datacenter name' do
        expect(config.datacenter_name).to eq datacenter_name
      end
    end

    describe '#datacenter_vm_folder' do
      it 'returns the datacenter vm folder name' do
        expect(config.datacenter_vm_folder).to eq(vm_folder)
      end
    end

    describe '#datacenter_template_folder' do
      it 'returns the datacenter template folder name' do
        expect(config.datacenter_template_folder).to eq(template_folder)
      end
    end

    describe '#datacenter_disk_path' do
      it 'returns the datacenter disk path  name' do
        expect(config.datacenter_disk_path).to eq(disk_path)
      end
    end

    describe '#datacenter_datastore_pattern' do
      it 'returns the datacenter datastore pattern ' do
        expect(config.datacenter_datastore_pattern).to eq('fancy-datastore*')
      end
    end

    describe '#datacenter_persistent_datastore_pattern' do
      it 'returns the datacenter persistent datastore pattern ' do
        expect(config.datacenter_persistent_datastore_pattern).to eq(persistent_datastore_pattern)
      end
    end

    describe '#datacenter_clusters' do

      context 'when there is more than one cluster' do
        before do
          datacenters.first['clusters'] = [
            { 'fake-cluster-1' => { 'resource_pool' => 'fake-resource-pool-1' } },
            { 'fake-cluster-2' => { 'resource_pool' => 'fake-resource-pool-2' } }
          ]
        end

        it 'returns the datacenter clusters' do
          expect(config.datacenter_clusters['fake-cluster-1'].name).to eq('fake-cluster-1')
          expect(config.datacenter_clusters['fake-cluster-1'].resource_pool).to eq('fake-resource-pool-1')

          expect(config.datacenter_clusters['fake-cluster-2'].name).to eq('fake-cluster-2')
          expect(config.datacenter_clusters['fake-cluster-2'].resource_pool).to eq('fake-resource-pool-2')
        end
      end

      context 'when the cluster is not found' do
        it 'returns the datacenter clusters' do
          expect(config.datacenter_clusters['does-not-exist']).to be_nil
        end
      end

      context 'when the clusters are strings in the config' do
        let(:client) { instance_double('VSphereCloud::VCenterClient') }

        before do
          allow(VCenterClient).to receive(:new).and_return(client)
          allow(client).to receive(:login)

          datacenters.first['clusters'] = [
            'fake-cluster-1',
            { 'fake-cluster-2' => { 'resource_pool' => 'fake-resource-pool-2' } }
          ]

        end

        it 'returns the datacenter clusters' do
          expect(config.datacenter_clusters['fake-cluster-1'].name).to eq('fake-cluster-1')
          expect(config.datacenter_clusters['fake-cluster-1'].resource_pool).to be(nil)

          expect(config.datacenter_clusters['fake-cluster-2'].name).to eq('fake-cluster-2')
          expect(config.datacenter_clusters['fake-cluster-2'].resource_pool).to eq('fake-resource-pool-2')
        end
      end

      context 'when the clusters do not specify a resource pool' do
        let(:client) { instance_double('VSphereCloud::VCenterClient') }

        before do
          allow(VCenterClient).to receive(:new).and_return(client)
          allow(client).to receive(:login)

          datacenters.first['clusters'] = [
            'fake-cluster-1',
            { 'fake-cluster-2' => { } }
          ]

        end

        it 'returns the datacenter clusters' do
          expect(config.datacenter_clusters['fake-cluster-1'].name).to eq('fake-cluster-1')
          expect(config.datacenter_clusters['fake-cluster-1'].resource_pool).to be(nil)

          expect(config.datacenter_clusters['fake-cluster-2'].name).to eq('fake-cluster-2')
          expect(config.datacenter_clusters['fake-cluster-2'].resource_pool).to be(nil)
        end
      end

    end

    describe '#datacenter_use_sub_folder' do
      context 'when use sub folder is not set' do
        before { datacenters.first.delete('use_sub_folder') }

        context 'when no cluster has a resource pool' do
          before { datacenters.first['clusters'] = ['fake-cluster-1'] }

          it 'returns false' do
            expect(config.datacenter_use_sub_folder).to eq(false)
          end
        end
      end

      context 'when any cluster has a resource pool' do
        before do
          datacenters.first['clusters'] = [
            { 'fake-cluster-1' => { 'resource_pool' => 'fake-resource-pool-1' } }
          ]
        end

        it 'returns true' do
          expect(config.datacenter_use_sub_folder).to eq(true)
        end
      end
    end

    describe '#human_readable_name_enabled?' do
      context 'when it is set to false' do
        let(:config_hash) { {'vcenters' => ['enable_human_readable_name' => false] } }
        it 'returns value false from config' do
          expect(config.human_readable_name_enabled?).to eq(false)
        end
      end

      context 'when it is set to true' do
        let(:config_hash) { {'vcenters' => ['enable_human_readable_name' => true] } }
        it 'returns value true from config' do
          expect(config.human_readable_name_enabled?).to eq(true)
        end
      end
    end

    describe '#validate_nsx_options' do
      it 'returns true if all nsx options are present' do
        expect(config.validate_nsx_options).to be(true)
      end

      context 'when required NSX properties are missing' do
        before do
          config_hash['vcenters'].first['nsx'] = {}
        end

        it 'returns an error' do
          expect {
            config.validate_nsx_options
          }.to raise_error do |err|
            expect(err.message).to include('address', 'user', 'password')
          end
        end
      end
    end

    describe '#nsx_uri' do
      it 'returns value from config' do
        expect(config.nsx_url).to eq(nsx_url)
      end
    end

    describe '#nsx_user' do
      it 'returns value from config' do
        expect(config.nsx_user).to eq(nsx_user)
      end
    end

    describe '#nsx_password' do
      it 'returns value from config' do
        expect(config.nsx_password).to eq(nsx_password)
      end
    end

    describe '#vm_storage_policy_name' do
      it 'returns value from config' do
        expect(config.vm_storage_policy_name).to eq(vm_storage_policy_name)
      end
    end

    context 'when use sub folder is truthy' do
      before { datacenters.first['use_sub_folder'] = true }

      context 'when no cluster has a resource pool' do
        before { datacenters.first['clusters'] = ['fake-cluster-1'] }

        it 'returns false' do
          expect(config.datacenter_use_sub_folder).to eq(true)
        end
      end

      context 'when any cluster has a resource pool' do
        before do
          datacenters.first['clusters'] = [
            { 'fake-cluster-1' => { 'resource_pool' => 'fake-resource-pool-1' } }
          ]
        end

        it 'returns true' do
          expect(config.datacenter_use_sub_folder).to eq(true)
        end
      end
    end

    context 'when use sub folder is falsey' do
      before { datacenters.first['use_sub_folder'] = false }

      context 'when no cluster has a resource pool' do
        before { datacenters.first['clusters'] = ['fake-cluster-1'] }

        it 'returns false' do
          expect(config.datacenter_use_sub_folder).to eq(false)
        end
      end

      context 'when any cluster has a resource pool' do
        before do
          datacenters.first['clusters'] = [
            { 'fake-cluster-1' => { 'resource_pool' => 'fake-resource-pool-1' } }
          ]
        end

        it 'returns true' do
          expect(config.datacenter_use_sub_folder).to eq(true)
        end
      end
    end
  end
end
