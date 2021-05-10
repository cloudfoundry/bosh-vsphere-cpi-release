require 'spec_helper'

RSpec.configure do |rspec_config|
  include LifecycleProperties
  include LifecycleHelpers

  # so we can't assign directly to @stemcell; using a closure instead
  # https://relishapp.com/rspec/rspec-core/v/3-10/docs/hooks/before-and-after-hooks
  # "WARNING: Setting instance variables are not supported in before(:suite)."
  stemcell_id = nil

  rspec_config.before(:suite) do
    setup_global_config
    fetch_global_properties

    bosh_vsphere_stemcell_id = ENV.fetch('BOSH_VSPHERE_STEMCELL_ID', '')
    if bosh_vsphere_stemcell_id.empty?
      Dir.mktmpdir do |temp_dir|
        stemcell_image = stemcell_image(@stemcell_path, temp_dir)
        # stemcell uploads are slow on local vSphere, only upload once
        stemcell_id = @lifecycle_cpi.create_stemcell(stemcell_image, nil)
      end
    else
      stemcell_vm = @lifecycle_cpi.stemcell_vm(bosh_vsphere_stemcell_id)
      if stemcell_vm.nil?
        raise "Could not find VM for stemcell '#{bosh_vsphere_stemcell_id}'"
      end

      stemcell_id = bosh_vsphere_stemcell_id
    end
    @lifecycle_cpi.cleanup
  end

  rspec_config.before(:all) do
    setup_global_config
    fetch_global_properties

    @cpi = @lifecycle_cpi
    @stemcell_id = stemcell_id
  end

  rspec_config.after(:all) do
    @cpi.cleanup
  end

  rspec_config.after(:suite) do
    setup_global_config
    fetch_global_properties

    if ENV.fetch('BOSH_VSPHERE_STEMCELL_ID', '').empty?
      delete_stemcell(@lifecycle_cpi, stemcell_id)
    end
    @lifecycle_cpi.cleanup
  end
end
