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

  after(:all) {
    delete_stemcell(@cpi, @stemcell_id)
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
        delete_vm(@cpi, test_vm_id)
        delete_vm(@cpi, duplicate_ip_vm_id)
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
          delete_vm(@cpi, vm_id)
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
          delete_vm(@cpi, vm_id)
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
    after { delete_disk(@cpi, @existing_volume_id) }

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(@cpi, [@existing_volume_id], resource_pool, network_spec)
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
        delete_vm(@cpi, vm_id)
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
      delete_vm(first_datastore_cpi, @vm_id)
      delete_disk(first_datastore_cpi, @disk_id)
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
        delete_stemcell(nested_datacenter_cpi, nested_datacenter_stemcell_id)
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
        delete_vm(@cpi, vm_id)
        delete_disk(@cpi, disk_id)
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
          delete_vm(one_cluster_cpi, first_vm_id)
          delete_vm(one_cluster_cpi, second_vm_id)
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
          detach_disk(one_cluster_cpi, vm_id, disk_id)
          delete_vm(one_cluster_cpi, vm_id)
          delete_disk(one_cluster_cpi, disk_id)
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
          detach_disk(one_cluster_cpi, vm_id, disk_id)
          delete_vm(one_cluster_cpi, vm_id)
          delete_disk(one_cluster_cpi, disk_id)
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
      delete_vm(@cpi, @vm_id)

      if @disk_id && @cpi.has_disk?(@disk_id)
        delete_disk(@cpi, @disk_id)
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

    it 'creates disk in accessible datastore' do
      begin
        accessible_datastores = datastores_accessible_from_cluster(@cluster)
        expect(accessible_datastores).to_not include(@second_cluster_datastore)

        vm_id = create_vm_with_cpi(cpi_for_vm)
        expect(vm_id).to_not be_nil

        disk_id = @cpi.create_disk(128, {}, vm_id)

        verify_disk_is_in_datastores(disk_id, accessible_datastores)
      ensure
        delete_vm(@cpi, vm_id)
        delete_disk(@cpi, disk_id)
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
        detach_disk(@cpi, vm_id, disk_id)
        delete_vm(@cpi, vm_id)
        delete_disk(@cpi, disk_id)
      end
    end
  end

  context 'when disk_pools.cloud_properties.datastores is specified' do
    let(:options) do
      options = cpi_options(
        persistent_datastore_pattern: @datastore_pattern
      )
    end
    let(:persistent_datastores) { datastore_names_matching_pattern(@persistent_datastore_pattern) }
    let(:cloud_properties) { { 'datastores' => persistent_datastores } }

    it 'creates disk in the specified datastore and does not move it when attached' do
      cpi = described_class.new(options)
      begin
        director_disk_id = cpi.create_disk(128, cloud_properties)
        disk_id, _ = VSphereCloud::DiskMetadata.decode(director_disk_id)
        verify_disk_is_in_datastores(disk_id, persistent_datastores)

        vm_id = cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool,
          network_spec,
          [director_disk_id],
          {}
        )
        expect(vm_id).to_not be_nil

        cpi.attach_disk(vm_id, director_disk_id)
        verify_disk_is_in_datastores(disk_id, persistent_datastores)
      ensure
        detach_disk(cpi, vm_id, director_disk_id)
        delete_vm(cpi, vm_id)
        delete_disk(cpi, director_disk_id)
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
      begin
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
      ensure
        delete_vm(@cpi, vm_id)
      end
    end
  end

  context 'when cluster specified for VM cannot access datastore matching the given pattern' do
    let(:cpi) do
      options_with_cluster_datastore_mismatch = cpi_options(
        datastore_pattern: @second_cluster_datastore,
        persistent_datastore_pattern: @second_cluster_datastore,
        clusters: [{ @cluster => {'resource_pool' => @resource_pool_name} }],
      )
      second_cluster_cpi = described_class.new(options_with_cluster_datastore_mismatch)
    end

    it 'raises an error containing target cluster and datastore' do
      expect {
        cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
      }.to raise_error { |error|
        expect(error).to be_a(Bosh::Clouds::CloudError)
        expect(error.message).to include(@second_cluster_datastore)
        expect(error.message).to include(@cluster)
      }
    end
  end

  context 'when cluster specified for VM cannot access datastore matching the given pattern' do
    let(:cpi) do
      options_with_cluster_datastore_mismatch = cpi_options(
        datastore_pattern: @second_cluster_datastore,
        persistent_datastore_pattern: @second_cluster_datastore,
        clusters: [{ @cluster => {'resource_pool' => @resource_pool_name} }],
      )
      second_cluster_cpi = described_class.new(options_with_cluster_datastore_mismatch)
    end

    it 'raises an error containing target cluster and datastore' do
      expect {
        cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
      }.to raise_error { |error|
        expect(error).to be_a(Bosh::Clouds::CloudError)
        expect(error.message).to include(@second_cluster_datastore)
        expect(error.message).to include(@cluster)
      }
    end
  end

  context 'when datastores are configured in resource_pools' do
    let (:resource_pool_with_datastores) do
      resource_pool.merge({
        'datastores' => [@second_cluster_datastore]
      })
    end

    it 'creates a VM in one of the specified datastores' do
      begin
        vm_id = @cpi.create_vm(
          'agent-007',
          @stemcell_id,
          resource_pool_with_datastores,
          network_spec,
          [],
          {}
        )

        expect(vm_id).to_not be_nil
        vm = @cpi.vm_provider.find(vm_id)
        ephemeral_disk = vm.ephemeral_disk
        expect(ephemeral_disk).to_not be_nil

        ephemeral_ds = ephemeral_disk.backing.datastore.name
        expect(ephemeral_ds).to eq(@second_cluster_datastore)
      ensure
        delete_vm(@cpi, vm_id)
      end
    end

    context 'when a valid cluster is configured in resource_pools' do
      let (:resource_pool_with_datastores) do
        resource_pool.merge({
          'datastores' => [@second_cluster_datastore],
          'datacenters' => [{
            'name' => @datacenter_name,
            'clusters' => [{
              @second_cluster => {}
            }]
          }]
        })
      end

      it 'creates a VM in one of the specified datastores' do
        begin
          vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            resource_pool_with_datastores,
            network_spec,
            [],
            {}
          )

          expect(vm_id).to_not be_nil
          vm = @cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil

          ephemeral_ds = ephemeral_disk.backing.datastore.name
          expect(ephemeral_ds).to eq(@second_cluster_datastore)
        ensure
          delete_vm(@cpi, vm_id)
        end
      end
    end

    context 'when an invalid cluster is configured in resource_pools' do
      let (:resource_pool_with_datastores) do
        resource_pool.merge({
          'datastores' => [@second_cluster_datastore],
          'datacenters' => [{
            'name' => @datacenter_name,
            'clusters' => [{
              @cluster => {}
            }]
          }]
        })
      end

      it 'raises an error' do
        begin
          vm_id = nil
          expect {
            vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              resource_pool_with_datastores,
              network_spec,
              [],
              {}
            )
          }.to raise_error Bosh::Clouds::CloudError, /Could not find any suitable datastores matching filter/
        ensure
          delete_vm(@cpi, vm_id)
        end
      end
    end
  end

  describe 'host-local storage patterns', :host_local => true do
    let(:local_disk_cpi) { described_class.new(local_disk_options) }

    before(:all) do
      @single_local_ds_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN')
      @multi_local_ds_pattern = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN')
      @second_cluster_local_datastore = LifecycleHelpers.fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE')

      datacenter = described_class.new(cpi_options).datacenter
      LifecycleHelpers.verify_local_disk_infrastructure(
        datacenter,
        'BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN',
        @single_local_ds_pattern,
      )

      LifecycleHelpers.verify_local_disk_infrastructure(
        datacenter,
        'BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN',
        @multi_local_ds_pattern,
      )

      LifecycleHelpers.verify_local_disk_infrastructure(
        datacenter,
        'BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE',
        @second_cluster_local_datastore,
      )

      LifecycleHelpers.verify_datastore_within_cluster(
        datacenter,
        'BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN',
        @single_local_ds_pattern,
        @cluster
      )

      LifecycleHelpers.verify_datastore_within_cluster(
        datacenter,
        'BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN',
        @multi_local_ds_pattern,
        @cluster
      )

      LifecycleHelpers.verify_datastore_within_cluster(
        datacenter,
        'BOSH_VSPHERE_CPI_SECOND_CLUSTER_LOCAL_DATASTORE',
        @second_cluster_local_datastore,
        @second_cluster
      )
    end

    context 'when both ephemeral and persistent storage patterns reference a single host-local datastore' do
      let(:local_disk_options) do
        cpi_options({
          datastore_pattern: @single_local_ds_pattern,
          persistent_datastore_pattern: @single_local_ds_pattern,
          clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
        })
      end

      it 'places both ephemeral and persistent disks on local DS' do
        begin
          disk_attached = false
          vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
          vm = local_disk_cpi.vm_provider.find(vm_id)
          ephemeral_disk = vm.ephemeral_disk
          expect(ephemeral_disk).to_not be_nil

          ephemeral_ds = ephemeral_disk.backing.datastore.name
          expect(ephemeral_ds).to match(@single_local_ds_pattern)

          disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil
          disk = local_disk_cpi.datacenter.find_disk(disk_id)
          expect(disk.datastore.name).to eq(ephemeral_ds)

          local_disk_cpi.attach_disk(vm_id, disk_id)
          disk_attached = true
          expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
        ensure
          detach_disk(local_disk_cpi, vm_id, disk_id)
          delete_vm(local_disk_cpi, vm_id)
          delete_disk(local_disk_cpi, disk_id)
        end
      end
    end

    context 'when both ephemeral and persistent storage patterns reference a multiple host-local datastores' do
      let(:local_disk_options) do
        cpi_options({
          datastore_pattern: @multi_local_ds_pattern,
          persistent_datastore_pattern: @multi_local_ds_pattern,
          clusters: [{@cluster => {'resource_pool' => @resource_pool_name}}]
        })
      end

      context 'when a VM hint is provided' do
        it 'places both ephemeral and persistent disks on local DS' do
          begin
            disk_attached = false
            vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
            vm = local_disk_cpi.vm_provider.find(vm_id)
            ephemeral_disk = vm.ephemeral_disk
            expect(ephemeral_disk).to_not be_nil

            ephemeral_ds = ephemeral_disk.backing.datastore.name
            expect(ephemeral_ds).to match(@multi_local_ds_pattern)

            disk_id = local_disk_cpi.create_disk(2048, {}, vm_id)
            expect(disk_id).to_not be_nil
            disk = local_disk_cpi.datacenter.find_disk(disk_id)
            expect(disk.datastore.name).to eq(ephemeral_ds)

            local_disk_cpi.attach_disk(vm_id, disk_id)
            disk_attached = true
            expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
          ensure
            detach_disk(local_disk_cpi, vm_id, disk_id)
            delete_vm(local_disk_cpi, vm_id)
            delete_disk(local_disk_cpi, disk_id)
          end
        end
      end

      context 'when a VM hint is not provided and the disk is placed elsewhere' do
        it 'moves the persistent disk onto the same datastore as the VM' do
          begin
            disk_attached = false
            vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
            vm = local_disk_cpi.vm_provider.find(vm_id)
            ephemeral_disk = vm.ephemeral_disk
            expect(ephemeral_disk).to_not be_nil

            ephemeral_ds = ephemeral_disk.backing.datastore.name
            expect(ephemeral_ds).to match(@multi_local_ds_pattern)

            disk_id = local_disk_cpi.create_disk(2048, {})
            expect(disk_id).to_not be_nil
            disk = local_disk_cpi.datacenter.find_disk(disk_id)

            host_local_datastores = LifecycleHelpers.matching_datastores(local_disk_cpi.datacenter, @multi_local_ds_pattern)
            other_datastore = host_local_datastores.values.find { |ds| ds.name != ephemeral_ds }
            disk = local_disk_cpi.datacenter.move_disk_to_datastore(disk, other_datastore)
            expect(disk.datastore.name).to_not eq(ephemeral_ds)

            local_disk_cpi.attach_disk(vm_id, disk_id)
            disk_attached = true
            expect(local_disk_cpi.has_disk?(disk_id)).to be(true)
            disk = local_disk_cpi.datacenter.find_disk(disk_id)
            expect(disk.datastore.name).to eq(ephemeral_ds)
          ensure
            detach_disk(local_disk_cpi, vm_id, disk_id)
            delete_vm(local_disk_cpi, vm_id)
            delete_disk(local_disk_cpi, disk_id)
          end
        end

        context 'when a persistent disk exists in a host-local datastore in a different cluster' do
          let(:local_disk_options) do
            cpi_options({
              datastore_pattern: @multi_local_ds_pattern,
              persistent_datastore_pattern: @multi_local_ds_pattern,
              clusters: [
                 {@cluster => {'resource_pool' => @resource_pool_name}},
                 {@second_cluster => {'resource_pool' => @second_cluster_resource_pool_name}},
              ],
            })
          end
          let(:second_cluster_cpi) do
            described_class.new(cpi_options({
              datastore_pattern: @second_cluster_local_datastore,
              persistent_datastore_pattern: @second_cluster_local_datastore,
              clusters: [{@second_cluster => {'resource_pool' => @second_cluster_resource_pool_name}}],
            }))
          end

          before do
            @disk_id = second_cluster_cpi.create_disk(2048, {}, nil)
            expect(@disk_id).to_not be_nil
          end

          after do
            delete_disk(second_cluster_cpi, @disk_id)
          end

          it 'migrates the persistent disk to a host-local datastore in the same cluster as the VM' do
            begin
              vm_id = local_disk_cpi.create_vm('agent-007', @stemcell_id, resource_pool, network_spec)
              vm = local_disk_cpi.vm_provider.find(vm_id)
              ephemeral_disk = vm.ephemeral_disk
              expect(ephemeral_disk).to_not be_nil

              ephemeral_ds = ephemeral_disk.backing.datastore.name
              expect(ephemeral_ds).to match(@multi_local_ds_pattern)

              local_disk_cpi.attach_disk(vm_id, @disk_id)
              expect(local_disk_cpi.has_disk?(@disk_id)).to be(true)
              disk = local_disk_cpi.datacenter.find_disk(@disk_id)
              expect(disk.datastore.name).to eq(ephemeral_ds)
            ensure
              detach_disk(local_disk_cpi, vm_id, @disk_id)
              delete_vm(local_disk_cpi, vm_id)
            end
          end
        end
      end
    end
  end


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
    detach_disk(cpi, vm_id, disk_id)
    delete_vm(cpi, vm_id)
    delete_disk(cpi, disk_id)
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

  def delete_vm(cpi, vm_id)
    begin
      cpi.delete_vm(vm_id) if vm_id
    rescue Bosh::Clouds::VMNotFound
    end
  end

  def detach_disk(cpi, vm_id, disk_id)
    begin
      cpi.detach_disk(vm_id, disk_id) if vm_id && disk_id
    rescue Bosh::Clouds::DiskNotAttached, Bosh::Clouds::VMNotFound, Bosh::Clouds::DiskNotFound
    end
  end

  def delete_disk(cpi, disk_id)
    begin
      cpi.delete_disk(disk_id) if disk_id
    rescue Bosh::Clouds::DiskNotFound
    end
  end

  def delete_stemcell(cpi, stemcell_id)
    cpi.delete_stemcell(stemcell_id) if stemcell_id
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

  def find_disk_in_datastore(disk_id, datastore_name)
    datastore_mob = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
    datastore = VSphereCloud::Resources::Datastore.new(datastore_name, datastore_mob, 0, 0)
    @cpi.client.find_disk(disk_id, datastore, @disk_path)
  end

  def datastores_accessible_from_cluster(cluster_name)
    cluster = @cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::ClusterComputeResource, name: cluster_name)
    cluster.datastore.map(&:name)
  end

  def datastore_names_matching_pattern(pattern)
    @cpi.datacenter.all_datastores.keys.select { |name| name =~ Regexp.new(pattern) }
  end
end
