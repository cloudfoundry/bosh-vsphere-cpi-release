require 'integration/spec_helper'

describe 're-attaching a persistent disk' do
  before(:all) do
    @datacenter_name = fetch_and_verify_datacenter('BOSH_VSPHERE_CPI_DATACENTER')
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @second_cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE', @second_cluster_name)
  end
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

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when vm_type has disk uuid enabled in vmx options' do
    let(:vm_type) do
      {
          'ram' => 512,
          'disk' => 2048,
          'cpu' => 1,
          'vmx_options' => {
              'disk.enableUUID' => 'TRUE'
          }
      }
    end

    it 're-attaches the disk without locking the cd-rom' do
      begin
        vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
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

    context 'when there is no datastore matching pattern to move the disk to' do
      let(:both_cluster_cpi_options) do
        cpi_options(
            datacenters: [{
                              persistent_datastore_pattern: @second_datastore_pattern,
                              clusters: [@cluster_name, @second_cluster_name],
                          }],
            )
      end
      let(:both_cluster_cpi) { VSphereCloud::Cloud.new(both_cluster_cpi_options) }

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

      let(:vm_type) do
        {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datastores' => [@datastore_pattern],
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
        }
      end
      it 'raises error ' do
        begin
          vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              network_spec,
              [],
              {'key' => 'value'}
          )

          expect(vm_id).to_not be_nil
          expect(@cpi.has_vm?(vm_id)).to be(true)

          disk_id = both_cluster_cpi.create_disk(2048, {datastores: @second_datastore_pattern})
          expect(disk_id).to_not be_nil

          expect do
            both_cluster_cpi.attach_disk(vm_id, disk_id)
          end.to raise_error(/Unable to attach disk to the VM/)
        ensure
          delete_vm(@cpi, vm_id)
          delete_disk(both_cluster_cpi, disk_id)
        end
      end
    end
  end

  context 'when vm_type has no disk uuid enabled' do
    it 're-attaches the disk without locking the cd-rom' do
      begin
        vm_id = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
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

    context 'when there is no datastore matching pattern to move the disk to' do
      let(:both_cluster_cpi_options) do
        cpi_options(
            datacenters: [{
                              persistent_datastore_pattern: @second_datastore_pattern,
                              clusters: [@cluster_name, @second_cluster_name],
                          }],
            )
      end
      let(:both_cluster_cpi) { VSphereCloud::Cloud.new(both_cluster_cpi_options) }

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

      let(:vm_type) do
        {
            'ram' => 512,
            'disk' => 2048,
            'cpu' => 1,
            'datastores' => [@datastore_pattern],
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
        }
      end
      it 'raises error ' do
        begin
          vm_id = @cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              network_spec,
              [],
              {'key' => 'value'}
          )

          expect(vm_id).to_not be_nil
          expect(@cpi.has_vm?(vm_id)).to be(true)

          disk_id = both_cluster_cpi.create_disk(2048, {datastores: @second_datastore_pattern})
          expect(disk_id).to_not be_nil

          expect do
            both_cluster_cpi.attach_disk(vm_id, disk_id)
          end.to raise_error(/Unable to attach disk to the VM/)
        ensure
          delete_vm(@cpi, vm_id)
          delete_disk(both_cluster_cpi, disk_id)
        end
      end
    end
  end

end
