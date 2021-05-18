require 'rspec'
require 'integration/spec_helper'

describe '#add advanced cpi config' do
  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options('default_disk_type' => 'thin'))
  end

  after do
    cpi.cleanup
  end

  context 'when it creates a stemcell on vsphere' do
    it 'add an advanced cpi config config.SDDC.cpi to vpxd.cfg file' do
      begin
        stemcell_id = upload_stemcell(cpi)
        cpi_advanced_prop_key='config.SDDC.cpi'
        cpi_advanced_prop_value = cpi.client.service_content.setting.query_view(cpi_advanced_prop_key).first.value
        expect(cpi_advanced_prop_value).to eql('true')
      ensure
        cpi.delete_stemcell(stemcell_id)
      end
    end
  end
end