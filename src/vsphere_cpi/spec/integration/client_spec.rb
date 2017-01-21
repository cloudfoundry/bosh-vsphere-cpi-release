require 'spec_helper'

module VSphereCloud
  describe VCenterClient do
    before do
      @client, @datacenter, @datastore, @disk_folder = setup
    end

    describe "#find_disk" do

      before do
        @disk_cid = "disk-#{SecureRandom.uuid}"
        @disk = @client.create_disk(@datacenter.mob, @datastore, @disk_cid, @disk_folder, 128, 'thin')
      end

      after do
        @client.delete_disk(@datacenter.mob, @disk.path)
      end

      it "returns the disk if it exists" do
        disk = @client.find_disk(@disk_cid, @datastore, @disk_folder)

        expect(disk.cid).to eq(@disk_cid)
        expect(disk.size_in_mb).to eq(128)
      end

      it "returns nil when the disk can't be found" do
        disk = @client.find_disk("not-the-#{@disk_cid}", @datastore, @disk_folder)

        expect(disk).to be_nil
      end

      it "returns nil when the disk folder doesn't exit" do
        disk = @client.find_disk(@disk_cid, @datastore, "the-wrong-disk-folder")

        expect(disk).to be_nil
      end
    end

    describe '#find_network' do
      let(:standard_virtual_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_STANDARD') }
      let(:distributed_virtual_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_DISTRIBUTED') }
      let(:ambiguous_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_AMBIGUOUS') }
      let(:ambiguous_portgroup_raise_issue) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_AMBIGUOUS_RAISE_ISSUE') }

      it 'returns the standard virtual switch if it exists' do
        network = @client.find_network(@datacenter, standard_virtual_portgroup)
        expect(network.name).to eq(standard_virtual_portgroup)
        expect(network).to be_a(VimSdk::Vim::Network)
      end

      it 'returns the distributed_virtual_portgroup if it exists' do
        network = @client.find_network(@datacenter, distributed_virtual_portgroup)
        expect(network.name).to eq(distributed_virtual_portgroup)
        expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
      end

      it 'returns the standard virtual switch if a standard switch has the same name as a distributed virtual portgroup' do
        network = @client.find_network(@datacenter, ambiguous_portgroup)
        expect(network.name).to eq(ambiguous_portgroup)
        expect(network).to be_a(VimSdk::Vim::Network)
      end

      it 'returns the distributed virtual portgroup if it is prefixed with the distributed virtual switch\'s name' do
        dvs_name = parent_dvs_from_portgroup(distributed_virtual_portgroup)

        network = @client.find_network(@datacenter, "#{dvs_name}/#{distributed_virtual_portgroup}")
        expect(network.name).to eq(distributed_virtual_portgroup)
        expect(network.config.distributed_virtual_switch.name).to eq(dvs_name)
        expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
      end

      it 'returns nil if the distributed virtual switch doesn\'t exist' do
        network = @client.find_network(@datacenter, "non-existent-dvs/#{ambiguous_portgroup}")
        expect(network).to be_nil
      end

      it 'returns nil if the standard virtual portgroup doesn\'t exist' do
        network = @client.find_network(@datacenter, 'non-existent-standard-portgroup')
        expect(network).to be_nil
      end

      it 'raises ambiguous issue when provided network name matches multiple networks' do
        expect do
          @client.find_network(@datacenter, ambiguous_portgroup_raise_issue)
        end.to raise_error(/#{ambiguous_portgroup_raise_issue}/)
      end

      context 'if the network is prefixed with folders\' names' do
        let(:standard_virtual_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_STANDARD') }
        let(:distributed_virtual_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_DISTRIBUTED') }
        let(:ambiguous_portgroup) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_AMBIGUOUS') }

        it 'returns the standard virtual switch if it exists' do
          network = @client.find_network(@datacenter, standard_virtual_portgroup)
          expected_name = standard_virtual_portgroup.split('/').last
          expect(network.name).to eq(expected_name)
          expect(network).to be_a(VimSdk::Vim::Network)
        end

        it 'returns the distributed_virtual_portgroup if it exists' do
          network = @client.find_network(@datacenter, distributed_virtual_portgroup)
          expected_name = distributed_virtual_portgroup.split('/').last
          expect(network.name).to eq(expected_name)
          expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
        end

        it 'returns the standard virtual switch if a standard switch has the same name as a distributed virtual portgroup' do
          network = @client.find_network(@datacenter, ambiguous_portgroup)
          expected_name = ambiguous_portgroup.split('/').last
          expect(network.name).to eq(expected_name)
          expect(network).to be_a(VimSdk::Vim::Network)
        end

        it 'returns the distributed virtual portgroup if it is prefixed with the distributed virtual switch\'s name' do
          expected_network_name = distributed_virtual_portgroup.split('/')[-1]
          expected_dvs_name = distributed_virtual_portgroup.split('/')[-2]

          network = @client.find_network(@datacenter, distributed_virtual_portgroup)
          expect(network.name).to eq(expected_network_name)
          expect(network.config.distributed_virtual_switch.name).to eq(expected_dvs_name)
          expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
        end

        it 'returns nil if the distributed virtual switch doesn\'t exist' do
          folder_name = distributed_virtual_portgroup.split('/').first
          network_name = distributed_virtual_portgroup.split('/').last
          network = @client.find_network(@datacenter, "#{folder_name}/non-existent-dvs/#{network_name}")
          expect(network).to be_nil
        end

        it 'returns nil if the standard virtual portgroup doesn\'t exist' do
          folder_name = standard_virtual_portgroup.split('/').first
          network = @client.find_network(@datacenter, "#{folder_name}/non-existent-standard-portgroup")
          expect(network).to be_nil
        end
      end
    end

    def setup
      host = ENV.fetch('BOSH_VSPHERE_CPI_HOST')
      user = ENV.fetch('BOSH_VSPHERE_CPI_USER')
      password = ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD')
      disk_folder = ENV.fetch('BOSH_VSPHERE_CPI_DISK_PATH')
      datacenter_name = ENV.fetch('BOSH_VSPHERE_CPI_DATACENTER')
      vm_folder = ENV.fetch('BOSH_VSPHERE_CPI_VM_FOLDER')
      template_folder = ENV.fetch('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER')
      ephemeral_datastore_pattern = Regexp.new(ENV.fetch('BOSH_VSPHERE_CPI_DATASTORE_PATTERN'))
      persistent_datastore_pattern = Regexp.new(ENV.fetch('BOSH_VSPHERE_CPI_SECOND_DATASTORE'))
      cluster_name = ENV.fetch('BOSH_VSPHERE_CPI_CLUSTER')
      resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_RESOURCE_POOL')

      cluster_configs = {cluster_name => ClusterConfig.new(cluster_name, {'resource_pool' => resource_pool_name})}
      logger = Logger.new(StringIO.new(""))

      client = VSphereCloud::VCenterClient.new(
        vcenter_api_uri: URI.parse("https://#{host}/sdk/vimService"),
        http_client: VSphereCloud::CpiHttpClient.new(logger),
        logger: logger,
      )
      client.login(user, password, 'en')

      cluster_provider = Resources::ClusterProvider.new({
        datacenter_name: datacenter_name,
        client: client,
        logger: logger,
      })
      datacenter = Resources::Datacenter.new({
          client: client,
          use_sub_folder: false,
          vm_folder: vm_folder,
          template_folder: template_folder,
          name: datacenter_name,
          disk_path: disk_folder,
          ephemeral_pattern: ephemeral_datastore_pattern,
          persistent_pattern: persistent_datastore_pattern,
          clusters: cluster_configs,
          cluster_provider: cluster_provider,
          logger: logger,
        })

      persistent_datastores = datacenter.select_datastores(persistent_datastore_pattern).values
      return client, datacenter, persistent_datastores.first, disk_folder
    end

    def parent_dvs_from_portgroup(portgroup_name)
      pg = @datacenter.mob.network.find { |n| n.name == portgroup_name && n.instance_of?(VimSdk::Vim::Dvs::DistributedVirtualPortgroup) }
      pg.config.distributed_virtual_switch.name
    end
  end
end
