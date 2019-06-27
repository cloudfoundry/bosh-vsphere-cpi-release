require 'rspec'
require 'integration/spec_helper'
require 'cloud/vsphere/cpi_extension'

describe '#add cpi extension' do
  before(:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_SECOND_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE', @cluster_name)
  end

  subject(:cpi) do
    VSphereCloud::Cloud.new(cpi_options('default_disk_type' => 'thin'))
  end

  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.1.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @vlan },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end
  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  context 'when it creates a stemcell on vsphere' do
    # Safety before to make sure environemnt does not
    # have any CPI extension when it starts
    before(:each) do
      begin
        cpi.client.service_content.extension_manager.unregister_extension(VSphereCloud::VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
      rescue
      end
    end
    it 'adds an extension to vcenter and attaches stemcell to that extension' do
      begin
        stemcell_id = upload_stemcell(cpi)
        stemcell_vm = @cpi.client.find_vm_by_name(@cpi.datacenter.mob,
                                                  stemcell_id)
        key = stemcell_vm.config.managed_by.extension_key
        ext = @cpi.client.service_content.extension_manager.find_extension(key)
        expect(key).to eql(VSphereCloud::VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
        expect(ext.shown_in_solution_manager).to be true
      ensure
        cpi.delete_stemcell(stemcell_id)
      end
    end
  end

  context 'when it replicates a stemcell on vsphere' do
    let(:second_cluster_cpi) do
      options = cpi_options(
        datacenters: [{
          clusters: [@cluster_name],
          datastore_pattern: @datastore_pattern,
          persistent_datastore_pattern: @datastore_pattern
        }],
      )
      VSphereCloud::Cloud.new(options)
    end

    it 'adds replicated stemcell and vm to extension' do
      begin
        @vm_cid = second_cluster_cpi.create_vm(
          'agent-007',
          @stemcell_id,
          vm_type,
          network_spec,
          [],
          {'key' => 'value'}
        )
        vm = second_cluster_cpi.client.find_vm_by_name(second_cluster_cpi.datacenter.mob, @vm_cid)
        expect(vm.config.managed_by.extension_key).to eql(VSphereCloud::VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
        stemcell_replicas = second_cluster_cpi.client.find_all_stemcell_replicas(second_cluster_cpi.datacenter.mob, @stemcell_id)
        stemcell_replicas.each do |stemcell_mob|
          expect(stemcell_mob.config.managed_by.extension_key).to eql(VSphereCloud::VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
        end
      ensure
        delete_vm(second_cluster_cpi, @vm_cid)
      end
    end
  end

  context 'when extension does not exist and it creates a vm on vsphere' do
    before do
      begin
        cpi.client.service_content.extension_manager.unregister_extension(VSphereCloud::VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
      rescue
      end
    end

    after do
      cpi.delete_vm(@vm_cid) if @vm_cid
    end

    it 'does not add VM to the CPI extension' do
      @vm_cid = cpi.create_vm(
        'agent-007',
        @stemcell_id,
        vm_type,
        network_spec,
        [],
        {'key' => 'value'}
      )
      vm = @cpi.client.find_vm_by_name(@cpi.datacenter.mob, @vm_cid)
      expect(vm.config.managed_by).to be_nil
    end
  end
end
