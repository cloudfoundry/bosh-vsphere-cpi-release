require 'spec_helper'

module VSphereCloud
  describe IPConflictDetector do
    let(:networks) do
      {
        'network_1' => ['169.254.1.1'],
        'network_2' => ['169.254.2.1', '169.254.3.1']
      }
    end
    let(:logger) { double('logger', debug: nil, info: nil) }
    let(:client) { instance_double(VSphereCloud::VCenterClient) }

    context 'when no existing VMs on a desired network report having the desired IP' do
      it 'does not detect a conflict with deployed VMs' do
        allow(client).to receive(:find_vm_by_ip).and_return(nil)

        conflict_detector = IPConflictDetector.new(logger, client)
        expect {
          conflict_detector.ensure_no_conflicts(networks)
        }.to_not raise_error
      end
    end

    context 'when existing VMs on a desired network report having the desired IP' do
      let(:deployed_vm) do
        instance_double(
          VimSdk::Vim::VirtualMachine,
          name: 'squatter-vm',
          guest: instance_double(VimSdk::Vim::Vm::GuestInfo, net: deployed_vm_nics)
        )
      end

      context 'when a deployed VM has the desired IPs on the same network' do
        let(:deployed_vm_nics) do
          [
            instance_double(
              VimSdk::Vim::Vm::GuestInfo::NicInfo,
              ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_1'
            ),
            instance_double(
              VimSdk::Vim::Vm::GuestInfo::NicInfo,
              ip_address: ['169.254.2.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_2'
            ),
            instance_double(
              VimSdk::Vim::Vm::GuestInfo::NicInfo,
              ip_address: ['169.254.3.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_2'
            )
          ]
        end

        it 'detects conflicts with deployed VMs' do
          allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.3.1').and_return(deployed_vm)

          conflict_detector = IPConflictDetector.new(logger, client)
          expect {
            conflict_detector.ensure_no_conflicts(networks)
          }.to raise_error do |error|
            expect(error.message).to include(
              "squatter-vm",
              "network_1",
              "169.254.1.1",
              "network_2",
              "169.254.2.1",
              "network_2",
              "169.254.3.1"
            )
          end
        end
      end

      context 'when a deployed VM has the desired IPs on a different network' do
        let(:deployed_vm_nics) do
          [
            instance_double(VimSdk::Vim::Vm::GuestInfo::NicInfo,
              ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_3'
            ),
            instance_double(VimSdk::Vim::Vm::GuestInfo::NicInfo,
              ip_address: ['169.254.2.1', 'fe80::250:56ff:fea9:793d'],
              network: 'network_4'
            )
          ]
        end

        it 'does not detect conflicts with deployed VMs' do
          allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.3.1').and_return(deployed_vm)
          conflict_detector = IPConflictDetector.new(logger, client)
          expect {
            conflict_detector.ensure_no_conflicts(networks)
          }.to_not raise_error
        end
      end
    end
  end
end
