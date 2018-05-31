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


describe 'cloud_properties related to creation of GPU attached VMs' do
  before (:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @gpu_host_datastore_one = fetch_property('BOSH_VSPHERE_CPI_SHARED_DATASTORE')
    @gpu_host_datastore_two = 'vcpi-ds'
    @host_1 = '10.114.22.249'
    @host_2 = '10.114.22.29'
    @host_3 = '10.114.22.33'

    # # Add the host to vcpi-cluster-1
    # host_spec = VimSdk::Vim::Host::ConnectSpec.new
    # host_spec.force = true
    # host_spec.host_name = '10.114.22.249'
    # host_spec.password = 'XXXX'
    # host_spec.user_name = 'XXXX'
    # @cluster_one = fetch_clusters(@cluster_name)
    # require 'pry-byebug'
    # binding.pry
    # @cpi.client.wait_for_task do
    #   cluster.add_host(host_spec, true)
    # end
    #
    # ADDITIONALLY, WE HAVE TO REMOVE HOST FROM MAINTENANCE MODE AND
  end

  # after(:all) do
  #   @cluster_one
  # end

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
            },
          ]
        }
      ]
    )
  end

  let(:cpi) do
    VSphereCloud::Cloud.new(options)
  end

  context 'when vm_type specifies a single cluster that has one of the hosts with GPUs' do
    let(:vm_type_single_cluster) do
      base_vm_type.merge(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_name => {}
              }
            ]
          }
        ]
      )
    end
    context 'when ephemeral datastore is accessible from GPU host' do
      let(:vm_type_single_cluster_acc_ds) do
        vm_type_single_cluster.merge(
          'datastores' => [@gpu_host_datastore_one, @gpu_host_datastore_two]
        )
      end

      context 'when vm_type specifies 0 GPUs' do
        let(:vm_type_single_cluster_acc_ds_0_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 0}
          )
        end
        it 'creates vm in cluster defined in `vm_type_single_cluster_acc_ds_0_gpu` with 0 gpus' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster_acc_ds_0_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(0)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when vm_type specifies 1 GPU' do
        let(:vm_type_single_cluster_acc_ds_1_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 1}
          )
        end
        it 'creates vm in cluster defined in `vm_type_single_cluster_acc_ds_1_gpu` with 1 GPU' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster_acc_ds_1_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq('10.114.22.249')
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when vm_type specifies 4 GPU' do
        let(:vm_type_single_cluster_acc_ds_4_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 4}
          )
        end
        it 'creates vm in cluster defined in `vm_type_single_cluster_acc_ds_4_gpu` with 4 GPUs' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster_acc_ds_4_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq('10.114.22.249')
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(4)
          ensure
            delete_vm(cpi, vm_id)
          end
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
        let(:vm_type_single_cluster_acc_ds_3_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 3}
          )
        end
        context 'when cpi creates vms with 1,2 and 3 gpus in succession' do
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
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@cluster_name)
              expect(vm.mob.runtime.host.name).to eq('10.114.22.249')
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
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@cluster_name)
              expect(vm.mob.runtime.host.name).to eq('10.114.22.249')
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)

              expect {
                cpi.create_vm(
                  'agent-007',
                  @stemcell_id,
                  vm_type_single_cluster_acc_ds_3_gpu,
                  get_network_spec,
                  [],
                  {}
                )
              }.to raise_error(/no active host found with.*free gpus/)
            ensure
              delete_vm(cpi, vm_id_1)
              delete_vm(cpi, vm_id_2)
            end
          end
        end
      end

      context 'when vm_type specifies GPUs more than available on any host' do
        let(:vm_type_single_cluster_acc_ds_5_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 5}
          )
        end
        it 'fails to creates vm in cluster defined in `vm_type_single_cluster_acc_ds_5_gpu`' do
          begin
            expect {
              cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_single_cluster_acc_ds_5_gpu,
                get_network_spec,
                [],
                {}
              )
            }.to raise_error(/no active host found with.*free gpus/)
          end
        end
      end
    end

    context 'when ephemeral datastore is not accessible from GPU host' do
      let(:vm_type_single_cluster_non_acc_ds) do
        vm_type_single_cluster.merge(
          'gpu' => { 'number_of_gpus' => 5}
        )
      end
      it 'fails to creates vm in cluster defined in `vm_type_single_cluster_non_acc_ds`' do
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

  context 'when vm_type specifies two clusters, both of which have a host with GPUs' do
    let(:options) do
      options = cpi_options(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_name => {},
              },
              {
                @second_cluster_name => {},
              },
            ]
          }
        ]
      )
    end
    let(:vm_type_double_cluster) do
      base_vm_type.merge(
        'datacenters' => [
          {
            'name' => @datacenter_name,
            'clusters' => [
              {
                @cluster_name => {}
              },
              {
                @second_cluster_name => {}
              },
            ]
          }
        ]
      )
    end
    context 'when ephemeral datastore is accessible from GPU host' do
      let(:vm_type_double_cluster_acc_ds) do
        vm_type_double_cluster.merge(
          'datastores' => [@gpu_host_datastore_one]
        )
      end

      context 'when vm_type specifies 0 GPUs' do
        let(:vm_type_double_cluster_acc_ds_0_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 0}
          )
        end
        it 'creates vm in one of the cluster defined in `vm_type_double_cluster_acc_ds_0_gpu` with 0 gpus' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_double_cluster_acc_ds_0_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@second_cluster_name)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(0)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when vm_type specifies 1 GPU' do
        let(:vm_type_double_cluster_acc_ds_1_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 1}
          )
        end
        it 'creates vm in one of the cluster defined in `vm_type_double_cluster_acc_ds_1_gpu` with 1 GPU' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_double_cluster_acc_ds_1_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name).or (eq(@second_cluster_name))
            expect(vm.mob.runtime.host.name).to eq(@host_1).or (eq(@host_2))
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when vm_type specifies 4 GPU' do
        let(:vm_type_double_cluster_acc_ds_4_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 4}
          )
        end
        it 'creates vm in cluster-1 defined in `vm_type_double_cluster_acc_ds_4_gpu` with 4 GPUs' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_double_cluster_acc_ds_4_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_1)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(4)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
      end

      context 'when we create multiple vms with GPU' do
        let(:vm_type_double_cluster_acc_ds_4_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 4}
          )
        end
        let(:vm_type_double_cluster_acc_ds_1_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 1}
          )
        end
        let(:vm_type_double_cluster_acc_ds_2_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 2}
          )
        end
        context 'when cpi creates vms with 4,1 and 1 gpus in succession' do
          xit 'creates all three vms, first vm on cluster-2 and second on cluster-2 and third vm on cluster-1' do
            begin
              vm_id_1 = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_double_cluster_acc_ds_4_gpu,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id_1).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_1)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_3)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(4)

              vm_id_2 = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_double_cluster_acc_ds_1_gpu,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id_2).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_2)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_2)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)

              vm_id_3 = cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_double_cluster_acc_ds_2_gpu,
                get_network_spec,
                [],
                {}
              )
              expect(vm_id_3).to_not be_nil

              vm = cpi.vm_provider.find(vm_id_3)
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_1)
              expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(2)
            ensure
              delete_vm(cpi, vm_id_1)
              delete_vm(cpi, vm_id_2)
              delete_vm(cpi, vm_id_3)
            end
          end
        end
      end

      context 'when vm_type specifies GPUs more than available on any host' do
        let(:vm_type_double_cluster_acc_ds_5_gpu) do
          vm_type_double_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 5}
          )
        end
        it 'fails to creates vm in any cluster defined in `vm_type_double_cluster_acc_ds_5_gpu`' do
          begin
            expect {
              cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type_double_cluster_acc_ds_5_gpu,
                get_network_spec,
                [],
                {}
              )
            }.to raise_error(/no active host found with.*free gpus/)
          end
        end
      end
    end

    context 'when ephemeral datastore is not accessible from GPU host' do
      let(:vm_type_double_cluster_non_acc_ds) do
        vm_type_double_cluster.merge(
          'gpu' => { 'number_of_gpus' => 5}
        )
      end
      it 'fails to creates vm in any cluster defined in `vm_type_double_cluster_non_acc_ds`' do
        begin
          expect {
            cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_double_cluster_non_acc_ds,
              get_network_spec,
              [],
              {}
            )
          }.to raise_error(/.*/)
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

      context 'when vm_type specifies 1 GPU' do
        let(:vm_type_single_cluster_acc_ds_1_gpu) do
          vm_type_single_cluster_acc_ds.merge(
            'gpu' => { 'number_of_gpus' => 1}
          )
        end
        it 'creates vm in the cluster on host with 2 gpus' do
          begin
            vm_id = cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type_single_cluster_acc_ds_1_gpu,
              get_network_spec,
              [],
              {}
            )
            expect(vm_id).to_not be_nil

            vm = cpi.vm_provider.find(vm_id)
            expect(vm).to_not be_nil
            expect(vm.cluster).to eq(@second_cluster_name)
            expect(vm.mob.runtime.host.name).to eq(@host_2)
            expect(vm.mob.config.hardware.device).to have_number_of_GPU_eql_to(1)
          ensure
            delete_vm(cpi, vm_id)
          end
        end
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
              expect(vm).to_not be_nil
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
              expect(vm).to_not be_nil
              expect(vm.cluster).to eq(@second_cluster_name)
              expect(vm.mob.runtime.host.name).to eq(@host_3)
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
end

