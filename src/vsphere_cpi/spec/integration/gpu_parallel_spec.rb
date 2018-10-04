require 'integration/spec_helper'
require 'rspec/expectations'

GRAPHICS_VENDOR_ID = 4318.freeze

RSpec::Matchers.define :have_number_of_GPU_eql_to do |num_gpu|
  match do |actual|
    num_gpu  == actual.count do |device|
      !device.backing.nil? && device.backing.is_a?(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo) && device.backing.vendor_id == GRAPHICS_VENDOR_ID
    end
  end
end

#INCLUDES TESTS for parallel vm calls and tests for gpu on hosts in different clusters

#have a before before a context
#for second context one host in one cluster then the other one in other cluster
describe 'cloud_properties related to creation of GPU attached VMs' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @gpu_host_datastore_one = fetch_property('BOSH_VSPHERE_CPI_SHARED_DATASTORE')
    @host_1 = '10.114.22.249' #4 GRID K1 GPUs
    @host_2 = '10.114.22.29' #2 GRID K2 GPUs
  end

  let(:base_vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
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

  # Both hosts being on the second cluster tests
  context 'when vm_type specifies a single cluster that has one of the hosts with GPUs' do
    let(:vm_type_single_cluster) do
      base_vm_type.merge(
          'datacenters' => [
              {
                  'name' => @datacenter_name,
                  'clusters' => [
                      {
                          @second_cluster_name => {}
                      },
                  ]
              }
          ]
      )
    end
    context 'when ephemeral datastore is accessible from GPU host' do
      let(:vm_type_single_cluster_acc_ds) do
        vm_type_single_cluster.merge(
            'datastores' => [@gpu_host_datastore_one]
        )
      end

      # parallel vm calls
      context 'when vm_type has two clusters specifies 1 GPU and we create 6 vms in parallel' do
        let(:vm_type_single_cluster_acc_ds_1_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 1}
          ).merge(
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
        it 'creates vms in cluster defined in `vm_type_single_cluster_acc_ds_1_gpu` with 1 GPU each' do
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
                    vm_type_single_cluster_acc_ds_1_gpu,
                    get_network_spec,
                    [],
                    {}
                )
                vm_list << vm
              }
              thread_list << t
            end

            thread_list.each {|t| t.join()}

            #require 'pry-byebug'
            #binding.pry
            vm_list.each do |vm_id|
              vm = cpi.vm_provider.find(vm_id)
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
            end
          # ensure
          #   cpi = VSphereCloud::Cloud.new(cpi_options)
          #   vm_list.each do |vm_id|
          #     delete_vm(cpi, vm_id)
          #   end
          # end
        end
      end

      context 'when we create multiple vms with GPU' do
        let(:vm_type_single_cluster_acc_ds_1_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 1}
          )
        end
        let(:vm_type_single_cluster_acc_ds_2_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 2}
          )
        end
        let(:vm_type_single_cluster_acc_ds_4_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 4}
          )
        end
        context 'when cpi creates vms with 1,2 and 4 gpus in succession' do
          it 'fails to create third vm due to unavailability of enough GPUs' do
            begin
              vm_id_1 = cpi.create_vm(
                  'agent-007',
                  @stemcell_id,
                  vm_type_single_cluster_acc_ds_1_gpu,
                  get_network_spec,
                  [],
                  {}
              )
              expect(vm_id_1).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_1)
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)

              vm_id_2 = cpi.create_vm(
                  'agent-007',
                  @stemcell_id,
                  vm_type_single_cluster_acc_ds_2_gpu,
                  get_network_spec,
                  [],
                  {}
              )
              expect(vm_id_2).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_2)
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1).or eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)

              expect {
                cpi.create_vm(
                    'agent-007',
                    @stemcell_id,
                    vm_type_single_cluster_acc_ds_4_gpu,
                    get_network_spec,
                    [],
                    {},
                )
              }.to raise_error(/No valid placement found for VM compute, storage, and hosts requirement/)
            ensure
              delete_vm(cpi, vm_id_1)
              delete_vm(cpi, vm_id_2)
            end
          end
        end
      end
    end
  end

  context 'when vm_type specifies a single cluster, which has two hosts with GPUs' do
    let(:options) do
      options = cpi_options(
          'datacenters' => [
              {
                  'name' => @datacenter_name,
                  'clusters' => [
                      {
                          @second_cluster_name => {},
                      },
                  ]
              }
          ]
      )
    end
    let(:vm_type_single_cluster) do
      base_vm_type.merge(
          'datacenters' => [
              {
                  'name' => @datacenter_name,
                  'clusters' => [
                      {
                          @second_cluster_name => {}
                      },
                  ]
              }
          ]
      )
    end

    context 'when ephemeral datastore is accessible from GPU host' do
      let(:vm_type_single_cluster_acc_ds) do
        vm_type_single_cluster.merge(
            'datastores' => [@gpu_host_datastore_one]
        )
      end

      context 'when we create multiple vms with GPU' do
        let(:vm_type_single_cluster_acc_ds_4_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 4}
          )
        end
        let(:vm_type_single_cluster_acc_ds_1_gpu) do
          vm_type_single_cluster_acc_ds.merge(
              'gpu' => { 'number_of_gpus' => 1}
          )
        end

        context 'when cpi creates vms with 1 and 4 gpus in succession' do
          xit 'creates all two vms, first vm on host with 2 gpus and second on host with 4 gpus' do
            begin
              vm_id_1 = cpi.create_vm(
                  'agent-007',
                  @stemcell_id,
                  vm_type_single_cluster_acc_ds_1_gpu,
                  get_network_spec,
                  [],
                  {}
              )
              expect(vm_id_1).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_1)
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)

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
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(4)
            ensure
              delete_vm(cpi, vm_id_1)
              delete_vm(cpi, vm_id_2)
            end
          end
        end
      end
    end
  end

  # When hosts with GPUs are on seperate clusters

end

end