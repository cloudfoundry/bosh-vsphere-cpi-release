require 'integration/spec_helper'

describe 'enable human readable names' do
  let(:vm_type) do
    {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
    }
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => {'name' => @vlan},
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:human_readable_name_cpi) do
    options = cpi_options({'enable_human_readable_name' => true})
    VSphereCloud::Cloud.new(options)
  end

  let(:machine_name_cpi) do
    options = cpi_options({'enable_human_readable_name' => false})
    VSphereCloud::Cloud.new(options)
  end

  context 'when enable human readable names is set to false' do
    let(:environment){ {'bosh' => { 'groups' => ['fake-director-name', 'fake-deployment-name', 'fake-instance-group-name'] } } }
    it 'create vm with UUID based name' do
      begin
        test_vm_id = machine_name_cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          environment
        )
        expect(test_vm_id).to_not be_nil
        expect(test_vm_id.size).to eq 39 # "vm_" + 36 digits UUID
        expect(test_vm_id).to match /vm-.*/
      ensure
        delete_vm(machine_name_cpi, test_vm_id)
      end
    end
  end

  context 'when enable human readable names is set to true' do
    context 'when instance group name and deployment name are in ASCII characters' do
      context 'when both instance group name and deployment name are set' do
        let(:environment){ {'bosh' => { 'groups' => ['fake-director-name', 'fake-deployment-name', 'fake-instance-group-name'] } } }
        it 'create vm with human readable name' do
          begin
            test_vm_id = human_readable_name_cpi.create_vm(
                'agent-007',
                @stemcell_id,
                vm_type,
                network_spec,
                [],
                environment
            )
            expect(test_vm_id).to_not be_nil
            expect(test_vm_id.size).to eq 58  # "fake-instance-group-name_fake-deployment-name_" + 12 digits suffix
            expect(test_vm_id).to start_with('fake-instance-group-name_fake-deployment-name_')
          ensure
            delete_vm(human_readable_name_cpi, test_vm_id)
          end
        end
      end

      context 'when bosh environment metadata is not in correct format' do
        let(:environment){ {'bosh' => { 'groups' => ['fake-director-name', 'fake-deployment-name'] } } }
        it 'create vm with UUID based name' do
          begin
            test_vm_id = human_readable_name_cpi.create_vm(
              'agent-007',
              @stemcell_id,
              vm_type,
              network_spec,
              [],
              environment
            )
            expect(test_vm_id).to_not be_nil
            expect(test_vm_id.size).to eq 39
            expect(test_vm_id).to match /vm-.*/
          ensure
            delete_vm(human_readable_name_cpi, test_vm_id)
          end
        end
      end
    end

    context 'when instance group name and deployment name contain non_ASCII characters' do
      let(:environment){ {'bosh' => { 'groups' => ['fake-director-name', 'ÅÅÅÅ', 'αβ'] } } }
      it 'create vm with human readable name' do
        begin
          test_vm_id = human_readable_name_cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            environment
          )
          expect(test_vm_id).to_not be_nil
          expect(test_vm_id.size).to eq 39
          expect(test_vm_id).to match /vm-.*/
        ensure
          delete_vm(human_readable_name_cpi, test_vm_id)
        end
      end
    end
  end
end
