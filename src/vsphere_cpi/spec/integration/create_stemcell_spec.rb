require 'rspec'
require 'integration/spec_helper'

describe '#create_stemcell', fake_logger: true do
  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options('default_disk_type' => 'thin'))
  end

  it 'creates a stemcell with preallocated system disk' do
    stemcell = VSphereCloud::Resources::VM.new(
      @stemcell_id,
      @cpi.client.find_vm_by_name(@cpi.datacenter.mob, @stemcell_id),
      @cpi.client
    )
    expect(stemcell.system_disk.backing.thin_provisioned).to be(false)
  end

  context 'when "default_disk_type" is set to "thin" provisioning' do
    it 'creates a stemcell with thin provisioned system disk' do
      begin
        stemcell_id = upload_stemcell(cpi)
        stemcell = VSphereCloud::Resources::VM.new(
          stemcell_id,
          cpi.client.find_vm_by_name(cpi.datacenter.mob, stemcell_id),
          cpi.client
        )
        expect(stemcell.system_disk.backing.thin_provisioned).to be(true)
      ensure
        cpi.delete_stemcell(stemcell_id)
      end
    end
  end
end