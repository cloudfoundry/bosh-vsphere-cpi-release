require 'integration/spec_helper'

describe 'root_disk_size_gb property' do

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when "root_disk_size_gb" is not set' do
    it 'creates a VM whose system disk is a linked-clone to the stemcell' do
      simple_vm_lifecycle(@cpi, @vlan, vm_type) do |vm_id|
        vm = @cpi.vm_provider.find(vm_id)
        stemcell = @cpi.vm_provider.find(@stemcell_id)
        system_disk = vm.system_disk
        stemcell_disk = stemcell.system_disk
        expect(system_disk.backing.parent.uuid).to eq(stemcell_disk.backing.parent.uuid)
      end
    end
  end

  context 'when "root_disk_size_gb" is set' do
    let(:root_disk_size_gb) { 15 }
    it 'creates a VM whose system disk is a linked-clone to the stemcell' do
      vm_type['root_disk_size_gb'] = root_disk_size_gb
      simple_vm_lifecycle(@cpi, @vlan, vm_type) do |vm_id|
        vm = @cpi.vm_provider.find(vm_id)
        system_disk = vm.system_disk
        expect(system_disk.backing.parent).to be_nil # no parent disk, not a linked-clone
        expect(system_disk.capacity_in_kb / 1024 / 1024).to eq(root_disk_size_gb) # convert kiB → GiB
      end
    end
  end
end
