require 'spec_helper'
require 'tempfile'
require 'yaml'

describe VSphereCloud::Cloud, external_cpi: false do
  before(:all) do
    config = VSphereSpecConfig.new
    config.logger = Logger.new(STDOUT)
    config.logger.level = Logger::DEBUG
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)

    @logger = Logger.new(STDOUT)

    @host = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_HOST')
    @user = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_USER')
    @password = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_PASSWORD')
    @vlan = LifecycleHelpers.fetch_property('BOSH_VSPHERE_VLAN')
    @stemcell_path = LifecycleHelpers.fetch_property('BOSH_VSPHERE_STEMCELL')

    @second_datastore_within_cluster = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_DATASTORE')
    @second_resource_pool_within_cluster = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    @datacenter_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_DATACENTER')
    @vm_folder = ENV.fetch('BOSH_VSPHERE_CPI_VM_FOLDER', '')
    @template_folder = ENV.fetch('BOSH_VSPHERE_CPI_TEMPLATE_FOLDER', '')
    @disk_path = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_DISK_PATH')

    @datastore_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_DATASTORE_PATTERN')
    @local_datastore_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN')
    @persistent_datastore_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN')
    @cluster = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_CLUSTER')
    @resource_pool_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_RESOURCE_POOL')

    @second_cluster = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_resource_pool_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')
    @second_cluster_datastore = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE')

    nested_datacenter_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    nested_datacenter_datastore_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    nested_datacenter_cluster_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    nested_datacenter_resource_pool_name = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL')
    @nested_datacenter_vlan = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')

    @vsphere_version = LifecycleHelpers.fetch_optional_property('BOSH_VSPHERE_VERSION')

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

    LifecycleHelpers.verify_vsphere_version(cpi_options, @vsphere_version)
    LifecycleHelpers.verify_datacenter_exists(cpi_options, 'BOSH_VSPHERE_CPI_DATACENTER')
    LifecycleHelpers.verify_vlan(cpi_options, @vlan, 'BOSH_VSPHERE_VLAN')
    LifecycleHelpers.verify_user_has_limited_permissions(cpi_options)

    datacenter = described_class.new(cpi_options).datacenter
    LifecycleHelpers.verify_cluster(datacenter, @cluster, 'BOSH_VSPHERE_CPI_CLUSTER')
    LifecycleHelpers.verify_resource_pool(datacenter.find_cluster(@cluster), @resource_pool_name, 'BOSH_VSPHERE_CPI_RESOURCE_POOL')
    LifecycleHelpers.verify_cluster(datacenter, @second_cluster, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    LifecycleHelpers.verify_resource_pool(datacenter.find_cluster(@second_cluster), @second_cluster_resource_pool_name, 'BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL')

    second_resource_pool_datacenter = described_class.new(@second_resource_pool_cpi_options).datacenter
    LifecycleHelpers.verify_resource_pool(second_resource_pool_datacenter.find_cluster(@cluster), @second_resource_pool_within_cluster, 'BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL')

    LifecycleHelpers.verify_datastore_within_cluster(
      described_class.new(@local_disk_cpi_options).datacenter,
      'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN',
      @local_datastore_pattern,
      @cluster
    )

    LifecycleHelpers.verify_local_disk_infrastructure(@local_disk_cpi_options, 'BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN')
    LifecycleHelpers.verify_datacenter_exists(@nested_datacenter_cpi_options, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    LifecycleHelpers.verify_datacenter_is_nested(@nested_datacenter_cpi_options, nested_datacenter_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER')
    nested_datacenter = described_class.new(@nested_datacenter_cpi_options).datacenter
    LifecycleHelpers.verify_cluster(nested_datacenter, nested_datacenter_cluster_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER')
    LifecycleHelpers.verify_datastore_within_cluster(
      nested_datacenter,
      'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN',
      nested_datacenter_datastore_pattern,
      nested_datacenter_cluster_name
    )

    LifecycleHelpers.verify_resource_pool(nested_datacenter.find_cluster(nested_datacenter_cluster_name), nested_datacenter_resource_pool_name, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN')
    LifecycleHelpers.verify_vlan(@nested_datacenter_cpi_options, @nested_datacenter_vlan, 'BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN')

    LifecycleHelpers.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @datastore_pattern,
      @cluster
    )

    LifecycleHelpers.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
      @cluster
    )

    LifecycleHelpers.verify_datastore_within_cluster(
      second_datastore_cpi.datacenter,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE',
      @second_datastore_within_cluster,
      @cluster
    )

    cpi_instance = described_class.new(cpi_options)
    LifecycleHelpers.verify_non_overlapping_datastores(
      cpi_instance,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      cpi_instance,
      @persistent_datastore_pattern,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN'
    )

    LifecycleHelpers.verify_non_overlapping_datastores(
      described_class.new(cpi_options),
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      second_datastore_cpi,
      @second_datastore_within_cluster,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )

    LifecycleHelpers.verify_datastore_within_cluster(
      datacenter,
      'BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE',
      @second_cluster_datastore,
      @second_cluster
    )

    LifecycleHelpers.verify_datastore_pattern_available_to_all_hosts(
      cpi_options,
      'BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN',
      @persistent_datastore_pattern,
    )

    @cpi = described_class.new(cpi_options)

    Dir.mktmpdir do |temp_dir|
      stemcell_image = LifecycleHelpers.stemcell_image(@stemcell_path, temp_dir)
      @stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
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

  class VMWareToolsNotFound < StandardError; end

  def wait_for_vmware_tools(cpi, vm_name)
    vm_mob = cpi.vm_provider.find(vm_name).mob
    raise VMWareToolsNotFound if vm_mob.guest.ip_address.nil?
    true
  end

  after(:all) {
    @cpi.delete_stemcell(@stemcell_id) if @stemcell_id
  }

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.1.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vlan) { @vlan }

  let(:resource_pool) do
    {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  def second_datastore_cpi
    options = cpi_options(
      datastore_pattern: @second_datastore_within_cluster,
      persistent_datastore_pattern: @second_datastore_within_cluster
    )
    described_class.new(options)
  end

  describe 'avoiding the creation of vms with duplicate IP addresses' do
    it 'raises an error in create_vm if the ip address is in use' do
      begin
        test_vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [],
          {'key' => 'value'}
        )

        desired_ip = network_spec['static']['ip']
        network_name = network_spec['static']['cloud_properties']['name']
        # wait for vsphere tools to be detected by vCenter :(

        start_time = Time.now
        @logger.info("Waiting for VMWare Tools on the VM...")
        Bosh::Common.retryable(tries: 20, on: VMWareToolsNotFound) do
          wait_for_vmware_tools(@cpi, test_vm_id)
        end
        @logger.info("Finished waiting for VMWare Tools. Took #{Time.now - start_time} seconds.")

        duplicate_ip_vm_id = nil
        expected_ip_conflicts = [{vm_name: test_vm_id, network_name: network_name, ip: desired_ip}]
        expect {
          duplicate_ip_vm_id = @cpi.create_vm(
            'agent-elba',
            @stemcell_id,
            resource_pool,
            network_spec,
            [],
            {'key' => 'value'}
          )
        }.to raise_error "Cannot create new VM because of IP conflicts with other VMs on the same networks: #{expected_ip_conflicts}"
      ensure
        @cpi.delete_vm(test_vm_id) if test_vm_id
        @cpi.delete_vm(duplicate_ip_vm_id) if duplicate_ip_vm_id
      end

    end
  end

  describe 'deleting things that do not exist' do
    it 'raises the appropriate Clouds::Error' do
      expect {
        @cpi.delete_vm('fake-vm-cid')
      }.to raise_error(Bosh::Clouds::VMNotFound)

      expect {
        @cpi.delete_disk('fake-disk-cid')
      }.to raise_error(Bosh::Clouds::DiskNotFound)
    end
  end

  describe 'lifecycle' do
    context 'without existing disks' do
      it 'should exercise the vm lifecycle' do
        vm_lifecycle(@cpi, [], resource_pool, network_spec)
      end
    end

    context 'without existing disks and placer' do
      context 'when resource_pool is set to the first cluster' do
        it 'places vm in first cluster' do
          begin
            resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {'resource_pool' => @resource_pool_name}}]}]
            vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec
            )

            vm = @cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster)
            expect(vm.resource_pool).to eq(@resource_pool_name)
          ensure
            @cpi.delete_vm(vm_id) if vm_id
          end
        end

        it 'places vm in the specified resource pool' do
          begin
            resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {'resource_pool' => @second_resource_pool_within_cluster}}]}]
            vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec
            )

            vm = @cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster)
            expect(vm.resource_pool).to eq(@second_resource_pool_within_cluster)
          ensure
            @cpi.delete_vm(vm_id) if vm_id
          end
        end
      end

      context 'when resource_pool is set to the second cluster' do
        it 'places vm in second cluster' do
          options = cpi_options(
            datastore_pattern: @second_cluster_datastore,
            persistent_datastore_pattern: @second_cluster_datastore
          )
          second_cluster_cpi = described_class.new(options)
          resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@second_cluster => {}}]}]
          vm_lifecycle(second_cluster_cpi, [], resource_pool, network_spec) do |vm_id|
            vm = second_cluster_cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@second_cluster)
          end
        end
      end
    end

    context 'with existing disks' do
      before { @existing_volume_id = @cpi.create_disk(2048, {}) }
      after { @cpi.delete_disk(@existing_volume_id) if @existing_volume_id }

      it 'should exercise the vm lifecycle' do
        vm_lifecycle(@cpi, [@existing_volume_id], resource_pool, network_spec)
      end
    end
  end

  describe 'vSphere specific lifecycle' do
    context 'given a cpi that is configured without specifying the vSphere resource pool' do
      let(:second_cpi) do
        options = cpi_options(
          clusters: [@cluster]
        )
        described_class.new(options)
      end

      it 'can still find a vm created by a cpi configured with a vSphere resource pool' do
        begin
          vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            resource_pool,
            network_spec,
            [],
            {}
          )

          expect(vm_id).to_not be_nil
          expect(second_cpi.has_vm?(vm_id)).to be(true)
        ensure
          @cpi.delete_vm(vm_id) if vm_id
        end
      end

      it 'can still find the stemcell created by a cpi configured with a vSphere resource pool' do
        expect(second_cpi.stemcell_vm(@stemcell_id)).to_not be_nil
      end

      it 'should exercise the vm lifecycle' do
        vm_lifecycle(second_cpi, [], resource_pool, network_spec)
      end

      context 'when replicating stemcells across datastores' do
        it 'should not replicate the stemcell if a suitable replica already exists in a subfolder' do
          begin
            orig_stemcell_id = nil
            Dir.mktmpdir do |temp_dir|
              stemcell_image = LifecycleHelpers.stemcell_image(@stemcell_path, temp_dir)
              orig_stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
            end

            second_datastore = @cpi.datacenter.all_datastores[@second_datastore_within_cluster]

            replicated_stemcell = @cpi.replicate_stemcell(@cpi.datacenter.clusters[@cluster], second_datastore, orig_stemcell_id)
            expect(replicated_stemcell).to_not be_nil

            expect(@cpi.client.find_all_stemcell_replicas(@cpi.datacenter, orig_stemcell_id).size).to eq(2)
            expect(second_cpi.client.find_all_stemcell_replicas(second_cpi.datacenter, orig_stemcell_id).size).to eq(2)

            second_replicated_stemcell = second_cpi.replicate_stemcell(second_cpi.datacenter.clusters[@cluster], second_datastore, orig_stemcell_id)

            expect(@cpi.client.find_all_stemcell_replicas(@cpi.datacenter, orig_stemcell_id).size).to eq(2)
            expect(second_cpi.client.find_all_stemcell_replicas(second_cpi.datacenter, orig_stemcell_id).size).to eq(2)
          ensure
            @cpi.delete_stemcell(orig_stemcell_id)
            begin
              @logger.info("Deleting any leftover stemcells after failure using second cpi...")
              second_cpi.delete_stemcell(orig_stemcell_id)
            rescue
            end
          end
        end

        it 'should clean up any replicated stemcells regardless of folder' do
          begin
            orig_stemcell_id = nil
            Dir.mktmpdir do |temp_dir|
              stemcell_image = LifecycleHelpers.stemcell_image(@stemcell_path, temp_dir)
              orig_stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
            end

            second_datastore = second_cpi.datacenter.all_datastores[@second_datastore_within_cluster]

            replicated_stemcell = second_cpi.replicate_stemcell(second_cpi.datacenter.clusters[@cluster], second_datastore, orig_stemcell_id)
            expect(replicated_stemcell).to_not be_nil

            expect(second_cpi.client.find_all_stemcell_replicas(second_cpi.datacenter, orig_stemcell_id).size).to eq(2)

            @cpi.delete_stemcell(orig_stemcell_id)

            expect(second_cpi.client.find_all_stemcell_replicas(second_cpi.datacenter, orig_stemcell_id)).to be_empty
          ensure
            begin
              @logger.info("Deleting any leftover stemcells after failure using default cpi...")
              @cpi.delete_stemcell(orig_stemcell_id)
            rescue
            end
            begin
              @logger.info("Deleting any leftover stemcells after failure using second cpi...")
              second_cpi.delete_stemcell(orig_stemcell_id)
            rescue
            end
          end
        end
      end
    end

    context 'given cpis that are configured to use same cluster but different datastores' do
      let(:first_datastore_cpi) do
        options = cpi_options(persistent_datastore_pattern: @datastore_pattern)
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
        expect(disk.datastore.name).to match(@datastore_pattern)
      end

      after {
        first_datastore_cpi.delete_vm(@vm_id) if @vm_id
        @vm_id = nil
        first_datastore_cpi.delete_disk(@disk_id) if @disk_id
        @disk_id = nil
      }

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
        if LifecycleHelpers.any_vsan?(@cpi, @datastore_pattern) || LifecycleHelpers.is_vsan?(@cpi, @second_datastore_within_cluster)
          skip 'Moving disks between with a vsan datastore is not yet supported'
        end

        second_datastore_cpi.attach_disk(@vm_id, @disk_id)

        disk = second_datastore_cpi.disk_provider.find(@disk_id)
        expect(disk.cid).to eq(@disk_id)
        expect(disk.datastore.name).to match(@second_datastore_within_cluster)

        second_datastore_cpi.detach_disk(@vm_id, @disk_id)
      end
    end

    context 'when datacenter is in folder' do
      let(:vlan) { @nested_datacenter_vlan }

      it 'exercises the vm lifecycle' do
        begin
          nested_datacenter_cpi = described_class.new(@nested_datacenter_cpi_options)
          nested_datacenter_stemcell_id = nil
          Dir.mktmpdir do |temp_dir|
            output = `tar -C #{temp_dir} -xzf #{@stemcell_path} 2>&1`
            raise "Corrupt image, tar exit status: #{$?.exitstatus} output: #{output}" if $?.exitstatus != 0
            nested_datacenter_stemcell_id = nested_datacenter_cpi.create_stemcell("#{temp_dir}/image", nil)
          end

          vm_lifecycle(nested_datacenter_cpi, [], resource_pool, network_spec, nested_datacenter_stemcell_id)
        ensure
          nested_datacenter_cpi.delete_stemcell(nested_datacenter_stemcell_id) if nested_datacenter_stemcell_id
        end
      end
    end

    context 'when disk is being re-attached' do

      it 'does not lock cd-rom' do
        begin
          vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            resource_pool,
            network_spec,
            [],
            {'key' => 'value'}
          )

          expect(vm_id).to_not be_nil
          expect(@cpi.has_vm?(vm_id)).to be(true)

          disk_id = @cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil

          @cpi.attach_disk(vm_id, disk_id)
          @cpi.detach_disk(vm_id, disk_id)
          @cpi.attach_disk(vm_id, disk_id)
          @cpi.detach_disk(vm_id, disk_id)
        ensure
          @cpi.delete_vm(vm_id) if vm_id
          @cpi.delete_disk(disk_id) if disk_id
        end
      end
    end

    context 'when vm was migrated to another datastore within first cluster' do

      it 'should exercise the vm lifecycle' do
        options = cpi_options(
          clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
        )
        one_cluster_cpi = described_class.new(options)
        vm_lifecycle(one_cluster_cpi, [], resource_pool, network_spec) do |vm_id|
          vm = one_cluster_cpi.vm_provider.find(vm_id)

          datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: @second_datastore_within_cluster)
          relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

          task = vm.mob.relocate(relocate_spec, 'defaultPriority')
          one_cluster_cpi.client.wait_for_task(task)
        end
      end
    end

    context 'when disk is in non-accessible datastore' do
      let(:vm_cluster) { @cluster }
      let(:cpi_for_vm) do
        options = cpi_options
        options['vcenters'].first['datacenters'].first['clusters'] = [
          { vm_cluster => {'resource_pool' => @resource_pool_name} }
        ]
        described_class.new(options)
      end

      def find_disk_in_datastore(disk_id, datastore_name)
        datastore_mob = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
        datastore = VSphereCloud::Resources::Datastore.new(datastore_name, datastore_mob, 0, 0)
        @cpi.client.find_disk(disk_id, datastore, @disk_path)
      end

      def datastores_accessible_from_cluster(cluster_name)
        cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
        cluster.datastore.map(&:name)
      end

      def create_vm_with_cpi(cpi)
        cpi.create_vm(
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
        begin
          accessible_datastores = datastores_accessible_from_cluster(@cluster)
          expect(accessible_datastores).to_not include(@second_cluster_datastore)

          vm_id = create_vm_with_cpi(cpi_for_vm)
          expect(vm_id).to_not be_nil

          disk_id = @cpi.create_disk(128, {}, vm_id)

          verify_disk_is_in_datastores(disk_id, accessible_datastores)
        ensure
          @cpi.delete_vm(vm_id) if vm_id
          @cpi.delete_disk(disk_id) if disk_id
        end
      end

      it 'migrates disk to accessible datastore' do
        if LifecycleHelpers.any_vsan?(@cpi, @datastore_pattern) || LifecycleHelpers.is_vsan?(@cpi, @second_cluster_datastore)
          skip 'Moving disks between with a vsan datastore is not yet supported'
        end

        begin
          options = cpi_options
          options['vcenters'].first['datacenters'].first.merge!(
            {
              'datastore_pattern' => @second_cluster_datastore,
              'persistent_datastore_pattern' => @second_cluster_datastore,
              'clusters' => [{@second_cluster => {'resource_pool' => @second_cluster_resource_pool_name}}]
            }
          )
          cpi_for_non_accessible_datastore = described_class.new(options)

          accessible_datastores = datastores_accessible_from_cluster(vm_cluster)
          expect(accessible_datastores).to_not include(@second_cluster_datastore)

          vm_id = create_vm_with_cpi(cpi_for_vm)
          expect(vm_id).to_not be_nil
          disk_id = cpi_for_non_accessible_datastore.create_disk(128, {}, nil)
          disk = find_disk_in_datastore(disk_id, @second_cluster_datastore)
          expect(disk).to_not be_nil

          @cpi.attach_disk(vm_id, disk_id)

          verify_disk_is_in_datastores(disk_id, accessible_datastores)
        ensure
          @cpi.detach_disk(vm_id, disk_id) if disk_id
          @cpi.delete_vm(vm_id) if vm_id
          @cpi.delete_disk(disk_id) if disk_id
        end
      end
    end

    context 'when using local storage for the ephemeral storage pattern' do
      let(:local_disk_cpi) { described_class.new(@local_disk_cpi_options) }

      it 'places ephemeral and persistent disks properly' do
        begin
          vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
          vm = local_disk_cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil
          expect(ephemeral_disk.backing.datastore.name).to match(@local_datastore_pattern)

          disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil
          disk = local_disk_cpi.disk_provider.find(disk_id)
          expect(disk.datastore.name).to match(@persistent_datastore_pattern)
          local_disk_cpi.attach_disk(vm_id, disk_id)
          expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
        ensure
          local_disk_cpi.detach_disk(vm_id, disk_id)
          local_disk_cpi.delete_vm(vm_id) if vm_id
          local_disk_cpi.delete_disk(disk_id) if disk_id
        end
      end
    end

    context 'when stemcell is replicated multiple times' do

      it 'handles each thread properly' do
        datastore_name = @second_datastore_within_cluster
        datastore_mob = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
        datastore = VSphereCloud::Resources::Datastore.new(datastore_name, datastore_mob, 0, 0)
        cluster_config = VSphereCloud::ClusterConfig.new(@cluster, {resource_pool: @resource_pool_name})
        @logger = Logger.new(StringIO.new(""))
        datacenter = VSphereCloud::Resources::Datacenter.new({
          client: @cpi.client,
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
        vm_cluster = VSphereCloud::Resources::ClusterProvider.new(datacenter, @cpi.client, @logger).find(@cluster, cluster_config)
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
        found_vm = @cpi.client.find_by_inventory_path([datacenter.name, 'vm', datacenter.template_folder.path_components, local_stemcell_name])
        expect(first_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(second_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(third_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
        expect(fourth_stemcell_vm.__mo_id__).to eq(found_vm.__mo_id__)
      end
    end
  end

  def vm_lifecycle(cpi, disk_locality, resource_pool, network_spec, stemcell_id = @stemcell_id)
    vm_id = cpi.create_vm(
      'agent-007',
      stemcell_id,
      resource_pool,
      network_spec,
      disk_locality,
      {'key' => 'value'}
    )

    expect(vm_id).to_not be_nil
    expect(cpi.has_vm?(vm_id)).to be(true)

    yield vm_id if block_given?

    metadata = {deployment: 'deployment', job: 'cpi_spec', index: '0'}
    cpi.set_vm_metadata(vm_id, metadata)

    disk_id = cpi.create_disk(2048, {}, vm_id)
    expect(disk_id).to_not be_nil

    cpi.attach_disk(vm_id, disk_id)
    expect(cpi.has_disk?(disk_id)).to be(true)

    modified_network_spec = network_spec.dup
    modified_network_spec['static']['ip'] = '169.254.1.2'
    cpi.configure_networks(vm_id, modified_network_spec)

    metadata[:bosh_data] = 'bosh data'
    metadata[:instance_id] = 'instance'
    metadata[:agent_id] = 'agent'
    metadata[:director_name] = 'Director'
    metadata[:director_uuid] = '6d06b0cc-2c08-43c5-95be-f1b2dd247e18'

    expect {
      cpi.snapshot_disk(disk_id, metadata)
    }.to raise_error Bosh::Clouds::NotImplemented

    expect {
      cpi.delete_snapshot('some snapshot_id')
    }.to raise_error Bosh::Clouds::NotImplemented

  ensure
    cpi.detach_disk(vm_id, disk_id) if disk_id
    cpi.delete_vm(vm_id) if vm_id
    cpi.delete_disk(disk_id) if disk_id
  end

end
