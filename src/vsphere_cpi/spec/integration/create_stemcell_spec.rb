require 'rspec'
require 'integration/spec_helper'

describe '#create_stemcell', fake_logger: true do
  let(:opts) {cpi_options('default_disk_type' => 'thin')}
  subject(:cpi) do
    VSphereCloud::Cloud.new(opts)
  end

  after do
    cpi.cleanup
  end

  context 'when only datastore clusters are specified' do
    let(:ds_cluster_pattern) {
      ds_cluster_name = fetch_and_verify_datastore_cluster('BOSH_VSPHERE_CPI_DATASTORE_CLUSTER')
      "^#{Regexp.escape(ds_cluster_name)}$"
    }
    let(:opts) {cpi_options('default_disk_type' => 'thin',
                            'datastore_pattern' => '',
                            'datastore_cluster_pattern' => ds_cluster_pattern,
    )}
    it 'creates a stemcell' do
      VSphereCloud::Resources::VM.new(
        @stemcell_id,
        @cpi.client.find_vm_by_name(@cpi.datacenter.mob, @stemcell_id),
        @cpi.client
      )
    end
  end

  context 'when "default_disk_type" is not set' do
    it 'creates a stemcell with preallocated system disk' do
      stemcell = VSphereCloud::Resources::VM.new(
        @stemcell_id,
        @cpi.client.find_vm_by_name(@cpi.datacenter.mob, @stemcell_id),
        @cpi.client
      )
      expect(stemcell.system_disk.backing.thin_provisioned).to be(false)
    end
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
