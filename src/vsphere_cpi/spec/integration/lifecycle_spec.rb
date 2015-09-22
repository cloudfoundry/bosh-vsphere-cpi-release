require 'spec_helper'
require 'tempfile'
require 'yaml'

describe VSphereCloud::Cloud, external_cpi: false do
  before(:all) do
    @host = ENV.fetch('BOSH_VSPHERE_CPI_HOST')
    @user = ENV.fetch('BOSH_VSPHERE_CPI_USER')
    @password = ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD')
    @admin_user = ENV.fetch('BOSH_VSPHERE_CPI_ADMIN_USER')
    @admin_password = ENV.fetch('BOSH_VSPHERE_CPI_ADMIN_PASSWORD')
    @vlan = ENV.fetch('BOSH_VSPHERE_VLAN')
    @stemcell_path = ENV.fetch('BOSH_VSPHERE_STEMCELL')

    @second_datastore_within_cluster = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_DATASTORE')
    @second_resource_pool_within_cluster = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    @datacenter_name = ENV.fetch('BOSH_VSPHERE_CPI_DATACENTER')
    @vm_folder = ENV.fetch('BOSH_VSPHERE_CPI_VM_FOLDER')
    @template_folder = ENV.fetch('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER')
    @disk_path = ENV.fetch('BOSH_VSPHERE_CPI_DISK_PATH')
    @datastore_pattern = ENV.fetch('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @local_datastore_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN')
    @persistent_datastore_pattern = ENV.fetch('BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN')
    @cluster = ENV.fetch('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_RESOURCE_POOL')

    @second_cluster = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_resource_pool_name = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')
    @second_cluster_datastore = ENV.fetch('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE')

    config = VSphereSpecConfig.new
    config.logger = Logger.new(STDOUT)
    config.logger.level = Logger::DEBUG
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)

    @local_disk_cpi_options = cpi_options(
      datastore_pattern: @local_datastore_pattern,
      persistent_datastore_pattern: @persistent_datastore_pattern
    )
    LifecycleHelpers.verify_local_disk_infrastructure(@local_disk_cpi_options)
    LifecycleHelpers.verify_user_has_limited_permissions(cpi_options)

    Dir.mktmpdir do |temp_dir|
      output = `tar -C #{temp_dir} -xzf #{@stemcell_path} 2>&1`
      raise "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
      cpi = described_class.new(cpi_options)
      @stemcell_id = cpi.create_stemcell("#{temp_dir}/image", nil)
    end
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

  subject(:cpi) { described_class.new(cpi_options) }

  after(:all) {
    cpi = described_class.new(cpi_options)
    cpi.delete_stemcell(@stemcell_id) if @stemcell_id
  }

  describe "deleting things that do not exist" do
    it "raises the appropriate Clouds::Error" do
      expect {
        cpi.delete_vm('fake-vm-cid')
      }.to raise_error(Bosh::Clouds::VMNotFound)

      expect {
        cpi.delete_disk('fake-disk-cid')
      }.to raise_error(Bosh::Clouds::DiskNotFound)
    end
  end

  def network_spec
    {
      'static' => {
        'ip' => '169.254.1.1',
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => @vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  def vm_lifecycle(disk_locality, resource_pool)
    @vm_id = cpi.create_vm(
      'agent-007',
      @stemcell_id,
      resource_pool,
      network_spec,
      disk_locality,
      {'key' => 'value'}
    )

    expect(@vm_id).to_not be_nil
    expect(cpi.has_vm?(@vm_id)).to be(true)

    yield if block_given?

    metadata = {deployment: 'deployment', job: 'cpi_spec', index: '0'}
    cpi.set_vm_metadata(@vm_id, metadata)

    @disk_id = cpi.create_disk(2048, {}, @vm_id)
    expect(@disk_id).to_not be_nil

    cpi.attach_disk(@vm_id, @disk_id)
    expect(cpi.has_disk?(@disk_id)).to be(true)

    network_spec['static']['ip'] = '169.254.1.2'

    cpi.configure_networks(@vm_id, network_spec)

    metadata[:bosh_data] = 'bosh data'
    metadata[:instance_id] = 'instance'
    metadata[:agent_id] = 'agent'
    metadata[:director_name] = 'Director'
    metadata[:director_uuid] = '6d06b0cc-2c08-43c5-95be-f1b2dd247e18'

    expect {
      cpi.snapshot_disk(@disk_id, metadata)
    }.to raise_error Bosh::Clouds::NotImplemented

    expect {
      cpi.delete_snapshot(123)
    }.to raise_error Bosh::Clouds::NotImplemented

    cpi.detach_disk(@vm_id, @disk_id)
  end

  let(:resource_pool) {
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }
  }

  def clean_up_vm_and_disk(cpi)
    cpi.delete_vm(@vm_id) if @vm_id
    @vm_id = nil
    cpi.delete_disk(@disk_id) if @disk_id
    @disk_id = nil
  end

  describe 'lifecycle' do
    before { @vm_id = nil }
    before { @disk_id = nil }
    after { clean_up_vm_and_disk(cpi) }

    context 'without existing disks' do
      it 'should exercise the vm lifecycle' do
        vm_lifecycle([], resource_pool)
      end
    end

    context 'without existing disks and placer' do
      after { clean_up_vm_and_disk(cpi) }

      context 'when resource_pool is set to the first cluster' do
        it 'places vm in first cluster' do
          resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {'resource_pool' => @resource_pool_name}}]}]
          @vm_id = cpi.create_vm(
            'agent-007',
            @stemcell_id,
            resource_pool,
            network_spec
          )

          vm = cpi.vm_provider.find(@vm_id)
          expect(vm.cluster).to eq(@cluster)
          expect(vm.resource_pool).to eq(@resource_pool_name)
        end

        it 'places vm in the specified resource pool' do
          resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {'resource_pool' => @second_resource_pool_within_cluster}}]}]
          @vm_id = cpi.create_vm(
            'agent-007',
            @stemcell_id,
            resource_pool,
            network_spec
          )

          vm = cpi.vm_provider.find(@vm_id)
          expect(vm.cluster).to eq(@cluster)
          expect(vm.resource_pool).to eq(@second_resource_pool_within_cluster)
        end
      end

      context 'when resource_pool is set to the second cluster' do
        subject(:cpi) do
          options = cpi_options(
            datastore_pattern: @second_cluster_datastore,
            persistent_datastore_pattern: @second_cluster_datastore
          )
          described_class.new(options)
        end

        it 'places vm in second cluster' do
          resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@second_cluster => {}}]}]
          vm_lifecycle([], resource_pool)

          vm = cpi.vm_provider.find(@vm_id)
          expect(vm.cluster).to eq(@second_cluster)
        end
      end
    end

    context 'with existing disks' do
      before { @existing_volume_id = cpi.create_disk(2048, {}) }
      after { cpi.delete_disk(@existing_volume_id) if @existing_volume_id }

      it 'should exercise the vm lifecycle' do
        vm_lifecycle([@existing_volume_id], resource_pool)
      end
    end
  end

  describe 'vsphere specific lifecycle' do
    context 'given cpis that are configured to use same cluster but different datastores' do
      let(:first_datastore_cpi) { cpi }

      let(:second_datastore_cpi) do
        options = cpi_options(
          datastore_pattern: @second_datastore_within_cluster,
          persistent_datastore_pattern: @second_datastore_within_cluster
        )
        described_class.new(options)
      end

      before do
        @vm_id = first_datastore_cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [],
          {}
        )

        expect(@vm_id).to_not be_nil
        expect(first_datastore_cpi.has_vm?(@vm_id)).to be(true)

        @disk_id = first_datastore_cpi.create_disk(2048, {}, @vm_id)
        expect(@disk_id).to_not be_nil
        expect(first_datastore_cpi.has_disk?(@disk_id)).to be(true)
        disk = first_datastore_cpi.disk_provider.find(@disk_id)
        expect(disk.datastore.name).to match(@persistent_datastore_pattern)
      end

      after { clean_up_vm_and_disk(first_datastore_cpi) }

      it 'can exercise lifecycle with the cpi configured with a new datastore pattern' do
        # second cpi can see disk in datastore outside of its datastore pattern
        expect(second_datastore_cpi.has_disk?(@disk_id)).to be(true)

        first_datastore_cpi.attach_disk(@vm_id, @disk_id)

        second_datastore_cpi.detach_disk(@vm_id, @disk_id)

        second_datastore_cpi.delete_vm(@vm_id)
        expect {
          first_datastore_cpi.vm_provider.find(@vm_id)
        }.to raise_error(Bosh::Clouds::VMNotFound)
        @vm_id = nil

        second_datastore_cpi.delete_disk(@disk_id)
        expect {
          first_datastore_cpi.disk_provider.find(@disk_id)
        }.to raise_error(Bosh::Clouds::DiskNotFound)
        @disk_id = nil
      end

      it '#attach_disk can move the disk to the new datastore pattern' do
        second_datastore_cpi.attach_disk(@vm_id, @disk_id)

        disk = second_datastore_cpi.disk_provider.find(@disk_id)
        expect(disk.cid).to eq(@disk_id)
        expect(disk.datastore.name).to match(@second_datastore_within_cluster)

        second_datastore_cpi.detach_disk(@vm_id, @disk_id)
      end
    end

    # context 'when datacenter is in folder' do
    #   let(:client) do
    #     VSphereCloud::Client.new("https://#{@host}/sdk/vimService").tap do |client|
    #       client.login(@user, @password, 'en')
    #     end
    #   end
    #
    #   # `admin_client` has more permissions than `client` for setup/teardown
    #   let(:admin_client) do
    #     VSphereCloud::Client.new("https://#{@host}/sdk/vimService").tap do |client|
    #       client.login(@admin_user, @admin_password, 'en')
    #     end
    #   end
    #
    #   let(:datacenter) { client.find_by_inventory_path(@datacenter_name) }
    #   let(:folder_name) { SecureRandom.uuid }
    #   let(:folder) { admin_client.create_folder(folder_name) }
    #   subject(:cpi) do
    #     options = cpi_options(
    #       datacenter_name: "#{folder_name}/#{@datacenter_name}",
    #     )
    #     described_class.new(options)
    #   end
    #
    #   before do
    #     admin_client.move_into_folder(folder, [datacenter])
    #     @vm_id = nil
    #     @disk_id = nil
    #   end
    #
    #   after do
    #     clean_up_vm_and_disk(cpi)
    #     admin_client.move_into_root_folder([datacenter])
    #     admin_client.delete_folder(folder)
    #   end
    #
    #   it 'exercises the vm lifecycle' do
    #     vm_lifecycle([], resource_pool)
    #   end
    # end

    context 'when disk is being re-attached' do
      after { clean_up_vm_and_disk(cpi) }

      it 'does not lock cd-rom' do
        vm_lifecycle([], resource_pool)
        cpi.attach_disk(@vm_id, @disk_id)
        cpi.detach_disk(@vm_id, @disk_id)
      end
    end

    context 'when vm was migrated to another datastore within first cluster' do
      after { clean_up_vm_and_disk(cpi) }
      subject(:cpi) do
        options = cpi_options(
          clusters: [{ @cluster => {'resource_pool' => @resource_pool_name} }]
        )
        described_class.new(options)
      end

      it 'should exercise the vm lifecycle' do
        vm_lifecycle([], resource_pool) do
          vm = cpi.vm_provider.find(@vm_id)

          datastore = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: @second_datastore_within_cluster)
          relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

          task = vm.mob.relocate(relocate_spec, 'defaultPriority')
          cpi.client.wait_for_task(task)
        end
      end
    end

    context 'when disk is in non-accessible datastore' do
      after { clean_up_vm_and_disk(cpi) }

      let(:vm_cluster) { @cluster }
      let(:cpi_for_vm) do
        options = cpi_options
        options['vcenters'].first['datacenters'].first['clusters'] = [
          { vm_cluster => {'resource_pool' => @resource_pool_name} }
        ]
        described_class.new(options)
      end

      let(:cpi_for_non_accessible_datastore) do
        options = cpi_options
        options['vcenters'].first['datacenters'].first.merge!(
          {
            'datastore_pattern' => @second_cluster_datastore,
            'persistent_datastore_pattern' => @second_cluster_datastore,
            'clusters' => [{ @second_cluster => {'resource_pool' => @second_cluster_resource_pool_name} }]
          }
        )
        puts "CPI options #{options}"
        described_class.new(options)
      end

      def find_disk_in_datastore(disk_id, datastore_name)
        datastore_mob = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
        datastore = VSphereCloud::Resources::Datastore.new(datastore_name, datastore_mob, 0, 0)
        cpi.client.find_disk(disk_id, datastore, @disk_path)
      end

      def datastores_accessible_from_cluster(cluster_name)
        cluster = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
        expect(cluster.host.size).to eq(1)
        host = cluster.host.first
        host.datastore.map(&:name)
      end

      def create_vm_with_cpi(cpi_for_vm)
        cpi_for_vm.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [],
          {}
        )
      end

      def verify_disk_is_in_datastores(disk_id, accessible_datastores)
        disk_is_in_accessible_datastore = false
        accessible_datastores.each do |datastore_name|
          disk = find_disk_in_datastore(disk_id, datastore_name)
          unless disk.nil?
            disk_is_in_accessible_datastore = true
            break
          end
        end
        expect(disk_is_in_accessible_datastore).to eq(true)
      end

      it 'creates disk in accessible datastore' do
        accessible_datastores = datastores_accessible_from_cluster(@cluster)
        expect(accessible_datastores).to_not include(@second_cluster_datastore)

        @vm_id = create_vm_with_cpi(cpi_for_vm)
        expect(@vm_id).to_not be_nil

        @disk_id = cpi.create_disk(128, {}, @vm_id)

        verify_disk_is_in_datastores(@disk_id, accessible_datastores)
      end

      it 'migrates disk to accessible datastore' do
        accessible_datastores = datastores_accessible_from_cluster(vm_cluster)
        expect(accessible_datastores).to_not include(@second_cluster_datastore)

        @vm_id = create_vm_with_cpi(cpi_for_vm)
        expect(@vm_id).to_not be_nil
        @disk_id = cpi_for_non_accessible_datastore.create_disk(128, {}, nil)
        disk = find_disk_in_datastore(@disk_id, @second_cluster_datastore)
        expect(disk).to_not be_nil

        cpi.attach_disk(@vm_id, @disk_id)

        verify_disk_is_in_datastores(@disk_id, accessible_datastores)
      end
    end

    context 'when using local storage for the ephemeral storage pattern' do
      let(:local_disk_cpi) { described_class.new(@local_disk_cpi_options) }

      after { clean_up_vm_and_disk(local_disk_cpi) }

      it 'places ephemeral and persistent disks properly' do
        @vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
        vm = local_disk_cpi.vm_provider.find(@vm_id)
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil
        expect(ephemeral_disk.backing.datastore.name).to match(@local_datastore_pattern)

        @disk_id = local_disk_cpi.create_disk(2048, {}, @vm_id)
        expect(@disk_id).to_not be_nil
        disk = local_disk_cpi.disk_provider.find(@disk_id)
        expect(disk.datastore.name).to match(@persistent_datastore_pattern)
        local_disk_cpi.attach_disk(@vm_id, @disk_id)
        expect(local_disk_cpi.has_disk?(@disk_id)).to be(true)
      end
    end

    context 'when stemcell is replicated multiple times' do
      after { clean_up_vm_and_disk(cpi) }

      it 'handles each thread properly' do
        datastore_name = @second_datastore_within_cluster
        datastore_mob = cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
        datastore = VSphereCloud::Resources::Datastore.new(datastore_name, datastore_mob, 0, 0)
        cluster_config = VSphereCloud::ClusterConfig.new(@cluster, {resource_pool: @resource_pool_name})
        @logger = Logger.new(StringIO.new(""))
        datacenter = VSphereCloud::Resources::Datacenter.new({
          client: cpi.client,
          vm_folder: @vm_folder,
          template_folder: @template_folder,
          use_sub_folder: true,
          name: @datacenter_name,
          disk_path: @disk_path,
          ephemeral_pattern: Regexp.new(@datastore_pattern),
          persistent_pattern: Regexp.new(@persistent_datastore_pattern),
          clusters: {@cluster => cluster_config},
          logger: @logger,
          mem_overcommit: 1.0
        })
        vm_cluster = VSphereCloud::Resources::ClusterProvider.new(datacenter, cpi.client, @logger).find(@cluster, cluster_config)
        first_stemcell_vm = nil
        second_stemcell_vm = nil
        third_stemcell_vm = nil
        fourth_stemcell_vm = nil

        # creating four separate threads and cpi instances to validate concurrent stemcell replication
        t1 = Thread.new {
          cpi = described_class.new(cpi_options)
          first_stemcell_vm = cpi.replicate_stemcell(vm_cluster, datastore, @stemcell_id)
        }
        t2 = Thread.new {
          cpi = described_class.new(cpi_options)
          second_stemcell_vm = cpi.replicate_stemcell(vm_cluster, datastore, @stemcell_id)
        }

        t3 = Thread.new {
          cpi = described_class.new(cpi_options)
          third_stemcell_vm = cpi.replicate_stemcell(vm_cluster, datastore, @stemcell_id)
        }

        t4 = Thread.new {
          cpi = described_class.new(cpi_options)
          fourth_stemcell_vm = cpi.replicate_stemcell(vm_cluster, datastore, @stemcell_id)
        }

        t1.join
        expect(first_stemcell_vm).to_not be_nil
        t2.join
        expect(second_stemcell_vm).to_not be_nil
        t3.join
        expect(third_stemcell_vm).to_not be_nil
        t4.join
        expect(fourth_stemcell_vm).to_not be_nil

        local_stemcell_name = "#{@stemcell_id} %2f #{datastore.mob.__mo_id__}"
        found_vm = cpi.client.find_by_inventory_path([datacenter.name, 'vm', datacenter.template_folder.path_components, local_stemcell_name])
        expect(first_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(second_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(third_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(fourth_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
      end
    end
  end
end

class LifecycleHelpers
  class << self
    MISSING_KEY_MESSAGES = {
      'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN' => 'Please ensure you provide a pattern that match datastores that are only accessible by a single host.'
    }

    ALLOWED_PRIVILEGES = [
      'System.Anonymous',
      'System.Read',
      'System.View'
    ]

    def fetch_property(property)
      fail "Missing Environment varibale #{property}: #{MISSING_KEY_MESSAGES[property]}" unless(ENV.has_key?(property))
      ENV[property]
    end

    def verify_local_disk_infrastructure(cpi_options)
      pattern = cpi_options['vcenters'].first['datacenters'].first['datastore_pattern']
      cpi_using_future_version_of_api = VSphereCloud::Cloud.new(cpi_options)
      all_ephemeral_datastores = ephemeral_datastores(cpi_using_future_version_of_api)
      if(all_ephemeral_datastores.empty?)
        fail(
          <<-EOF
No datastores found matching `BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN`(/#{pattern}/).
#{MISSING_KEY_MESSAGES['BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN']}
EOF
        )
      end
      nonlocal_disk_ephemeral_datastores = all_ephemeral_datastores.select { |_, datastore| datastore.mob.summary.multiple_host_access }
      unless (nonlocal_disk_ephemeral_datastores.empty?)
        fail(
          <<-EOF
Some datastores found maching `BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN`(/#{pattern}/)
are configured to allow multiple hosts to access them:
#{nonlocal_disk_ephemeral_datastores}.
#{MISSING_KEY_MESSAGES['BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN']}
        EOF
        )
      end
    end

    def ephemeral_datastores(cpi)
      clusters = cpi.datacenter.clusters
      clusters.inject({}) do |acc, kv|
        cluster = kv.last
        acc.merge!(cluster.ephemeral_datastores)
      end
    end

    def verify_user_has_limited_permissions(cpi_options)
      cpi = VSphereCloud::Cloud.new(cpi_options)
      root_folder = root_folder(cpi)

      authorization_manager = authorization_manager(cpi)
      all_privileges = authorization_manager.privilege_list.map(&:priv_id)

      privileges_response =
        authorization_manager.has_privilege_on_entity(root_folder, current_session_id(cpi), all_privileges)
      actual_privileges = Hash[all_privileges.zip(privileges_response)].select { |_, privelege| privelege }.keys

      if actual_privileges.sort != ALLOWED_PRIVILEGES
        disallowed_privileges = actual_privileges - ALLOWED_PRIVILEGES
        fail "User must have limited permissions on root folder. Disallowed permissions include: #{disallowed_privileges.inspect}"
      end
    end

    def authorization_manager(cpi)
      service_content = cpi.client.service_content
      service_content.authorization_manager
    end

    def root_folder(cpi)
      service_content = cpi.client.service_content
      service_content.root_folder
    end

    def current_session_id(cpi)
      service_content = cpi.client.service_content
      current_session = service_content.session_manager.current_session
      current_session.key
    end
  end
end
