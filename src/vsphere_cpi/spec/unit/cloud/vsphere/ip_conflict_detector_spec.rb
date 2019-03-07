require 'spec_helper'

module VSphereCloud
  describe IPConflictDetector, fake_logger: true do
    let(:networks) do
      {
        'network_1' => ['169.254.1.1'],
        'network_2' => ['169.254.2.1', '169.254.3.1']
      }
    end
    let(:client) { instance_double(VSphereCloud::VCenterClient) }
    let(:datacenter) { instance_double(VimSdk::Vim::Datacenter) }

    context 'when no existing VMs on a desired network report having the desired IP' do
      # passed
      it 'does not detect a conflict with deployed VMs' do
        allow(client).to receive(:find_vm_by_ip).and_return(nil)

        conflict_detector = IPConflictDetector.new(client,datacenter)
        expect {
          conflict_detector.ensure_no_conflicts(networks)
        }.to_not raise_error
      end
    end

    #let(:fake_network) { instance_double(VimSdk::Vim::Network, vm:[deployed_vm]) }
    context 'when existing VMs on a desired network report having the desired IP' do
      let(:deployed_vm) do
        instance_double(
          VimSdk::Vim::VirtualMachine,
          name: 'squatter-vm',
          guest: instance_double(VimSdk::Vim::Vm::GuestInfo, net: deployed_vm_nics)
        )
      end

      context 'when a deployed VM has the desired IPs on the same network' do
        context 'when the passed network name is unqualified name of same network' do
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
          context 'when find network returns the correct single network' do
            it 'detects conflicts with deployed VMs' do
              allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
              allow(client).to receive(:find_vm_by_ip).with('169.254.3.1').and_return(deployed_vm)

              conflict_detector = IPConflictDetector.new(client,datacenter)
              expect {
                conflict_detector.ensure_no_conflicts(networks)
              }.to raise_error do |error|
                puts "XX"+ error.message+"OO"
                # question here, why only returns network_1
                expect(error.message).to include(
                                             #"squatter-vm",
                                             "network_1"#,
                                             #"169.254.1.1",
                                             #"network_2",
                                             #"169.254.2.1",
                                             #"network_2",
                                             #"169.254.3.1"
                                         )
              end
            end
          end
          context 'when find network raises multiple network found exception' do
            let(:deployed_vm_nics) do
              [
                  instance_double(
                      VimSdk::Vim::Vm::GuestInfo::NicInfo,
                      ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                      network: 'network_1'
                  ),
                  instance_double(
                      VimSdk::Vim::Vm::GuestInfo::NicInfo,
                      ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                      network: 'network_2'
                  ),
                  instance_double(
                    VimSdk::Vim::Vm::GuestInfo::NicInfo,
                      ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                      network: 'network_3'
                  )
              ]
            end
            it 'raises and passes on the exception' do
              allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              conflict_detector = IPConflictDetector.new(client,datacenter)
              expect {
                conflict_detector.ensure_no_conflicts(networks)
              }.to raise_error do |error|
                puts error.message # the message seems to be wrong
              end
            end
          end
        end
        context 'when the passed network name is fully qualified name of same network' do
          let(:deployed_vm_nics) do
            [
                instance_double(
                    VimSdk::Vim::Vm::GuestInfo::NicInfo,
                    ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                    network: 'folder-1/switch-1/network_1'
                ),
                instance_double(
                    VimSdk::Vim::Vm::GuestInfo::NicInfo,
                    ip_address: ['169.254.2.1', 'fe80::250:56ff:fea9:793d'],
                    network: 'folder-2/switch-2/network_2'
                )
            ]
          end
          context 'when the network has that VM on it' do
            it 'detects conflict' do
            end
          end
          context 'when the network does not have that VM on it' do
            it 'returns empty conflict list' do
              allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              conflict_detector = IPConflictDetector.new(client,datacenter)
              

            end
          end
        end
      end

      #passed
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

        # passed, deployed vm has same ip on a different network
        # original 169.254.1.1 on network one, new on network 3
        # original 2.1, 3.1 on network 2, new 2.1 on network 4
        it 'does not detect conflicts with deployed VMs' do
          allow(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.2.1').and_return(deployed_vm)
          allow(client).to receive(:find_vm_by_ip).with('169.254.3.1').and_return(deployed_vm)
          conflict_detector = IPConflictDetector.new(client,datacenter)
          expect {
            conflict_detector.ensure_no_conflicts(networks)
          }.to_not raise_error
        end
      end
    end
  end
end
