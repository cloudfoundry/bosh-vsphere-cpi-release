require 'spec_helper'

module VSphereCloud
  describe IPConflictDetector, fake_logger: true do
    let(:network_one_name) { 'network_1' }
    let(:network_two_name) { 'network_2' }
    let(:networks) do
      {
        network_one_name => ['169.254.1.1'],
        network_two_name => ['169.254.2.1', '169.254.3.1']
      }
    end
    let(:client) { instance_double(VSphereCloud::VCenterClient) }
    let(:datacenter) { instance_double(VSphereCloud::Resources::Datacenter) }

    context 'when no existing VMs on a desired network report having the desired IP' do
      it 'does not detect a conflict with deployed VMs' do
        allow(client).to receive(:find_vm_by_ip).and_return(nil)

        conflict_detector = IPConflictDetector.new(client, datacenter)
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
        context 'when the passed network name is unqualified name of same network' do
          let(:networks) do
            { network_one_name => ['169.254.1.1'] }
          end
          let(:deployed_vm_nics) do
            [
                instance_double(
                    VimSdk::Vim::Vm::GuestInfo::NicInfo,
                    ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                    network: network_one_name
                ),
            ]
          end
          let(:network_mob) { instance_double(VimSdk::Vim::Network, vm: [deployed_vm] ) }

          context 'when find network returns the correct single network' do
            it 'detects conflicts with deployed VMs' do
              expect(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              expect(client).to receive(:find_network).with(datacenter, network_one_name).and_return(network_mob)
              conflict_detector =  IPConflictDetector.new(client, datacenter)
              expect {conflict_detector.ensure_no_conflicts(networks)}.to raise_error(/Detected IP/)
            end
          end
          context 'when find network raises multiple network found exception' do
            it 'raises and passes on the exception' do
              expect(client).to receive(:find_network).with(datacenter, network_one_name).and_raise("Multiple N/W Found")
              expect(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              conflict_detector = IPConflictDetector.new(client, datacenter)
              expect { conflict_detector.ensure_no_conflicts(networks)}.to raise_error(/Multiple N\/W/)
            end
          end
        end
        context 'when the passed network name is fully qualified name of same network' do
          let(:networks) do
            { network_one_name => ['169.254.1.1'] }
          end
          let(:network_one_name) { 'folder-1/switch-1/network_1' }
          let(:deployed_vm_nics) do
            [
                instance_double(
                    VimSdk::Vim::Vm::GuestInfo::NicInfo,
                    ip_address: ['169.254.1.1', 'fe80::250:56ff:fea9:793d'],
                    network: 'network_1'
                )
            ]
          end
          let(:network_mob) { instance_double(VimSdk::Vim::Network, vm: [deployed_vm] ) }

          context 'when the network has that VM on it' do
            it 'detects conflict' do
              expect(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              expect(client).to receive(:find_network).with(datacenter, network_one_name).and_return(network_mob)
              conflict_detector = IPConflictDetector.new(client,datacenter)
              expect do
                conflict_detector.ensure_no_conflicts(networks)
              end.to raise_error(/Detected IP conflicts/)
            end
          end
          context 'when the network does not have that VM on it' do
            let(:network_mob) { instance_double(VimSdk::Vim::Network, vm: [] ) }
            it 'returns empty conflict list' do
              expect(client).to receive(:find_network).with(datacenter, network_one_name).and_return(network_mob)
              expect(client).to receive(:find_vm_by_ip).with('169.254.1.1').and_return(deployed_vm)
              conflict_detector = IPConflictDetector.new(client,datacenter)
              expect do
                conflict_detector.ensure_no_conflicts(networks)
              end.to_not raise_error
            end
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
          conflict_detector = IPConflictDetector.new(client, datacenter)
          expect {
            conflict_detector.ensure_no_conflicts(networks)
          }.to_not raise_error
        end
      end
    end
  end
end
