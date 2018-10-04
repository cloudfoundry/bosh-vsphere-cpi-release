require 'spec_helper'
require 'cloud/vsphere/resources/cluster'

module VSphereCloud::Resources
  describe Cluster, fake_logger: true do
    subject(:cluster) do
      VSphereCloud::Resources::Cluster.new(
        cluster_config,
        properties,
        client
      )
    end

    let(:datacenter) { instance_double('VSphereCloud::Resources::Datacenter') }

    let(:log_output) { StringIO.new("") }
    let(:client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }

    let(:cluster_config) do
      instance_double(
        'VSphereCloud::ClusterConfig',
        name: 'fake-cluster-name',
        resource_pool: 'fake-resource-pool',
      )
    end

    let(:properties) do
      {
        :obj => cluster_mob,
        'datastore' => 'fake-datastore-name',
        'resourcePool' => fake_resource_pool_mob,
        'host' => 'fake-host-name'
      }
    end
    let(:cluster_mob) { instance_double('VimSdk::Vim::ClusterComputeResource') }
    let(:cluster_hosts) { [instance_double('VimSdk::Vim::HostSystem')] }
    let(:fake_resource_pool_mob) { instance_double('VimSdk::Vim::ResourcePool') }

    let(:fake_resource_pool) do
      instance_double('VSphereCloud::Resources::ResourcePool',
                      mob: fake_resource_pool_mob
      )
    end
    let(:fake_resource_pool_mob) { instance_double('VimSdk::Vim::ResourcePool') }

    let(:ephemeral_store_properties) { {'name' => 'ephemeral_1', 'summary.accessible' => true, 'summary.freeSpace' => 15000 * BYTES_IN_MB} }
    let(:ephemeral_store_2_properties) { {'name' => 'ephemeral_2', 'summary.accessible' => true, 'summary.freeSpace' => 25000 * BYTES_IN_MB} }
    let(:persistent_store_properties) { {'name' => 'persistent_1', 'summary.accessible' => true, 'summary.freeSpace' => 10000 * BYTES_IN_MB, 'summary.capacity' => 20000 * BYTES_IN_MB} }
    let(:persistent_store_2_properties) { {'name' => 'persistent_2',  'summary.accessible' => true, 'summary.freeSpace' => 20000 * BYTES_IN_MB, 'summary.capacity' => 40000 * BYTES_IN_MB} }
    let(:inaccessible_persistent_store_properties) { {'name' => 'persistent_inaccessible', 'summary.accessible' => false} }

    let(:other_store_properties) { { 'name' => 'other' } }

    let(:fake_datastore_properties) do
      {
        instance_double('VimSdk::Vim::Datastore') => ephemeral_store_properties,
        instance_double('VimSdk::Vim::Datastore') => ephemeral_store_2_properties,
        instance_double('VimSdk::Vim::Datastore') => persistent_store_properties,
        instance_double('VimSdk::Vim::Datastore') => persistent_store_2_properties,
        instance_double('VimSdk::Vim::Datastore') => inaccessible_persistent_store_properties,
        instance_double('VimSdk::Vim::Datastore') => other_store_properties,
      }
    end

    # Testing active hosts
    let(:runtime_active) do
      instance_double('VimSdk::Vim::Host::RuntimeInfo',
                      in_maintenance_mode: false,
                      connection_state: 'connected',
                      power_state: 'poweredOn')
    end

    let(:active_host_1_properties) { {'name' => 'active_host_1', 'runtime' => runtime_active, 'hardware.pciDevice' => 'hardware', 'config.graphicsInfo' => 'graphics'} }
    let(:active_host_2_properties) { {'name' => 'active_host_2', 'runtime' => runtime_active, 'hardware.pciDevice' => 'hardware2', 'config.graphicsInfo' => 'graphics2'} }


    # Testing inactive hosts
    let(:runtime_maintenance_mode) do
      instance_double('VimSdk::Vim::Host::RuntimeInfo',
                      in_maintenance_mode: true,
                      connection_state: 'connected',
                      power_state: 'poweredOn')
    end
    let(:runtime_disconnected) do
      instance_double('VimSdk::Vim::Host::RuntimeInfo',
                      in_maintenance_mode: false,
                      connection_state: 'disconnected',
                      power_state: 'poweredOn')
    end
    let(:runtime_powered_off) do
      instance_double('VimSdk::Vim::Host::RuntimeInfo',
                      in_maintenance_mode: false,
                      connection_state: 'connected',
                      power_state: 'poweredOff')
    end

    let(:inactive_host_1_properties) { {'name' => 'inactive_host_1', 'runtime' => runtime_maintenance_mode, 'hardware.pciDevice' => 'hardware1', 'config.graphicsInfo' => 'graphics1'} }
    let(:inactive_host_2_properties) { {'name' => 'inactive_host_2', 'runtime' => runtime_disconnected, 'hardware.pciDevice' => 'hardware2', 'config.graphicsInfo' => 'graphics2'} }
    let(:inactive_host_3_properties) { {'name' => 'inactive_host_3', 'runtime' => runtime_powered_off, 'hardware.pciDevice' => 'hardware3', 'config.graphicsInfo' => 'graphics3'} }

    let(:fake_host_properties) do
      {
          instance_double('VimSdk::Vim::HostSystem') => active_host_1_properties,
          instance_double('VimSdk::Vim::HostSystem') => active_host_2_properties,
          instance_double('VimSdk::Vim::HostSystem') => inactive_host_1_properties,
          instance_double('VimSdk::Vim::HostSystem') => inactive_host_2_properties,
          instance_double('VimSdk::Vim::HostSystem') => inactive_host_3_properties,
      }
    end


    let(:fake_runtime_info) do
      instance_double(
          'VimSdk::Vim::ResourcePool::RuntimeInfo',
          overall_status: 'red',
          )
    end

    before do
      allow(ResourcePool).to receive(:new).with(
          client, cluster_config, fake_resource_pool_mob
      ).and_return(fake_resource_pool)

      allow(cloud_searcher).to receive(:get_properties).with(
          'fake-datastore-name', VimSdk::Vim::Datastore, Datastore::PROPERTIES, {}
      ).and_return(fake_datastore_properties)

      allow(cloud_searcher).to receive(:get_properties).with(
          'fake-host-name', VimSdk::Vim::HostSystem, Host::PROPERTIES, {}
      ).and_return(fake_host_properties)

      allow(cloud_searcher).to receive(:get_properties).with(
          fake_resource_pool_mob, VimSdk::Vim::ResourcePool, "summary"
      ).and_return({
                       'summary' => instance_double('VimSdk::Vim::ResourcePool::Summary', runtime: fake_runtime_info)
                   })
    end

    describe '#active_hosts' do
      context 'when hosts are active within a cluster' do
        it 'returns the hosts which are active within the cluster' do
          active_hosts = cluster.active_hosts
          expect(active_hosts.keys).to match_array(%w(active_host_1 active_host_2))
          expect(active_hosts['active_host_1'].name).to eq('active_host_1')
          expect(active_hosts['active_host_2'].name).to eq('active_host_2')
        end
      end
    end

    describe '#accessible_datastores' do
      it 'returns the full list of datastores without inaccessible stores' do
        accessible_datastores = cluster.accessible_datastores
        expect(accessible_datastores.keys).to match_array(%w(persistent_1 persistent_2 ephemeral_1 ephemeral_2))
        expect(accessible_datastores['persistent_1'].name).to eq('persistent_1')
        expect(accessible_datastores['persistent_2'].name).to eq('persistent_2')
        expect(accessible_datastores['ephemeral_1'].name).to eq('ephemeral_1')
        expect(accessible_datastores['ephemeral_2'].name).to eq('ephemeral_2')
      end

      context 'when cluster has access to zero datastores' do
        let(:properties) do
          {
            :obj => cluster_mob,
            'host' => cluster_hosts,
            'datastore' => [],
            'resourcePool' => fake_resource_pool_mob,
          }
        end
        it 'returns the empty list of datastores' do
          accessible_ds =  cluster.accessible_datastores
          expect(accessible_ds).to be_empty
        end
      end
    end

    describe 'cluster utilization' do
      context 'when we are using resource pools' do
        context 'when utilization data is available' do
          context 'when the runtime status is green' do
            let(:fake_runtime_info) do
              instance_double(
                'VimSdk::Vim::ResourcePool::RuntimeInfo',
                overall_status: 'green',
                memory: instance_double(
                  'VimSdk::Vim::ResourcePool::ResourceUsage',
                  max_usage: 1024 * 1024 * 100,
                  overall_usage: 1024 * 1024 * 75,
                )
              )
            end

            it 'sets resources to values in the runtime status' do
              expect(cluster.free_memory).to eq(25)
            end
          end
        end
      end

      context 'when we are using clusters directly' do
        def generate_host_property(mob:, name:, connection_state:, maintenance_mode:, memory_size:, power_state:)
          {
            mob => {
              'name' => name,
              'hardware.memorySize' => memory_size,
              'runtime.connectionState' => connection_state,
              'runtime.inMaintenanceMode' => maintenance_mode ? 'true' : 'false',
              'runtime.powerState' => power_state,
              :obj => mob,
            }
          }
        end

        before do
          allow(cluster_config).to receive(:resource_pool).and_return(nil)
        end

        let(:active_host_1_mob) { instance_double('VimSdk::Vim::ClusterComputeResource') }
        let(:active_host_2_mob) { instance_double('VimSdk::Vim::ClusterComputeResource') }
        let(:active_host_mobs) { [active_host_1_mob, active_host_2_mob] }
        let(:compute_summary) { instance_double('VimSdk::Vim::ComputeResource::Summary') }
        let(:active_hosts_properties) do
          {}.merge(
            generate_host_property(mob: active_host_1_mob, name: 'mob-1', maintenance_mode: false, memory_size: 100 * 1024 * 1024, power_state: 'poweredOn', connection_state: 'connected')
          ).merge(
            generate_host_property(mob: active_host_2_mob, name: 'mob-2', maintenance_mode: false, memory_size: 40 * 1024 * 1024, power_state: 'poweredOn', connection_state: 'connected')
          )
        end
        let(:hosts_properties) { active_hosts_properties }

        before do
          allow(cloud_searcher).to receive(:get_properties).and_return({"summary" => compute_summary})
          allow(compute_summary).to receive(:effective_memory).and_return(85)
        end

        it 'sets resources to values based on the active hosts in the cluster' do
          expect(cluster.free_memory).to eq(85)
        end

        context 'when an ESXi host is not powered on' do
          let(:hosts_properties) do
            {}.merge(
              generate_host_property(mob: instance_double('VimSdk::Vim::ClusterComputeResource'), name: 'fake-powered-off', maintenance_mode: false, memory_size: 5 * 1024 * 1024, power_state: 'poweredOff', connection_state: 'connected')
            ).merge(
               active_hosts_properties
            )
          end

          it 'includes the free memory of only powered on hosts' do
            expect(cluster.free_memory).to eq(85)
          end
        end

        context 'when an ESXi host is disconnected' do
          let(:hosts_properties) do
            {}.merge(
              generate_host_property(mob: instance_double('VimSdk::Vim::ClusterComputeResource'), name: 'fake-host-disc', maintenance_mode: false, memory_size: 5 * 1024 * 1024, power_state: 'poweredOn', connection_state: 'disconnected')
            ).merge(
              active_hosts_properties
            )
          end

          it 'includes the free memory of only connected hosts' do
            expect(cluster.free_memory).to eq(85)
          end
        end

        context 'when an ESXi host is in maintenance mode' do
          let(:hosts_properties) do
            {}.merge(
              generate_host_property(mob: instance_double('VimSdk::Vim::ClusterComputeResource'), name: 'fake-host-maint', maintenance_mode: true, memory_size: 5 * 1024 * 1024, power_state: 'poweredOn', connection_state: 'connected')
            ).merge(
               active_hosts_properties
            )
          end

          it 'includes the free memory of only hosts not in maintenance mode' do
            expect(cluster.free_memory).to eq(85)
          end
        end

        context 'when there are no active cluster hosts' do
          let(:hosts_properties) do
            {}.merge(
              generate_host_property(mob: instance_double('VimSdk::Vim::ClusterComputeResource'), name: 'fake-host-inactive', maintenance_mode: false, memory_size: 5 * 1024 * 1024, power_state: 'poweredOff', connection_state: 'disconnected')
            )
          end
          before do
            allow(compute_summary).to receive(:effective_memory).and_return(0)
          end
          it 'defaults free memory to zero' do
            expect(cluster.free_memory).to eq(0)
          end
        end
      end
    end

    describe '#free_memory' do
      let(:fake_runtime_info) do
        instance_double(
          'VimSdk::Vim::ResourcePool::RuntimeInfo',
          overall_status: 'green',
          memory: instance_double(
            'VimSdk::Vim::ResourcePool::ResourceUsage',
            max_usage: 1024 * 1024 * 100,
            overall_usage: 1024 * 1024 * 75,
          )
        )
      end

      it 'returns the amount of free memory in the cluster' do
        expect(cluster.free_memory).to eq(25)
      end

      context 'when we fail to get the utilization for a resource pool' do
        before do
          allow(cloud_searcher).to receive(:get_properties)
                                     .with(fake_resource_pool_mob, VimSdk::Vim::ResourcePool, "summary")
                                     .and_return(nil)
        end

        it 'raises an exception' do
          expect { cluster.free_memory }.to raise_error("Failed to get utilization for resource pool '#{fake_resource_pool}'")
        end
      end
    end

    describe '#mob' do
      it 'returns the cluster mob' do
        expect(cluster.mob).to eq(cluster_mob)
      end
    end

    describe '#resource_pool' do
      it 'returns a resource pool object backed by the resource pool in the cloud properties' do
        expect(cluster.resource_pool).to eq(fake_resource_pool)
        expect(ResourcePool).to have_received(:new).with(client, cluster_config, fake_resource_pool_mob)
      end
    end

    describe '#name' do
      it 'returns the name from the configuration' do
        expect(cluster.name).to eq('fake-cluster-name')
      end
    end

    describe '#inspect' do
      it 'returns the printable form' do
        expect(cluster.inspect).to eq("<Cluster: #{cluster_mob} / fake-cluster-name>")
      end
    end

    describe '#to_s' do
      it 'show relevant info' do
        expect(subject.to_s).to eq("(#{subject.class.name} (name=\"fake-cluster-name\"))")
      end
    end
  end
end
