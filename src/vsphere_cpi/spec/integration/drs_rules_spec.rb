require 'integration/spec_helper'

describe 'DRS rules', drs: true do
  context 'when vm was migrated to another datastore within first cluster' do
    before (:all) do
      @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
      @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
      @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
      @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
      verify_non_overlapping_datastores(
        cpi_options,
        @datastore_pattern,
        'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
        @second_datastore,
        'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
      )
    end

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
      }
    end

    let(:one_cluster_cpi) do
      options = cpi_options(
        datacenters: [{
          clusters: [@cluster_name]
        }],
      )
      VSphereCloud::Cloud.new(options)
    end

    it 'should exercise the vm lifecycle' do
      vm_lifecycle(one_cluster_cpi, [], vm_type, get_network_spec, @stemcell_id) do |vm_id|
        vm = one_cluster_cpi.vm_provider.find(vm_id)

        datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: @second_datastore)
        relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

        one_cluster_cpi.client.wait_for_task do
          vm.mob.relocate(relocate_spec, 'defaultPriority')
        end
      end
    end

    context 'given the director has "enable_auto_anti_affinity_drs_rules" set to true' do
      let(:one_cluster_cpi) do
        options = cpi_options(
          datacenters: [{
            clusters: [@cluster_name]
          }],
          enable_auto_anti_affinity_drs_rules: true,
        )
        VSphereCloud::Cloud.new(options)
      end

      context 'but the resource pool does not have drs rule' do
        let(:env) do
          {
            'key' => 'value',
            'bosh' => {
              'group' => 'some-group'
            }
          }
        end

        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [{
                @cluster_name => {}
              }]
            }]
          }
        end

        it 'should correctly apply VM Anti-Affinity rules to created VMs' do
          begin
            first_vm_id = one_cluster_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              env
            )
            second_vm_id = one_cluster_cpi.create_vm(
              'agent-006',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              env
            )
            first_vm_mob = one_cluster_cpi.vm_provider.find(first_vm_id).mob
            cluster = first_vm_mob.resource_pool.parent

            drs_rules = cluster.configuration_ex.rule
            expect(drs_rules).not_to be_empty
            drs_rule = drs_rules.find { |rule| rule.name == "some-group" }
            expect(drs_rule).to_not be_nil
            expect(drs_rule.vm.length).to eq(2)
            drs_vm_ids = drs_rule.vm.map { |vm_mob| vm_mob.config.instance_uuid }
            expect(drs_vm_ids).to include(first_vm_id, second_vm_id)

          ensure
            delete_vm(one_cluster_cpi, first_vm_id)
            delete_vm(one_cluster_cpi, second_vm_id)
          end
        end
      end

      context 'given a resource pool that is configured with a drs rule' do
        let(:drs_rule_name) { random_drs_rule_name }
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [{
                @cluster_name => {
                  'drs_rules' => [{
                    'name' => drs_rule_name,
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
              vm_type,
              get_network_spec,
              [],
              {'key' => 'value'}
            )
            second_vm_id = one_cluster_cpi.create_vm(
              'agent-006',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              {'key' => 'value'}
            )
            first_vm_mob = one_cluster_cpi.vm_provider.find(first_vm_id).mob
            cluster = first_vm_mob.resource_pool.parent

            drs_rules = cluster.configuration_ex.rule
            expect(drs_rules).not_to be_empty
            drs_rule = drs_rules.find { |rule| rule.name == drs_rule_name }
            expect(drs_rule).to_not be_nil
            expect(drs_rule.vm.length).to eq(2)
            drs_vm_ids = drs_rule.vm.map { |vm_mob| vm_mob.config.instance_uuid }
            expect(drs_vm_ids).to include(first_vm_id, second_vm_id)

          ensure
            delete_vm(one_cluster_cpi, first_vm_id)
            delete_vm(one_cluster_cpi, second_vm_id)
          end
        end
      end
    end

    context 'given the director has "enable_auto_anti_affinity_drs_rules" set to false' do
      let(:one_cluster_cpi) do
        options = cpi_options(
          datacenters: [{
            clusters: [@cluster_name]
          }],
          enable_auto_anti_affinity_drs_rules: false,
        )
        VSphereCloud::Cloud.new(options)
      end

      context 'but the resource pool does not have drs rule' do
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [{
                @cluster_name => {}
              }]
            }]
          }
        end

        it 'should create VM without Anti-Affinity rule' do
          begin
            first_vm_id = one_cluster_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              {'key' => 'value'}
            )
            second_vm_id = one_cluster_cpi.create_vm(
              'agent-006',
              @stemcell_id,
              vm_type,
              get_network_spec,
              [],
              {'key' => 'value'}
            )
            first_vm_mob = one_cluster_cpi.vm_provider.find(first_vm_id).mob
            cluster = first_vm_mob.resource_pool.parent

            drs_rules = cluster.configuration_ex.rule
            expect(drs_rules).to be_empty
          ensure
            delete_vm(one_cluster_cpi, first_vm_id)
            delete_vm(one_cluster_cpi, second_vm_id)
          end
        end
      end

      context 'given a resource pool that is configured with a drs rule' do
        let(:drs_rule_name) { random_drs_rule_name }
        let(:vm_type) do
          {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datacenters' => [{
              'name' => @datacenter_name,
              'clusters' => [{
                @cluster_name => {
                  'drs_rules' => [
                    {
                      'name' => drs_rule_name,
                      'type' => 'separate_vms'
                    }
                  ]
                }
              }]
            }]
          }
        end

        it 'should correctly apply VM Anti-Affinity rules to created VMs' do
          begin
            cluster = one_cluster_cpi.datacenter.find_cluster(@cluster_name)
            number_of_hosts = cluster.mob.host.length

            vms = []
            for i in 1..number_of_hosts
              vm_id = one_cluster_cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {'key' => 'value'}
              )
              vms.push(vm_id)
            end

            first_vm_mob = one_cluster_cpi.vm_provider.find(vms[0]).mob
            cluster = first_vm_mob.resource_pool.parent

            drs_rules = cluster.configuration_ex.rule
            expect(drs_rules).not_to be_empty
            drs_rule = drs_rules.find { |rule| rule.name == drs_rule_name}
            expect(drs_rule).to_not be_nil
            expect(drs_rule.vm.length).to eq(number_of_hosts)
            drs_vm_ids = drs_rule.vm.map { |vm_mob| vm_mob.config.instance_uuid }
            expect(vms - drs_vm_ids).to be_empty

            expect do
              failed_vm = one_cluster_cpi.create_vm(
                'agent-006',
                @stemcell_id,
                vm_type,
                get_network_spec,
                [],
                {'key' => 'value'}
              )
              vms.push(failed_vm)
            end.to raise_error(VSphereCloud::VMPowerOnError) { |e| e.unplaceable? }
          ensure
            vms.each {|vm_id| delete_vm(one_cluster_cpi, vm_id)}
          end
        end
      end
    end

    context 'when migration happened after attaching a persistent disk' do
      let(:datastore_name) {
        datastore_name = one_cluster_cpi.datacenter.accessible_datastores.select do |datastore|
          datastore.match(@datastore_pattern)
        end
        datastore_name.first[0]
      }

      it 'can still find persistent disks after and deleting vm' do
        begin
          vm_id = one_cluster_cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            get_network_spec,
            [],
            {'key' => 'value'}
          )

          expect(vm_id).to_not be_nil
          expect(one_cluster_cpi.has_vm?(vm_id)).to be(true)

          disk_id = one_cluster_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil

          one_cluster_cpi.attach_disk(vm_id, disk_id)
          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

          vm = one_cluster_cpi.vm_provider.find(vm_id)

          datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
          relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

          one_cluster_cpi.client.wait_for_task do
            vm.mob.relocate(relocate_spec, 'defaultPriority')
          end

          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

          one_cluster_cpi.delete_vm(vm_id)
          vm_id = nil

          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)
        ensure
          detach_disk(one_cluster_cpi, vm_id, disk_id)
          delete_vm(one_cluster_cpi, vm_id)
          delete_disk(one_cluster_cpi, disk_id)
        end
      end

      it 'can still find persistent disk after vMotion and after detaching disk from vm' do
        begin
          vm_id = one_cluster_cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            get_network_spec,
            [],
            {'key' => 'value'}
          )

          expect(vm_id).to_not be_nil
          expect(one_cluster_cpi.has_vm?(vm_id)).to be(true)

          disk_id = one_cluster_cpi.create_disk(2048, {}, vm_id)
          expect(disk_id).to_not be_nil

          one_cluster_cpi.attach_disk(vm_id, disk_id)
          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

          vm = one_cluster_cpi.vm_provider.find(vm_id)

          datastore = one_cluster_cpi.client.cloud_searcher.get_managed_object(VimSdk::Vim::Datastore, name: datastore_name)
          relocate_spec = VimSdk::Vim::Vm::RelocateSpec.new(datastore: datastore)

          one_cluster_cpi.client.wait_for_task do
            vm.mob.relocate(relocate_spec, 'defaultPriority')
          end

          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)

          one_cluster_cpi.detach_disk(vm_id, disk_id)
          expect(one_cluster_cpi.has_disk?(disk_id)).to be(true)
        ensure
          detach_disk(one_cluster_cpi, vm_id, disk_id)
          delete_vm(one_cluster_cpi, vm_id)
          delete_disk(one_cluster_cpi, disk_id)
        end
      end
    end
  end

  private

  def random_drs_rule_name
    "drs-rule-#{(0...6).map { (97 + rand(26)).chr }.join}"
  end
end
