require 'spec_helper'

module VSphereCloud
  describe VCenterClient, fake_logger: true do
    before do
      @client, @datacenter, @datastore, @disk_folder = setup
    end

    describe '#find_disk' do

      before do
        @disk_cid = "disk-#{SecureRandom.uuid}"
        @disk = @client.create_disk(@datacenter.mob, @datastore, @disk_cid, @disk_folder, 128, 'thin')
      end

      after do
        @client.delete_disk(@datacenter.mob, @disk.path)
      end

      it 'returns the disk if it exists' do
        disk = @client.find_disk(@disk_cid, @datastore, @disk_folder)

        expect(disk.cid).to eq(@disk_cid)
        expect(disk.size_in_mb).to eq(128)
      end

      it 'returns nil when the disk can not be found' do
        disk = @client.find_disk("not-the-#{@disk_cid}", @datastore, @disk_folder)

        expect(disk).to be_nil
      end

      it 'returns nil when the disk folder does not exit' do
        disk = @client.find_disk(@disk_cid, @datastore, 'the-wrong-disk-folder')

        expect(disk).to be_nil
      end
    end

    describe '#find_network' do
      let(:standard_portgroup_name) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_STANDARD') }
      let(:dvpg_name) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_DISTRIBUTED') }
      let(:opaque_network_name) { ENV.fetch('BOSH_VSPHERE_OPAQUE_VLAN') }

      it 'returns nil if no such network exists' do
        expect(@client.find_network(@datacenter, 'absent-network')).to be_nil
      end

      it "returns nil if the DVS doesn't exist" do
        expect(@client.find_network(@datacenter, "absent-dvs/#{dvpg_name}")).to be_nil
      end

      it 'returns the standard switch if it exists' do
        network = @client.find_network(@datacenter, standard_portgroup_name)
        expect(network.name).to eq(standard_portgroup_name)
        expect(network).to be_an_instance_of(VimSdk::Vim::Network)
      end

      it 'returns the DVPG if it exists' do
        network = @client.find_network(@datacenter, dvpg_name)
        expect(network.name).to eq(dvpg_name)
        expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
      end

      it 'returns the opaque network if it exists', nvds: true do
        network = @client.find_network(@datacenter, opaque_network_name)
        expect(network.name).to eq(opaque_network_name)
        expect(network).to be_a(VimSdk::Vim::OpaqueNetwork)
      end

      it "returns the DVPG if it's prefixed with the DVS's name" do
        dvs_name = @datacenter.mob.network.select do |network|
          network.is_a?(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
        end.find do |network|
          network.name == dvpg_name
        end.config.distributed_virtual_switch.name

        network = @client.find_network(@datacenter, "#{dvs_name}/#{dvpg_name}")
        expect(network.name).to eq(dvpg_name)
        expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
        expect(network.config.distributed_virtual_switch.name).to eq(dvs_name)
      end

      context 'with a name that matches multiple networks' do
        let(:dvpg_name) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_AMBIGUOUS') }
        let(:erroneous_dvpg_name) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_AMBIGUOUS_RAISE_ISSUE') }

        it 'returns the standard switch if a standard switch is matched' do
          network = @client.find_network(@datacenter, dvpg_name)
          expect(network.name).to eq(dvpg_name)
          expect(network).to be_an_instance_of(VimSdk::Vim::Network)
        end

        context 'when all matched networks are DVPGs', cvds: true do
          let(:dvpg_name) { ENV.fetch('BOSH_VSPHERE_OPAQUE_VLAN') }
          let(:erroneous_dvpg_name) { ENV.fetch('BOSH_VSPHERE_AMBIGUOUS_OPAQUE_VLAN') }

          it 'returns a DVPG if all DVPGs are on the same logical switch' do
            network = @client.find_network(@datacenter, dvpg_name)
            expect(network.name).to eq(dvpg_name)
            expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
          end

          it 'raises an ambiguous network error otherwise' do
            expect do
              @client.find_network(@datacenter, erroneous_dvpg_name)
            end.to raise_error(/#{erroneous_dvpg_name}/)
          end
        end

        it 'raises an ambiguous network error otherwise' do
          expect do
            @client.find_network(@datacenter, erroneous_dvpg_name)
          end.to raise_error(/#{erroneous_dvpg_name}/)
        end
      end

      context 'if the network name is prefixed with a folder path' do
        let(:standard_portgroup_path) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_STANDARD') }
        let(:dvpg_path) { ENV.fetch('BOSH_VSPHERE_CPI_PORTGROUP_FOLDER_DISTRIBUTED') }

        it 'returns nil if no such network exists' do
          folder_name = standard_portgroup_path.split('/').first
          network = @client.find_network(@datacenter, "#{folder_name}/absent-network")
          expect(network).to be_nil
        end

        it "returns nil if the DVS doesn't exist" do
          folder_name, *_, name = dvpg_path.split('/')
          network = @client.find_network(@datacenter, "#{folder_name}/absent-dvs/#{name}")
          expect(network).to be_nil
        end

        it 'returns the standard switch if it exists' do
          network = @client.find_network(@datacenter, standard_portgroup_path)
          expect(network).to be_an_instance_of(VimSdk::Vim::Network)
          expect(network.name).to eq(standard_portgroup_path.split('/').last)
        end

        it 'returns the DVPG if it exists' do
          folder_name, dvs_name, name = dvpg_path.split('/')
          network = @client.find_network(@datacenter, "#{folder_name}/#{name}")
          expect(network.name).to eq(dvpg_path.split('/').last)
          expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)
        end

        it "returns the DVPG if it's prefixed with the DVS's name" do
          network = @client.find_network(@datacenter, dvpg_path)
          expect(network).to be_a(VimSdk::Vim::Dvs::DistributedVirtualPortgroup)

          *_, dvs_name, name = dvpg_path.split('/')
          expect(network.name).to eq(name)
          expect(network.config.distributed_virtual_switch.name).to eq(dvs_name)
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

      client = VSphereCloud::VCenterClient.new(
        vcenter_api_uri: URI.parse("https://#{host}/sdk/vimService"),
        http_client: VSphereCloud::CpiHttpClient.new(logger)
      )
      client.login(user, password, 'en')

      cluster_provider = Resources::ClusterProvider.new(
        datacenter_name: datacenter_name,
        client: client
      )
      datacenter = Resources::Datacenter.new(
        client: client,
        use_sub_folder: false,
        vm_folder: vm_folder,
        template_folder: template_folder,
        name: datacenter_name,
        disk_path: disk_folder,
        ephemeral_pattern: ephemeral_datastore_pattern,
        persistent_pattern: persistent_datastore_pattern,
        clusters: cluster_configs,
        cluster_provider: cluster_provider
      )

      regexp = Regexp.new(persistent_datastore_pattern)
      persistent_datastores = datacenter.accessible_datastores.select do |name, _|
        name =~ regexp
      end.values
      return client, datacenter, persistent_datastores.first, disk_folder
    end
  end
end
