require 'spec_helper'

module VSphereCloud
  describe IPConflictDetector do
    let(:network_spec) do
      {
        'private_1' => {
          'ip' => '169.254.1.1',
          'netmask' => '255.255.254.0',
          'cloud_properties' => {'name' => 'network_1'},
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        },
        'private_2' => {
          'ip' => '169.254.2.1',
          'netmask' => '255.255.254.0',
          'cloud_properties' => {'name' => 'network_2'},
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.2.2'],
          'gateway' => '169.254.2.3'
        }
      }
    end
    let(:logger) { double('logger', debug: nil, info: nil) }
    let(:client) { instance_double('Client') }

    context 'when no existing VMs on a desired network report having the desired IP' do
      it 'does not detect a conflict with deployed VMs' do
        allow(client).to receive(:find_vm_by_ip).and_return(nil)

        expect(IPConflictDetector.new(logger, client, network_spec).conflicts).to be_empty
      end
    end

    context 'when existing VMs on a desired network report having the desired IP' do
      let(:deployed_vm) do
        instance_double('VimSdk::Vim::VirtualMachine',
          name: 'squatter-vm',
          guest: instance_double('VimSdk::Vim::VirtualMachine::GuestInfo', net: deployed_vm_nics)
        )
      end

      context 'when a deployed VM has the desired IPs on the same network' do
        let(:deployed_vm_nics) do
          [
            instance_double('VimSdk::Vim::VirtualMachine::GuestInfo::NicInfo',
              ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_1'
            ),
            instance_double('VimSdk::Vim::VirtualMachine::GuestInfo::NicInfo',
              ip_address: ['169.254.2.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_2'
            )
          ]
        end

        it 'detects conflicts with deployed VMs' do
          allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
          expect(IPConflictDetector.new(logger, client, network_spec).conflicts).to match_array([
            {vm_name: deployed_vm.name, network_name: 'network_1', ip: '169.254.1.1'},
            {vm_name: deployed_vm.name, network_name: 'network_2', ip: '169.254.2.1'}
          ])
        end
      end

      context 'when a deployed VM has the desired IPs on a different network' do
        let(:deployed_vm_nics) do
          [
            instance_double('VimSdk::Vim::VirtualMachine::GuestInfo::NicInfo',
              ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_3'
            ),
            instance_double('VimSdk::Vim::VirtualMachine::GuestInfo::NicInfo',
              ip_address: ['169.254.2.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_4'
            )
          ]
        end

        it 'does not detect conflicts with deployed VMs' do
          allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
          expect(IPConflictDetector.new(logger, client, network_spec).conflicts).to be_empty
        end
      end
    end
  end
end
