require 'spec_helper'
require 'tempfile'
require 'yaml'

describe VSphereCloud::Cloud, external_cpi: false do
  include LifecycleProperties

  before(:all) do
    config = VSphereSpecConfig.new
    config.logger = Logger.new(STDOUT)
    config.logger.level = Logger::DEBUG
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)

    @logger = Logger.new(STDOUT)

    fetch_properties(LifecycleHelpers)
    verify_properties(LifecycleHelpers)

    @cpi = described_class.new(cpi_options)

    Dir.mktmpdir do |temp_dir|
      stemcell_image = LifecycleHelpers.stemcell_image(@stemcell_path, temp_dir)
      @stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
    end
  end

  class VMWareToolsNotFound < StandardError; end

  def block_on_vmware_tools(cpi, vm_name)
    # wait for vsphere tools to be detected by vCenter :(

    start_time = Time.now
    @logger.info("Waiting for VMWare Tools on the VM...")
    Bosh::Common.retryable(tries: 20, on: VMWareToolsNotFound) do
      wait_for_vmware_tools(cpi, vm_name)
    end
    @logger.info("Finished waiting for VMWare Tools. Took #{Time.now - start_time} seconds.")
  end

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
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
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

        block_on_vmware_tools(@cpi, test_vm_id)

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
        }.to raise_error /Detected IP conflicts with other VMs on the same networks/
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

      context 'when resource_pool is set to the first cluster' do
        it 'places vm in first cluster when vsphere resource pool is not provided' do
          begin
            resource_pool['datacenters'] = [{'name' => @datacenter_name, 'clusters' => [{@cluster => {}}]}]
            vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec
            )

            vm = @cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster)
            default_resource_pool = @resource_pool_name
            expect(vm.resource_pool).to_not eq(default_resource_pool)
          ensure
            @cpi.delete_vm(vm_id) if vm_id
          end
        end

        it 'places vm in the specified resource pool when vsphere resource pool is provided' do
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

  context 'with multiple manual networks' do
    let(:network_spec) do
      {
        'static' => {
          'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => {'name' => vlan},
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        },
        'second' => {
          'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => {'name' => vlan},
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        }
      }
    end

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [], resource_pool, network_spec)
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
        disk = first_datastore_cpi.datacenter.find_disk(@disk_id)
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
          first_datastore_cpi.datacenter.find_disk(@disk_id)
        }.to raise_error(Bosh::Clouds::DiskNotFound)
        @disk_id = nil
      end

      it '#attach_disk can move the disk to the new datastore pattern' do
        second_datastore_cpi.attach_disk(@vm_id, @disk_id)

        disk = second_datastore_cpi.datacenter.find_disk(@disk_id)
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
      let(:one_cluster_cpi) do
        options = cpi_options(
          clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
        )
        described_class.new(options)
      end

      it 'should exercise the vm lifecycle' do
        vm_lifecycle(one_cluster_cpi, [], resource_pool, network_spec) do |vm_id|
          vm = one_cluster_cpi.vm_provider.find(vm_id)

          datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: @second_datastore_within_cluster)
          relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

          task = vm.mob.relocate(relocate_spec, 'defaultPriority')
          one_cluster_cpi.client.wait_for_task(task)
        end
      end

      context 'given a resource pool that is configured with a drs rule' do
        let(:one_cluster_cpi) do
          options = cpi_options(
            clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
          )
          described_class.new(options)
        end

        let(:resource_pool) do
          {
            'ram' => 1024,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [{
                @cluster => {
                  'drs_rules' => [{
                    'name' => 'separate-nodes-rule',
                    'type' => 'separate_vms'
                  }]
                }
              }]
            }]
          }
        end

        it 'should correctly apply VM Anti-Affinity rules to created VMs' do
          begin
            first_vm_id = one_cluster_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec,
              [],
              {'key' => 'value'}
            )
            second_vm_id = one_cluster_cpi.create_vm(
              'agent-006',
              @stemcell_id,
              resource_pool,
              network_spec,
              [],
              {'key' => 'value'}
            )
            first_vm_mob = one_cluster_cpi.vm_provider.find(first_vm_id).mob
            cluster = first_vm_mob.resource_pool.parent

            drs_rules = cluster.configuration_ex.rule
            expect(drs_rules).not_to be_empty
            drs_rule = drs_rules.find { |rule| rule.name == "separate-nodes-rule" }
            expect(drs_rule).to_not be_nil
            expect(drs_rule.vm.length).to eq(2)
            drs_vm_names = drs_rule.vm.map { |vm_mob| vm_mob.name }
            expect(drs_vm_names).to include(first_vm_id, second_vm_id)

          ensure
            one_cluster_cpi.delete_vm(first_vm_id) if first_vm_id
            one_cluster_cpi.delete_vm(second_vm_id) if second_vm_id
          end
        end
      end

      context 'when migration happened after attaching a persistent disk' do
        let(:datastore_name) {
          datastore_name = one_cluster_cpi.datacenter.all_datastores.select do |datastore|
            datastore.match(@datastore_pattern)
          end
          datastore_name.first[0]
        }

        it 'can still find persistent disks after vMotion and deleting vm' do
          begin
            disk_attached = false
            vm_id = one_cluster_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec,
              [],
              {'key' => 'value'}
            )

            expect(vm_id).to_not be_nil
            expect(one_cluster_cpi.has_vm?(vm_id)).to be(true)

            disk_id = one_cluster_cpi.create_disk(2048, {}, vm_id)
            expect(disk_id).to_not be_nil

            one_cluster_cpi.attach_disk(vm_id, disk_id)
            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)
            disk_attached = true

            vm = one_cluster_cpi.vm_provider.find(vm_id)

            datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
            relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

            task = vm.mob.relocate(relocate_spec, 'defaultPriority')
            one_cluster_cpi.client.wait_for_task(task)

            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

            one_cluster_cpi.delete_vm(vm_id)
            vm_id = nil
            disk_attached = false

            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)
          ensure
            one_cluster_cpi.detach_disk(vm_id, disk_id) if disk_attached
            one_cluster_cpi.delete_vm(vm_id) if vm_id
            one_cluster_cpi.delete_disk(disk_id) if disk_id
          end
        end

        it 'can still find persistent disk after vMotion and after detaching disk from vm' do
          begin
            disk_attached = false
            vm_id = one_cluster_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool,
              network_spec,
              [],
              {'key' => 'value'}
            )

            expect(vm_id).to_not be_nil
            expect(one_cluster_cpi.has_vm?(vm_id)).to be(true)

            disk_id = one_cluster_cpi.create_disk(2048, {}, vm_id)
            expect(disk_id).to_not be_nil

            one_cluster_cpi.attach_disk(vm_id, disk_id)
            disk_attached = true
            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

            vm = one_cluster_cpi.vm_provider.find(vm_id)

            datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
            relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

            task = vm.mob.relocate(relocate_spec, 'defaultPriority')
            one_cluster_cpi.client.wait_for_task(task)

            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

            one_cluster_cpi.detach_disk(vm_id, disk_id)
            disk_attached = false
            expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)
          ensure
            one_cluster_cpi.detach_disk(vm_id, disk_id) if disk_attached
            one_cluster_cpi.delete_vm(vm_id) if vm_id
            one_cluster_cpi.delete_disk(disk_id) if disk_id
          end
        end
      end
    end

    context 'when a persistent disk is attached in "persistent" (dependent) mode' do
      before do
        @vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [],
          {'key' => 'value'}
        )
        expect(@vm_id).to_not be_nil
        expect(@cpi.has_vm?(@vm_id)).to be(true), 'Expected has_vm? to be true'

        @disk_id = @cpi.create_disk(2048, {}, @vm_id)
        expect(@disk_id).to_not be_nil

        @cpi.attach_disk(@vm_id, @disk_id)

        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'

        @vm = @cpi.vm_provider.find(@vm_id)

        virtual_disk = @vm.persistent_disks.first
        virtual_disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::PERSISTENT
        edit_spec = VSphereCloud::Resources::VM.create_edit_device_spec(virtual_disk)

        config = VimSdk::Vim::Vm::ConfigSpec.new
        config.device_change << edit_spec

        @vm.power_off
        @cpi.client.reconfig_vm(@vm.mob, config)
        @vm.power_on
      end

      after do
        @cpi.delete_vm(@vm_id) if @vm_id

        if @disk_id && @cpi.has_disk?(@disk_id)
          @cpi.delete_disk(@disk_id)
        end
      end

      it 'can still find disk after deleting VM' do
        @cpi.delete_vm(@vm_id)
        @vm_id = nil

        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
      end
    end

    context 'when a persistent disk is attached in "nonpersistent" mode' do
      before do
        @vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [],
          {'key' => 'value'}
        )
        expect(@vm_id).to_not be_nil
        expect(@cpi.has_vm?(@vm_id)).to be(true), 'Expected has_vm? to be true'

        @disk_id = @cpi.create_disk(2048, {}, @vm_id)
        expect(@disk_id).to_not be_nil

        @cpi.attach_disk(@vm_id, @disk_id)

        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'

        @vm = @cpi.vm_provider.find(@vm_id)

        # power off VM first to ensure new disk mode is in use
        @vm.power_off

        virtual_disk = @vm.persistent_disks.first
        virtual_disk.backing.disk_mode = VimSdk::Vim::Vm::Device::VirtualDiskOption::DiskMode::INDEPENDENT_NONPERSISTENT
        edit_spec = VSphereCloud::Resources::VM.create_edit_device_spec(virtual_disk)

        config = VimSdk::Vim::Vm::ConfigSpec.new
        config.device_change << edit_spec

        @cpi.client.reconfig_vm(@vm.mob, config)
        @vm.power_on
      end

      after do
        # use lower-level client calls to bypass disk safety checks on cleanup
        if @vm_id
          @cpi.client.power_off_vm(@vm.mob)
          @cpi.client.delete_vm(@vm.mob)
        end

        if @disk_id && @cpi.has_disk?(@disk_id)
          @cpi.delete_disk(@disk_id)
        end
      end

      it 'refuses to delete the VM' do
        expect do
          @cpi.delete_vm(@vm_id)
        end.to raise_error(/The following disks are attached with non-persistent disk modes/)

        expect(@cpi.has_vm?(@vm_id)).to be(true), "Expected #{@vm_id} to still exist"
        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
      end

      it 'refuses to reboot the VM' do
        expect do
          @cpi.reboot_vm(@vm_id)
        end.to raise_error(/The following disks are attached with non-persistent disk modes/)

        expect(@cpi.has_vm?(@vm_id)).to be(true), "Expected #{@vm_id} to still exist"
        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
      end

      it 'refuses to detach the disk' do
        expect do
          @cpi.detach_disk(@vm_id, @disk_id)
        end.to raise_error(/The following disks are attached with non-persistent disk modes/)

        expect(@cpi.has_disk?(@disk_id)).to be(true), 'Expected has_disk? to be true'
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
          disk_attached = false
          vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
          vm = local_disk_cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil
          expect(ephemeral_disk.backing.datastore.name).to match(@local_datastore_pattern)

          disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil
          disk = local_disk_cpi.datacenter.find_disk(disk_id)
          expect(disk.datastore.name).to match(@persistent_datastore_pattern)
          local_disk_cpi.attach_disk(vm_id, disk_id)
          disk_attached = true
          expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
        ensure
          local_disk_cpi.detach_disk(vm_id, disk_id) if disk_attached
          local_disk_cpi.delete_vm(vm_id) if vm_id
          local_disk_cpi.delete_disk(disk_id) if disk_id
        end
      end
    end

    context 'when having cpu/mem hot add enabled' do
      let (:resource_pool_with_hot_params) do
        resource_pool.merge({
          'cpu_hot_add_enabled' => true,
          'memory_hot_add_enabled' => true
        })
      end

      it 'creates a VM with those properties enabled' do
        vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool_with_hot_params,
          network_spec,
          [],
          {}
        )

        expect(vm_id).to_not be_nil
        vm = @cpi.vm_provider.find(vm_id)
        vm_mob = vm.mob
        expect(vm_mob.config.cpu_hot_add_enabled).to be(true)
        expect(vm_mob.config.memory_hot_add_enabled).to be(true)
      end
    end
  end

  def vm_lifecycle(cpi, disk_locality, resource_pool, network_spec, stemcell_id = @stemcell_id)
    disk_attached = false
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
    disk_attached = true
    expect(cpi.has_disk?(disk_id)).to be(true)

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
    cpi.detach_disk(vm_id, disk_id) if disk_attached
    cpi.delete_vm(vm_id) if vm_id
    cpi.delete_disk(disk_id) if disk_id
  end
end
