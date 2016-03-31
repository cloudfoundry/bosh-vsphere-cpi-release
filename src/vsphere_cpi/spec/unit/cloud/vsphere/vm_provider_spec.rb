require 'spec_helper'

describe VSphereCloud::VMProvider do
  subject(:vm_provider) { described_class.new(datacenter, client, logger) }
  let(:datacenter) { instance_double('VSphereCloud::Resources::Datacenter') }
  let(:client) { instance_double('VSphereCloud::VCenterClient') }
  let(:logger) { instance_double('Logger') }

  describe 'find' do
    before do
      allow(datacenter).to receive(:name).and_return('datacenter1')
      allow(datacenter).to receive(:mob).and_return('datacenter-mob')
    end

    context 'when vm can not be found in any datacenter' do
      before do
        allow(client).to receive(:find_vm_by_name).with('datacenter-mob', 'fake-vm-cid').and_return(nil)
      end

      it 'raises VMNotFound error' do
        expect {
          vm_provider.find('fake-vm-cid')
        }.to raise_error Bosh::Clouds::VMNotFound, "VM 'fake-vm-cid' not found in datacenter 'datacenter1'"
      end
    end

    context 'when vm is found in one of datacenter' do
      let(:vm_mob) { double(:vm) }
      before do
        allow(client).to receive(:find_vm_by_name).with('datacenter-mob', 'fake-vm-cid').and_return(vm_mob)
      end

      it 'returns vm' do
        vm = vm_provider.find('fake-vm-cid')
        expect(vm.cid).to eq('fake-vm-cid')
        expect(vm.mob).to eq(vm_mob)
      end
    end
  end
end
