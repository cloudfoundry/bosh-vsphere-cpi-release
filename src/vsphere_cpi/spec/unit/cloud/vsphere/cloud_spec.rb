require 'spec_helper'
require 'ostruct'

module VSphereCloud
  describe Cloud do
    subject(:vsphere_cloud) { Cloud.new(config) }

    let(:config) { { 'vcenters' => [fake: 'config'] } }
    let(:cloud_config) do
      instance_double('VSphereCloud::Config',
        logger: logger,
        vcenter_host: vcenter_host,
        vcenter_api_uri: vcenter_api_uri,
        vcenter_user: 'fake-user',
        vcenter_password: 'fake-password',
        vcenter_default_disk_type: default_disk_type,
        soap_log: 'fake-log-file',
        vcenter_enable_auto_anti_affinity_drs_rules: false,
        vcenter_http_logging: true,
      ).as_null_object
    end
    let(:default_disk_type) { 'preallocated' }
    let(:logger) { instance_double('Bosh::Cpi::Logger', info: nil, debug: nil) }
    let(:vcenter_client) { instance_double('VSphereCloud::VCenterClient', login: nil, service_content: service_content) }
    let(:http_basic_auth_client) { instance_double('VSphereCloud::NsxHttpClient') }
    let(:http_client) { instance_double('VSphereCloud::CpiHttpClient') }
    let(:service_content) do
      instance_double('VimSdk::Vim::ServiceInstanceContent',
        virtual_disk_manager: virtual_disk_manager,
      )
    end
    let(:virtual_disk_manager) { instance_double('VimSdk::Vim::VirtualDiskManager') }
    let(:agent_env) { instance_double('VSphereCloud::AgentEnv') }
    let(:vcenter_host) { 'fake-host' }
    let(:vcenter_api_uri) { URI.parse("https://#{vcenter_host}") }
    before { allow(VSphereCloud::AgentEnv).to receive(:new).and_return(agent_env) }

    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
    before { allow(CloudSearcher).to receive(:new).and_return(cloud_searcher) }

    before do
      allow(Config).to receive(:build).with(config).and_return(cloud_config)
      allow(CpiHttpClient).to receive(:new)
        .with('fake-log-file')
        .and_return(http_client)
      allow(VCenterClient).to receive(:new)
        .with({
          vcenter_api_uri: vcenter_api_uri,
          http_client: http_client,
          logger: logger,
        })
        .and_return(vcenter_client)
      allow_any_instance_of(Cloud).to receive(:at_exit)
    end

    let(:datacenter) { instance_double('VSphereCloud::Resources::Datacenter', name: 'fake-datacenter', clusters: {}) }
    before { allow(Resources::Datacenter).to receive(:new).and_return(datacenter) }
    let(:vm_provider) { instance_double('VSphereCloud::VMProvider') }
    before { allow(VSphereCloud::VMProvider).to receive(:new).and_return(vm_provider) }
    let(:vm) { instance_double('VSphereCloud::Resources::VM', mob: vm_mob, reload: nil, cid: 'vm-id') }
    let(:vm_mob) { instance_double('VimSdk::Vim::VirtualMachine') }
    before { allow(vm_provider).to receive(:find).with('vm-id').and_return(vm) }
    let(:cluster_provider) { instance_double(VSphereCloud::Resources::ClusterProvider) }
    before { allow(Resources::ClusterProvider).to receive(:new).and_return(cluster_provider) }

    describe '#has_vm?' do
      context 'the vm is found' do
        it 'returns true' do
          expect(vsphere_cloud.has_vm?('vm-id')).to be(true)
        end
      end

      context 'the vm is not found' do
        it 'returns false' do
          allow(vm_provider).to receive(:find).with('vm-id').and_raise(Bosh::Clouds::VMNotFound)
          expect(vsphere_cloud.has_vm?('vm-id')).to be(false)
        end
      end
    end

    describe '#has disk?' do
      let(:disk_cid) { 'disk-1234-5667-1242-1233' }
      let(:encoded_disk_cid) do
        metadata = {target_datastore_pattern: '^(fake\\-ds)$'}
        expected_pattern = Base64.urlsafe_encode64(metadata.to_json)
        "#{disk_cid}.#{expected_pattern}"
      end

      context 'when disk exists' do
        before do
          allow(datacenter).to receive(:find_disk).with(disk_cid).and_return("fake disk")
        end

        context 'when disk_cid contains metadata' do
          it 'returns true' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(true)
          end
        end

        context 'when disk_cid does not contain metadata' do
          it 'returns true' do
            expect(vsphere_cloud.has_disk?(disk_cid)).to be(true)
          end
        end
      end

      context 'when disk does not exist' do
        before do
          allow(datacenter).to receive(:find_disk)
            .with(disk_cid)
            .and_raise(Bosh::Clouds::DiskNotFound.new(false), "Could not find disk with id '#{disk_cid}'")
        end

        context 'when disk_cid contains metadata' do
          it 'returns false' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(false)
          end
        end

        context 'when disk_cid does not contain metadata' do
          it 'returns false' do
            expect(vsphere_cloud.has_disk?(disk_cid)).to be(false)
          end
        end
      end
    end

    describe '#snapshot_disk' do
      it 'raises not implemented exception when called' do
        expect { vsphere_cloud.snapshot_disk('123', {}) }.to raise_error(Bosh::Clouds::NotImplemented)
      end
    end

    describe '#replicate_stemcell' do
      let(:stemcell_vm) { double('fake local stemcell') }
      let(:stemcell_id) { 'fake_stemcell_id' }

      let(:template_folder) do
        double(:template_folder,
          path_components: ['fake_template_folder'],
          mob: 'fake_template_folder_mob'
        )
      end

      let(:datacenter) do
        double('fake datacenter',
          name: 'fake_datacenter',
          template_folder: template_folder,
          clusters: {},
          mob: 'fake-datacenter-mob'
        )
      end

      let(:cluster) { double('fake cluster', datacenter: datacenter) }
      let(:target_datastore) { instance_double('VSphereCloud::Resources::Datastore', :name => 'fake datastore') }

      before do
        mob = double(:mob, __mo_id__: 'fake_datastore_managed_object_id')
        allow(target_datastore).to receive(:mob).and_return(mob)
      end


      context 'when stemcell vm is not found at the expected location' do
        it 'raises an error' do
          allow(vcenter_client).to receive(:find_vm_by_name).and_return(nil)

          expect {
            vsphere_cloud.replicate_stemcell(cluster, target_datastore, 'fake_stemcell_id')
          }.to raise_error(/Could not find VM for stemcell/)
        end
      end

      context 'when stemcell vm resides on a different datastore' do
        let(:datastore_with_stemcell) { instance_double('VSphereCloud::Resources::Datastore', :name => 'datastore-with-stemcell') }

        before do
          allow(vcenter_client).to receive(:find_vm_by_name).with('fake-datacenter-mob', stemcell_id).and_return(stemcell_vm)

          allow(cloud_searcher).to receive(:get_property).with(stemcell_vm, anything, 'datastore', anything).and_return([datastore_with_stemcell])
        end

        it 'searches for stemcell on all cluster datastores' do
          expect(vcenter_client).to receive(:find_vm_by_name).with(
              'fake-datacenter-mob',
              "#{stemcell_id} %2f #{target_datastore.mob.__mo_id__}"
          ).and_return(double('fake stemcell vm'))

          vsphere_cloud.replicate_stemcell(cluster, target_datastore, stemcell_id)
        end

        context 'when the stemcell replica is not found in the datacenter' do
          let(:replicated_stemcell) { double('fake_replicated_stemcell') }
          let(:fake_task) { 'fake_task' }


          it 'replicates the stemcell' do
            allow(vcenter_client).to receive(:find_vm_by_name).with(
                'fake-datacenter-mob',
                "#{stemcell_id} %2f #{target_datastore.mob.__mo_id__}"
            )

            resource_pool = double(:resource_pool, mob: 'fake_resource_pool_mob')
            allow(cluster).to receive(:resource_pool).and_return(resource_pool)
            allow(stemcell_vm).to receive(:clone).with(any_args).and_return(fake_task)
            allow(vcenter_client).to receive(:wait_for_task) do |*args, &block|
              expect(block.call).to eq(fake_task)
              replicated_stemcell
            end
            allow(replicated_stemcell).to receive(:create_snapshot).with(any_args).and_return(fake_task)

            expect(vsphere_cloud.replicate_stemcell(cluster, target_datastore, stemcell_id)).to eql(replicated_stemcell)
          end
        end
      end

      context 'when stemcell resides on the given datastore' do
        it 'returns the found replica' do
          allow(vcenter_client).to receive(:find_vm_by_name).with(any_args).and_return(stemcell_vm)
          allow(cloud_searcher).to receive(:get_property).with(any_args).and_return([target_datastore])
          expect(vsphere_cloud.replicate_stemcell(cluster, target_datastore, stemcell_id)).to eql(stemcell_vm)
        end
      end
    end

    describe '#generate_network_env' do
      let(:device) { instance_double('VimSdk::Vim::Vm::Device::VirtualEthernetCard', backing: backing, mac_address: '00:00:00:00:00:00') }
      let(:devices) { [device] }
      let(:network1) {
        {
          'cloud_properties' => {
            'name' => 'fake_network1'
          }
        }
      }
      let(:networks) { { 'fake_network1' => network1 } }
      let(:dvs_index) { {} }
      let(:expected_output) { {
        'fake_network1' => {
          'cloud_properties' => {
            'name' => 'fake_network1'
          },
          'mac' => '00:00:00:00:00:00'
        }
      } }
      let(:path_finder) { instance_double('VSphereCloud::PathFinder') }

      before do
        allow(device).to receive(:kind_of?).with(VimSdk::Vim::Vm::Device::VirtualEthernetCard) { true }
        allow(PathFinder).to receive(:new).and_return(path_finder)
        allow(path_finder).to receive(:path).with(any_args).and_return('fake_network1')
      end

      context 'using a distributed switch' do
        let(:backing) do
          port = double(:port, portgroup_key: 'fake_pgkey1')
          instance_double(
            'VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo',
            port: port
          )
        end

        before do
          allow(backing).to receive(:kind_of?).
            with(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo).
            and_return(true)
        end

        let(:dvs_index) { { 'fake_pgkey1' => 'fake_network1' } }

        it 'generates the network env' do
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'using a standard switch' do
        let(:backing) { double(network: 'fake_network1') }

        it 'generates the network env' do
          allow(backing).to receive(:kind_of?).with(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo) { false }

          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'passing in device that is not a VirtualEthernetCard' do
        let(:devices) { [device, double()] }
        let(:backing) { double(network: 'fake_network1') }

        it 'ignores non VirtualEthernetCard devices' do
          allow(backing).to receive(:kind_of?).with(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo) { false }

          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'not passing any device that is a VirtualEthernetCard' do
        let(:devices) { [] }
        let(:backing) { double }

        it 'responds with an appropriate error message' do
          expect {
            vsphere_cloud.generate_network_env(devices, networks, dvs_index)
          }.to raise_error(Cloud::NetworkException, "Could not find network 'fake_network1'")
        end
      end

      context 'when the network is in a folder' do

        context 'using a standard switch' do
          let(:path_finder) { instance_double('VSphereCloud::PathFinder') }
          let(:fake_network_object) { double() }
          let(:backing) { double(network: fake_network_object) }
          let(:network1) {
            {
              'cloud_properties' => {
                'name' => 'networks/fake_network1'
              }
            }
          }
          let(:networks) { { 'networks/fake_network1' => network1 } }
          let(:expected_output) { {
            'networks/fake_network1' => {
              'cloud_properties' => {
                'name' => 'networks/fake_network1'
              },
              'mac' => '00:00:00:00:00:00'
            }
          } }

          it 'generates the network env' do
            allow(PathFinder).to receive(:new).and_return(path_finder)
            allow(path_finder).to receive(:path).with(fake_network_object).and_return('networks/fake_network1')

            allow(backing).to receive(:kind_of?).with(VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo) { false }

            expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
          end
        end

      end

    end

    describe '#get_vms' do
      before do
        allow(datacenter).to receive(:master_vm_folder).and_return(master_vm_folder)
        allow(datacenter).to receive(:master_template_folder).and_return(master_template_folder)
      end

      let(:master_vm_folder) do
        instance_double('VSphereCloud::Resources::Folder',
          path: 'fake-vm-folder-path',
          mob: vm_folder_mob
        )
      end
      let(:vm_folder_mob) { double('fake folder mob', child_entity: [subfolder]) }
      let(:subfolder) { double('fake subfolder', child_entity: [vm_mob1, vm_mob2]) }
      let(:vm_mob1) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-vm-1') }
      let(:vm_mob2) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-vm-2') }

      let(:master_template_folder) do
        instance_double('VSphereCloud::Resources::Folder',
          path: 'fake-template-folder-path',
          mob: template_folder_mob
        )
      end
      let(:template_folder_mob) { double('fake template folder mob', child_entity: [template_subfolder_mob]) }
      let(:template_subfolder_mob) { double('fake template subfolder', child_entity: [stemcell_mob1, stemcell_mob2]) }
      let(:stemcell_mob1) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-stemcell-1') }
      let(:stemcell_mob2) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-stemcell-2') }

      it 'returns all vms in vm_folder of datacenter and all stemcells in template_folder' do
        vms = vsphere_cloud.get_vms
        expect(vms.map(&:cid)).to eq(['fake-vm-1', 'fake-vm-2', 'fake-stemcell-1', 'fake-stemcell-2'])
        expect(vms.map(&:mob)).to eq([vm_mob1, vm_mob2, stemcell_mob1, stemcell_mob2])
      end
    end

    describe '#create_vm' do
      let(:stemcell_vm) { instance_double(Resources::VM) }
      let(:vm_creator) { instance_double(VmCreator) }
      let(:vm_config) { instance_double(VmConfig) }
      let(:cluster_picker) { instance_double(ClusterPicker) }
      let(:ip_conflict_detector) { instance_double(IPConflictDetector) }
      let(:existing_disk_cids) { ['fake-disk-cid'] }
      let(:fake_disk) do
        instance_double(Resources::PersistentDisk,
          cid: 'fake-disk-cid',
          size_in_mb: 1234,
          datastore: fake_datastore,
        )
      end
      let(:fake_datastore) { instance_double(Resources::Datastore, name: 'fake-datastore') }
      let(:fake_vm) { instance_double(Resources::VM, cid: 'fake-cloud-id', mob_id: 'fake-mob-id') }
      let(:vm_type) do
        {
          'disk' => 4096,
        }
      end
      let(:nsx) { instance_double(NSX) }

      before do
        allow(vsphere_cloud).to receive(:stemcell_vm)
          .with('fake-stemcell-cid')
          .and_return(stemcell_vm)
        allow(cloud_searcher).to receive(:get_property)
          .with(
            stemcell_vm,
            VimSdk::Vim::VirtualMachine,
            'summary.storage.committed',
            ensure_all: true
          )
          .and_return(1024 * 1024 * 1024)

        allow(datacenter).to receive(:clusters_hash)
          .and_return({ 'fake-cluster' => {} })
        allow(datacenter).to receive(:ephemeral_pattern)
          .and_return('fake-ephemeral-pattern')
        allow(datacenter).to receive(:persistent_pattern)
          .and_return('fake-persistent-pattern')
        allow(datacenter).to receive(:find_disk)
          .with('fake-disk-cid')
          .and_return(fake_disk)

        allow(IPConflictDetector).to receive(:new)
          .with(logger, vcenter_client)
          .and_return(ip_conflict_detector)
        allow(ClusterPicker).to receive(:new)
          .and_return(cluster_picker)
        allow(IPConflictDetector).to receive(:new)
          .with(logger, vcenter_client)
          .and_return(ip_conflict_detector)
      end

      it 'creates a new VM with provided manifest properties' do
        expected_manifest_params = {
          vm_type: vm_type,
          networks_spec: "fake-networks-hash",
          agent_id:      "fake-agent-id",
          agent_env:     {},
          stemcell: {
            cid: "fake-stemcell-cid",
            size: 1024
          },
          global_clusters: { 'fake-cluster' => {} },
          disk_configurations: [
            {
              cid: fake_disk.cid,
              size: fake_disk.size_in_mb,
              existing_datastore_name: fake_datastore.name,
              target_datastore_pattern: 'fake-persistent-pattern',
            },
            {
              size: 4096,
              ephemeral: true,
              target_datastore_pattern: 'fake-ephemeral-pattern',
            }
          ],
        }

        allow(VmConfig).to receive(:new)
          .with({
            manifest_params: expected_manifest_params,
            cluster_picker: cluster_picker,
          })
          .and_return(vm_config)
        expect(vm_config).to receive(:validate)

        expect(VmCreator).to receive(:new)
          .with(
            client: vcenter_client,
            cloud_searcher: cloud_searcher,
            logger: logger,
            cpi: vsphere_cloud,
            datacenter: datacenter,
            cluster_provider: cluster_provider,
            agent_env: agent_env,
            ip_conflict_detector: ip_conflict_detector,
            default_disk_type: default_disk_type,
            enable_auto_anti_affinity_drs_rules: false,
          )
          .and_return(vm_creator)
        expect(vm_creator).to receive(:create)
          .with(vm_config)
          .and_return(fake_vm)

        vsphere_cloud.create_vm(
          "fake-agent-id",
          "fake-stemcell-cid",
          vm_type,
          "fake-networks-hash",
          existing_disk_cids,
          {},
        )
      end

      it 'creates a new VM with no existing disks and default environment' do
        expected_manifest_params = {
          vm_type: vm_type,
          networks_spec: "fake-networks-hash",
          agent_id:      "fake-agent-id",
          agent_env:     nil,
          stemcell: {
            cid: "fake-stemcell-cid",
            size: 1024
          },
          global_clusters: { 'fake-cluster' => {} },
          disk_configurations: [
            {
              size: 4096,
              ephemeral: true,
              target_datastore_pattern: 'fake-ephemeral-pattern',
            }
          ],
        }
        expect(VmConfig).to receive(:new)
          .with(
            manifest_params: expected_manifest_params,
            cluster_picker: cluster_picker
          )
          .and_return(vm_config)
        expect(vm_config).to receive(:validate)

        expect(VmCreator).to receive(:new)
          .with(
            client: vcenter_client,
            cloud_searcher: cloud_searcher,
            logger: logger,
            cpi: vsphere_cloud,
            datacenter: datacenter,
            cluster_provider: cluster_provider,
            agent_env: agent_env,
            ip_conflict_detector: ip_conflict_detector,
            default_disk_type: default_disk_type,
            enable_auto_anti_affinity_drs_rules: false,
          )
          .and_return(vm_creator)
        expect(vm_creator).to receive(:create)
          .with(vm_config)
          .and_return(fake_vm)

        vsphere_cloud.create_vm(
          "fake-agent-id",
          "fake-stemcell-cid",
          vm_type,
          "fake-networks-hash",
        )
      end

      context 'when existing_disk_cids contains encoded metadata' do
        let(:disk_metadata) do
          {
            target_datastore_pattern: '^(fake\-datastore)$',
          }
        end
        let(:existing_disk_cids) { ["fake-disk-cid.#{Base64.urlsafe_encode64(disk_metadata.to_json)}"] }

        before do
          allow(VmCreator).to receive(:new)
            .and_return(vm_creator)
          allow(vm_creator).to receive(:create).and_return(fake_vm)
        end

        it 'creates the VM with disk cid parsed from the metadata-encoded director disk cid' do
          expect(VmConfig).to receive(:new) do |options|
            expect(options[:manifest_params][:disk_configurations]).to eq([
              {
                cid: fake_disk.cid,
                size: fake_disk.size_in_mb,
                existing_datastore_name: fake_datastore.name,
                target_datastore_pattern: disk_metadata[:target_datastore_pattern],
              },
              {
                size: 4096,
                ephemeral: true,
                target_datastore_pattern: 'fake-ephemeral-pattern',
              }
            ])
            vm_config
          end
          expect(vm_config).to receive(:validate)

          vsphere_cloud.create_vm(
            "fake-agent-id",
            "fake-stemcell-cid",
            vm_type,
            "fake-networks-hash",
            existing_disk_cids,
            {},
          )
        end
      end

      context 'when default_disk_type is set to "thin"' do
        let(:default_disk_type) { 'thin' }

        it 'creates a new VM with a thinly-provisioned ephemeral disk' do
          expected_manifest_params = {
            vm_type: vm_type,
            networks_spec: "fake-networks-hash",
            agent_id:      "fake-agent-id",
            agent_env:     {},
            stemcell: {
              cid: "fake-stemcell-cid",
              size: 1024
            },
            global_clusters: { 'fake-cluster' => {} },
            disk_configurations: [
              {
                cid: fake_disk.cid,
                size: fake_disk.size_in_mb,
                existing_datastore_name: fake_datastore.name,
                target_datastore_pattern: 'fake-persistent-pattern',
              },
              {
                size: 4096,
                ephemeral: true,
                target_datastore_pattern: 'fake-ephemeral-pattern',
              }
            ],
          }

          allow(VmConfig).to receive(:new)
                               .with({
                                 manifest_params: expected_manifest_params,
                                 cluster_picker: cluster_picker,
                               })
                               .and_return(vm_config)
          expect(vm_config).to receive(:validate)

          expect(VmCreator).to receive(:new)
                                 .with(
                                   client: vcenter_client,
                                   cloud_searcher: cloud_searcher,
                                   logger: logger,
                                   cpi: vsphere_cloud,
                                   datacenter: datacenter,
                                   cluster_provider: cluster_provider,
                                   agent_env: agent_env,
                                   ip_conflict_detector: ip_conflict_detector,
                                   default_disk_type: 'thin',
                                   enable_auto_anti_affinity_drs_rules: false,
                                 )
                                 .and_return(vm_creator)
          expect(vm_creator).to receive(:create)
                                  .with(vm_config)
                                  .and_return(fake_vm)

          vsphere_cloud.create_vm(
            "fake-agent-id",
            "fake-stemcell-cid",
            vm_type,
            "fake-networks-hash",
            existing_disk_cids,
            {},
          )
        end
      end

      context 'when the VM should have security tags' do
        let(:cloud_config) do
          instance_double('VSphereCloud::Config',
            logger: logger,
            vcenter_host: vcenter_host,
            vcenter_api_uri: vcenter_api_uri,
            vcenter_user: 'fake-user',
            vcenter_password: 'fake-password',
            vcenter_default_disk_type: default_disk_type,
            soap_log: 'fake-log-file',
            nsx_user: 'fake-nsx-user',
            nsx_password: 'fake-nsx-password',
          ).as_null_object
        end
        let(:vm_type) do
          {
            'nsx' => {
              'security_groups' => [
                'fake-security-tag',
                'another-fake-security-tag',
              ],
            }
          }
        end
        let(:environment) do
          {
            'bosh' => {
              'groups' => [
                'my-fake-environment-group',
              ]
            }
          }
        end

        it 'should create the security tags and attach them to the VM' do
          allow(VmConfig).to receive(:new)
                           .and_return(vm_config)
          allow(NsxHttpClient).to receive(:new)
                            .with('fake-nsx-user', 'fake-nsx-password', 'fake-log-file')
                            .and_return(http_basic_auth_client)
          allow(NSX).to receive(:new).and_return(nsx)
          expect(vm_config).to receive(:validate)

          expect(VmCreator).to receive(:new)
                           .and_return(vm_creator)
          expect(vm_creator).to receive(:create)
                           .with(vm_config)
                           .and_return(fake_vm)
          expect(cloud_config).to receive(:validate_nsx_options)
          expect(nsx).to receive(:add_vm_to_security_group)
                           .with('fake-security-tag', 'fake-mob-id')
          expect(nsx).to receive(:add_vm_to_security_group)
                           .with('another-fake-security-tag', 'fake-mob-id')
          expect(nsx).to receive(:add_vm_to_security_group)
                           .with('my-fake-environment-group', 'fake-mob-id')
          vsphere_cloud.create_vm(
            "fake-agent-id",
            "fake-stemcell-cid",
            vm_type,
            "fake-networks-hash",
            [],
            environment,
          )
        end

      end
    end

    describe '#calculate_vm_cloud_properties' do
      context 'when ram, cpu, and ephemeral_disk are specified' do
        let(:vm_properties) { {
          'ram' => 512,
          'cpu' => 2,
          'ephemeral_disk_size' => 2048
        } }
        it 'returns a vSphere-specific set of cloud_properties' do
          expect(vsphere_cloud.calculate_vm_cloud_properties(vm_properties)).to eq({
            'ram' => 512,
            'cpu' => 2,
            'disk' => 2048
          })
        end
      end
      context 'when one of the three keys is missing' do
        let(:vm_properties) { {
          'ram' => 512,
          'cpu' => 2,
        } }
        it 'raises an error' do
          expect{vsphere_cloud.calculate_vm_cloud_properties(vm_properties)}.to raise_error(
            /Missing VM cloud properties: 'ephemeral_disk_size'/)
        end
      end
      context 'when two of the three keys is missing' do
        let(:vm_properties) { {
          'cpu' => 2,
        } }
        it 'raises an error' do
          expect{vsphere_cloud.calculate_vm_cloud_properties(vm_properties)}.to raise_error(
            /Missing VM cloud properties: 'ram', 'ephemeral_disk_size'/)
        end
      end
    end

    describe '#attach_disk' do
      let(:agent_env_hash) { { 'disks' => { 'persistent' => { 'disk-cid' => 'fake-device-number' } } } }
      let(:vm_location) { double(:vm_location) }
      let(:datastore_with_disk) { instance_double('VSphereCloud::Resources::Datastore', name: 'datastore-with-disk')}
      let(:datastore_without_disk) { instance_double('VSphereCloud::Resources::Datastore', name: 'datastore-without-disk')}
      let(:disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: datastore_with_disk, folder: 'fake-folder') }

      before do
        allow(datacenter).to receive(:persistent_pattern)
          .and_return(/datastore\-.*/)
        allow(datacenter).to receive(:accessible_datastores_hash)
          .and_return({
            'datastore-with-disk' => {
              free_space: 2048,
            },
            'datastore-without-disk' => {
              free_space: 4096,
            },
            'inaccessible-datastore' => {
              free_space: 4096,
            }
          })
        allow(datacenter).to receive(:accessible_datastores_hash)
          .and_return({
            'datastore-with-disk' => {
              free_space: 2048,
            },
            'datastore-without-disk' => {
              free_space: 4096,
            },
          })
        allow(datacenter).to receive(:find_datastore)
          .with('datastore-with-disk')
          .and_return(datastore_with_disk)
        allow(datacenter).to receive(:find_datastore)
          .with('datastore-without-disk')
          .and_return(datastore_without_disk)

        allow(vm_provider).to receive(:find)
          .with('fake-vm-cid')
          .and_return(vm)
        allow(datacenter).to receive(:find_disk)
          .with('disk-cid')
          .and_return(disk)

        allow(agent_env).to receive(:get_current_env).and_return(agent_env_hash)

        allow(vsphere_cloud).to receive(:get_vm_location).and_return(vm_location)
      end

      context 'when disk is in a datastore accessible to VM' do
        before do
          allow(vm).to receive(:accessible_datastore_names).and_return(['datastore-with-disk'])
        end

        it 'attaches the existing persistent disk' do
          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number'))
          end
          expect(agent_env).to receive(:set_env) do|env_vm, env_location, env|
            expect(env_vm).to eq(vm_mob)
            expect(env_location).to eq(vm_location)
            expect(env['disks']['persistent']['disk-cid']).to eq('some-unit-number')
          end

          vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
        end

        it 'attaches the existing persistent disk with encoded metadata' do
          metadata_hash = {target_datastore_pattern: '.*'}
          encoded_metadata = Base64.urlsafe_encode64(metadata_hash.to_json)
          disk_cid_with_metadata = "disk-cid.#{encoded_metadata}"

          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number'))
          end
          expect(agent_env).to receive(:set_env) do|env_vm, env_location, env|
            expect(env_vm).to eq(vm_mob)
            expect(env_location).to eq(vm_location)
            expect(env['disks']['persistent'][disk_cid_with_metadata]).to eq('some-unit-number')
          end

          vsphere_cloud.attach_disk('fake-vm-cid', disk_cid_with_metadata)
        end
      end

      context 'when disk is not in a datastore accessible to VM' do
        let(:moved_disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: datastore_without_disk, folder: 'fake-folder') }

        before do
          allow(vm).to receive(:accessible_datastore_names).and_return(['datastore-without-disk'])
        end

        it 'moves the disk to an accessible datastore and attaches it' do
          expect(datacenter).to receive(:move_disk_to_datastore)
            .with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk)
            .with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number')))
          expect(agent_env).to receive(:set_env) do|env_vm, env_location, env|
            expect(env_vm).to eq(vm_mob)
            expect(env_location).to eq(vm_location)
            expect(env['disks']['persistent']['disk-cid']).to eq('some-unit-number')
          end

          vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
        end
      end

      context 'when disk is not in a persistent datastore' do
        let(:moved_disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: datastore_without_disk, folder: 'fake-folder') }

        before do
          allow(datacenter).to receive(:persistent_pattern)
            .and_return(/datastore\-without\-disk/)
          allow(vm).to receive(:accessible_datastore_names).and_return(['datastore-with-disk', 'datastore-without-disk'])
        end

        it 'moves the disk to a persistent datastore and attaches it' do
          expect(datacenter).to receive(:move_disk_to_datastore)
            .with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk)
            .with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number')))
          expect(agent_env).to receive(:set_env) do|env_vm, env_location, env|
            expect(env_vm).to eq(vm_mob)
            expect(env_location).to eq(vm_location)
            expect(env['disks']['persistent']['disk-cid']).to eq('some-unit-number')
          end

          vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
        end
      end

      context 'when a persistent disk pattern is encoded into the disk cid' do
        let(:target_datastore) { instance_double('VSphereCloud::Resources::Datastore', name: 'target-datastore')}
        let(:moved_disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: target_datastore, folder: 'fake-folder') }

        before do
          allow(datacenter).to receive(:accessible_datastores_hash)
            .and_return({
              'target-datastore' => {
                free_space: 4096,
              },
              'current-datastore' => {
                free_space: 4096,
              },
            })

          allow(vm).to receive(:accessible_datastore_names).and_return(['target-datastore', 'current-datastore'])
        end

        it 'extracts the pattern and uses it for datastore picking' do
          expect(datacenter).to receive(:find_datastore)
              .with('target-datastore')
              .and_return(target_datastore)

          expect(datacenter).to receive(:move_disk_to_datastore)
            .with(disk, target_datastore)
            .and_return(moved_disk)

          allow(vm).to receive(:attach_disk)
            .with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number')))
          allow(agent_env).to receive(:set_env)

          metadata_hash = { target_datastore_pattern: "^(target\\-datastore)$" }
          expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

          director_disk_cid = "disk-cid.#{expected_pattern}"

          vsphere_cloud.attach_disk('fake-vm-cid', director_disk_cid)
        end
      end
    end

    describe '#delete_vm' do
      before do
        allow(vm).to receive(:persistent_disks).and_return([])
        allow(vm).to receive(:cdrom).and_return(nil)
      end

      it 'deletes vm' do
        expect(vm).to receive(:power_off)
        expect(vm).to receive(:delete)
        vsphere_cloud.delete_vm('vm-id')
      end

      context 'when vm has persistent disks' do
        let(:disk) { instance_double('VimSdk::Vim::Vm::Device::VirtualDisk', backing: double(:backing, file_name: '[datastore] fake-file_name')) }
        before {
          allow(vm).to receive(:persistent_disks).and_return([disk])
        }

        it 'detaches persistent disks' do
          expect(vm).to receive(:detach_disks).with([disk])
          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)
          vsphere_cloud.delete_vm('vm-id')
        end
      end

      context 'vm has cdrom' do
        let(:cdrom) { instance_double('VimSdk::Vim::Vm::Device::VirtualCdrom') }
        before { allow(vm).to receive(:cdrom).and_return(cdrom) }

        it 'cleans the agent environment, before deleting the vm' do
          expect(agent_env).to receive(:clean_env).with(vm_mob).ordered

          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)

          vsphere_cloud.delete_vm('vm-id')
        end
      end
    end

    describe '#detach_disk' do
      context 'disk is attached' do
        let(:attached_disk) { instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, key: 'disk-key') }

        let(:vm_location) do
          {
            datacenter: 'fake-datacenter-name',
            datastore: 'fake-datastore-name',
            vm: 'fake-vm-name'
          }
        end

        let(:env) do
          {'disks' => {'persistent' => {'disk-cid' => 'fake-data'}}}
        end

        before do
          allow(vsphere_cloud).to receive(:get_vm_location).and_return(vm_location)
          allow(agent_env).to receive(:get_current_env).with(vm_mob, 'fake-datacenter-name').
              and_return(env)
          allow(vm).to receive(:disk_by_cid).with('disk-cid').and_return(attached_disk)
        end

        it 'updates VM with new settings' do
          expect(agent_env).to receive(:set_env).with(
              vm_mob,
              vm_location,
              {'disks' => {'persistent' => {}}}
            )
          expect(vm).to receive(:detach_disks).with([attached_disk])
          vsphere_cloud.detach_disk('vm-id', 'disk-cid')
        end

        context 'when old settings do not contain disk to be detached' do
          let(:env) do
            {'disks' => {'persistent' => {}}}
          end

          it 'does not update VM with new setting' do
            expect(agent_env).to_not receive(:set_env)
            expect(vm).to receive(:detach_disks).with([attached_disk])
            vsphere_cloud.detach_disk('vm-id', 'disk-cid')
          end
        end

        context 'when director disk cid contains metadata' do
          let(:disk_cid_with_metadata) do
            metadata_hash = {target_datastore_pattern:'^(target\\-datastore)$'}
            encoded_data = Base64.urlsafe_encode64(metadata_hash.to_json)
            "disk-cid.#{encoded_data}"
          end
          let(:env) do
            {'disks' => {'persistent' => { disk_cid_with_metadata => 'fake-device-number' }}}
          end

          it 'extracts the vSphere cid from the director disk cid and uses it' do
            expect(agent_env).to receive(:set_env).with(
              vm_mob,
              vm_location,
              {'disks' => {'persistent' => {}}}
            )
            allow(vm).to receive(:disk_by_cid).and_return(attached_disk)
            allow(vm).to receive(:detach_disks)

            vsphere_cloud.detach_disk('vm-id', disk_cid_with_metadata)

            expect(vm).to have_received(:disk_by_cid).with('disk-cid')
          end
        end

      end

      context 'disk is not attached' do
        before do
          allow(vm).to receive(:disk_by_cid).with('disk-cid').and_return(nil)
        end
        it 'raises an error' do
          expect{
            vsphere_cloud.detach_disk('vm-id', 'disk-cid')
          }.to raise_error Bosh::Clouds::DiskNotAttached
        end
      end
    end

    describe '#configure_networks' do
      it 'raises a NotSupported exception' do
        expect {
          vsphere_cloud.configure_networks("i-foobar", {})
        }.to raise_error Bosh::Clouds::NotSupported
      end
    end

    describe '#delete_disk' do
      before { allow(datacenter).to receive(:mob).and_return('datacenter-mob') }

      context 'when disk is found' do
        let(:disk) { instance_double('VSphereCloud::Resources::PersistentDisk', path: 'disk-path') }
        before do
          allow(datacenter).to receive(:find_disk).with('fake-disk-uuid').and_return(disk)
        end

        it 'deletes disk' do
          expect(vcenter_client).to receive(:delete_disk).with('datacenter-mob', 'disk-path')
          vsphere_cloud.delete_disk('fake-disk-uuid')
        end

        context 'when a persistent disk pattern is encoded into the director disk cid' do
          it 'removes the suffix before searching the disk' do
            allow(datacenter).to receive(:find_disk).and_return(disk)
            allow(vcenter_client).to receive(:delete_disk)

            metadata_hash = {target_datastore_pattern:'^(target\\-datastore)$'}
            expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

            vsphere_cloud.delete_disk("disk-cid.#{expected_pattern}")

            expect(datacenter).to have_received(:find_disk).with('disk-cid')
          end
        end
      end

      context 'when disk is not found' do
        before do
          allow(datacenter).to receive(:find_disk).
            with('fake-disk-uuid').
            and_raise Bosh::Clouds::DiskNotFound.new(false)
        end

        it 'raises an error' do
          expect {
            vsphere_cloud.delete_disk('fake-disk-uuid')
          }.to raise_error Bosh::Clouds::DiskNotFound
        end
      end
    end

    describe '#create_disk' do
      let(:accessible_datastores_hash) do
        {
          'small-ds' => {
            free_space: 2048,
          },
          'large-ds' => {
            free_space: 4096,
          },
        }
      end
      let(:datastore) { double(:datastore, name: 'fake-datastore') }
      let(:disk) do
        Resources::PersistentDisk.new(
          cid: 'fake-disk-cid',
          size_in_mb: 1024*1024,
          datastore: datastore,
          folder: 'fake-folder',
        )
      end

      before do
        allow(datacenter).to receive(:persistent_pattern)
          .and_return('small-ds')
        allow(datacenter).to receive(:accessible_datastores_hash)
          .and_return(accessible_datastores_hash)
        allow(datacenter).to receive(:find_datastore)
          .with('small-ds')
          .and_return(datastore)
      end

      it 'creates disk via datacenter' do
        expect(datacenter).to receive(:create_disk)
          .with(datastore, 1024, default_disk_type)
          .and_return(disk)

        disk_cid = vsphere_cloud.create_disk(1024, {})
        expect(disk_cid).to eq('fake-disk-cid')
      end

      context 'when global default_disk_type is set and no disk_pool type is set' do
        let(:default_disk_type) { 'fake-global-type' }
        it 'creates disk with the specified default type' do
          expect(datacenter).to receive(:create_disk)
                                  .with(datastore, 1024, 'fake-global-type')
                                  .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when both global default_disk_type is set and disk_pool type is set' do
        let(:default_disk_type) { 'fake-global-type' }
        it 'create disk with the specified disk_pool type' do
          expect(datacenter).to receive(:create_disk)
                                  .with(datastore, 1024, 'fake-disk-pool-type')
                                  .and_return(disk)
          disk_cid = vsphere_cloud.create_disk(1024, {'type' => 'fake-disk-pool-type'})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when no global default_disk_type is set and disk_pool type is set' do
        it 'creates disk with the specified disk_pool type' do
          expect(datacenter).to receive(:create_disk)
            .with(datastore, 1024, 'fake-disk-pool-type')
            .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {'type' => 'fake-disk-pool-type'})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when vm_cid is provided' do
        before do
          allow(vm_provider).to receive(:find)
            .with('fake-vm-cid')
            .and_return(vm)
          allow(vm).to receive(:accessible_datastore_names)
            .and_return(['small-ds'])
        end

        it 'creates disk in vm cluster' do
          expect(datacenter).to receive(:create_disk)
            .with(datastore, 1024, default_disk_type)
            .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {}, 'fake-vm-cid')
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when disk_pools.cloud_properties.datastores is provided' do
        let(:small_datastore) { double(:datastore, name: 'small-ds') }
        let(:large_datastore) { double(:datastore, name: 'large-ds') }
        let(:cloud_properties) { { 'datastores' => ['small-ds', 'large-ds'] } }

        before(:each) do
          allow(datacenter).to receive(:find_datastore)
            .with('small-ds')
            .and_return(small_datastore)
          allow(datacenter).to receive(:find_datastore)
            .with('large-ds')
            .and_return(large_datastore)
          allow(datacenter).to receive(:create_disk)
            .with(small_datastore, 1024, default_disk_type)
            .and_return(disk)
          allow(datacenter).to receive(:create_disk)
            .with(large_datastore, 1024, default_disk_type)
            .and_return(disk)
        end

        it 'creates the disk in the picked datastore' do
          disk_cid = vsphere_cloud.create_disk(1024, cloud_properties)
          expect(disk_cid).to start_with('fake-disk-cid')
        end

        it 'appends the datastores as base64 encoded metadata to the cid' do
          metadata_hash = {target_datastore_pattern: '^(small\\-ds|large\\-ds)$'}
          expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

          disk_cid = vsphere_cloud.create_disk(1024, cloud_properties)

          expect(disk_cid).to eq("fake-disk-cid.#{expected_pattern}")
        end
      end
    end

    describe '#reboot_vm' do
      it 'logs the powerstate if the machine was not powered on' do
        allow(vm).to receive(:powered_on?).and_return(false)
        allow(vm).to receive(:power_state).and_return('foo')
        allow(vm).to receive(:reboot)
        vsphere_cloud.reboot_vm('vm-id')
      end

      context 'when the soft reboot fails' do
        before do
          allow(vm).to receive(:reboot).and_raise(StandardError.new('my custom reboot error'))
          expect(logger).to receive(:error).with(/my custom reboot error/)
        end

        context 'when the machine was powered on' do
          before{ allow(vm).to receive(:powered_on?).and_return(true) }

          it 'attempts to shut down the machine before re-powering it on' do
            expect(vm).to receive(:power_off).ordered
            expect(vm).to receive(:power_on).ordered
            vsphere_cloud.reboot_vm('vm-id')
          end
        end

        context 'when the machine was powered off' do
          before do
            allow(vm).to receive(:powered_on?).and_return(false)
            allow(vm).to receive(:power_state)
          end

          it 'attempts to start the machine if it is not powered on' do
            expect(vm).to_not receive(:power_off)
            expect(vm).to receive(:power_on).ordered
            vsphere_cloud.reboot_vm('vm-id')
          end
        end
      end
    end

    describe '#set_vm_metadata' do
      it 'sets the metadata as custom fields on the VM' do
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'key', 'value')
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'key', 'other-value')
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'other-key', 'value')
        vsphere_cloud.set_vm_metadata(vm.cid, {'key' => 'value'})
        vsphere_cloud.set_vm_metadata(vm.cid, {'key' => 'other-value', 'other-key' => 'value'})
      end
    end

    describe '#terminate_threads_and_logout' do
      it 'terminates the thread and logs out the client' do
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once
        vsphere_cloud.cleanup
      end

      it 'does not raise an error when it\'s called twice in a row' do
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once
        vsphere_cloud.cleanup
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once.and_raise(VSphereCloud::VCenterClient::NotLoggedInException)
        vsphere_cloud.cleanup
      end
    end
  end
end
