require 'integration/spec_helper'
require 'rspec/expectations'

GRAPHICS_VENDOR_ID = 4318.freeze

RSpec::Matchers.define :have_number_of_GPU_eql_to do |num_gpu|
  match do |actual|
    num_gpu == actual.count do |device|
      !device.backing.nil? && device.backing.is_a?(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo) && device.backing.vendor_id == GRAPHICS_VENDOR_ID
    end
  end
end

# add both hosts in BOSH_VSPHERE_CPI_CLUSTER
# mount BOSH_VSPHERE_CPI_SHARED_DATASTORE on host1
# mount BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE on host2
# host 2 should have more GPUs than host 1
describe 'cloud_properties related to creation of GPU,' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @gpu_host_datastore_one = fetch_property('BOSH_VSPHERE_CPI_SHARED_DATASTORE')
    @gpu_host_datastore_two = fetch_property('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE')
    @host_1 = '10.114.22.249' #2 GRID K1 GPUs
    # @host_1 = '10.114.22.29' #2 GRID K1 GPUs
    # @host_2 = '10.114.22.33' #2 GRID K2 GPUs
  end

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
      'datacenters' => [
        {
          'name' => @datacenter_name,
          'clusters' => [
            {
              @cluster_name => {}
            },
          ]
        }
      ]
    }
  end

  let(:options) do
    options = cpi_options(
      'datacenters' => [
        {
          'name' => @datacenter_name,
          'clusters' => [
            {
              @cluster_name => {},
            }
          ]
        }
      ]
    )
  end

  let(:cpi) do
    VSphereCloud::Cloud.new(options)
  end

  context 'with a single cluster that has one of the hosts with GPUs' do
    context 'and ephemeral datastore is accessible from GPU host' do
      let(:vm_type_single_cluster) do
        vm_type.merge(
          'datastores' => [@gpu_host_datastore_one],
          'gpu' => { 'number_of_gpus' => number_of_gpus }
        )
      end

      context 'and vm_type specifies 0 GPUs' do
        let(:number_of_gpus) { 0 }
        it 'creates vm with 0 GPUs' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(0)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'and vm_type specifies 2 GPU' do
        let(:number_of_gpus) { 2 }

        it 'creates vm with 2 GPUs' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_1)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'and 3 vms with 1 GPU are created in succession' do
        let(:number_of_gpus) { 1 }

        it 'fails to create third vm due to unavailability of enough GPUs' do
          begin
            vm_id_1 = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id_1).to_not be_nil

            vm = cpi.vm_provider.find(vm_id_1)
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)

            vm_id_2 = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id_2).to_not be_nil

            vm = cpi.vm_provider.find(vm_id_2)
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)

            expect {
              cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_single_cluster,
                get_network_spec,
                [],
                {}
              )
            }.to raise_error(/No valid placement found for VM compute, storage, and hosts requirement/)
          ensure
            delete_vm(cpi, vm_id_1)
            delete_vm(cpi, vm_id_2)
          end
        end
      end

      context 'and vm_type specifies GPUs, more than available on any host' do
        let(:number_of_gpus) { 5 }
        it 'fails to creates vm' do
          begin
            expect {
              cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_single_cluster,
                get_network_spec,
                [],
                {}
              )
            }.to raise_error(/No valid placement found for VM compute, storage, and hosts requirement/)
          end
        end
      end
    end

    context 'and ephemeral datastore is not accessible from GPU host' do
      let(:vm_type_single_cluster_non_acc_ds) do
        vm_type_single_cluster.merge(
          'gpu' => { 'number_of_gpus' => 5 }
        )
      end
      it 'fails to creates vm' do
        begin
          expect {
            cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster_non_acc_ds,
              get_network_spec,
              [],
              {}
            )
          }.to raise_error(/.*/)
        end
      end
    end
  end

  context 'with a single cluster, which has two hosts with GPUs' do
    context 'and ephemeral datastore is accessible from GPU host' do
      let(:vm_type_single_cluster) do
        vm_type.merge(
          'datastores' => [@gpu_host_datastore_one, @gpu_host_datastore_two],
          'gpu' => { 'number_of_gpus' => number_of_gpus }
        )
      end

      context 'when vm_type specifies 1 GPU' do
        let(:number_of_gpus) { 1 }

        xit 'creates vm on host with least no of available GPUs' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_1)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end
      context 'when vm_type specifies 4 GPU' do
        xit 'creates vm on 2nd host' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_2)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(4)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when multiple vms are created in succession' do
        let(:number_of_gpus) { 2 }

        #wont pass all the time since the 2gpu option can be placed on both hosts
        context 'with 2 GPUs in succession' do
          xit 'creates both vms, first vm on host with 2 GPUs and second on host with 4 GPUs' do
            begin
              vm_id_1 = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_single_cluster,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id_1).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_1)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)

              vm_id_2 = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_single_cluster_acc_ds_4_gpu,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id_2).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_2)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)
            ensure
              delete_vm(cpi, vm_id_1)
              delete_vm(cpi, vm_id_2)
            end
          end
        end
      end
    end
  end

  # parallel vm calls
  context 'with 2 clusters, when 6 vms are created in parallel with 1 GPU' do
    let(:vm_type_multiple_clusters) do
      vm_type.merge(
        'gpu' => { 'number_of_gpus' => 1 },
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_name => {}
              },
              {
                @second_cluster_name => {}
              }
            ]
          }
        ]
      )
    end
    xit 'creates 6 vms with 1 GPU each' do
      begin

        thread_list = []
        vm_list = []

        6.times do
          vm = nil
          t = Thread.new {
            cpi = VSphereCloud::Cloud.new(cpi_options)
            vm = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_multiple_clusters,
              get_network_spec,
              [],
              {}
            )
            vm_list << vm
          }
          thread_list << t
        end

        thread_list.each { |t| t.join() }

        vm_list.each do |vm_id|
          vm = cpi.vm_provider.find(vm_id)
          expect(vm).to_not be_nil
          expect(vm.cluster).to eq(@cluster_name)
          expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
          expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
        end
      ensure
        cpi = VSphereCloud::Cloud.new(cpi_options)
        vm_list.each do |vm_id|
          delete_vm(cpi, vm_id)
        end
      end
    end
  end
end

