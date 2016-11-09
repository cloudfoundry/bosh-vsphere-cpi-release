require 'spec_helper'

RSpec.configure do |rspec_config|
  include LifecycleProperties
  include LifecycleHelpers

  # before(:suite) and before(:all) seem to run in different contexts
  # so we can't assign directly to @stemcell; using a closure instead
  stemcell_id = nil

  rspec_config.before(:suite) do
    setup_global_config
    fetch_global_properties

    @suite_cpi = VSphereCloud::Cloud.new(cpi_options)

    Dir.mktmpdir do |temp_dir|
      stemcell_image = stemcell_image(@stemcell_path, temp_dir)
      # stemcell uploads are slow on local vSphere, only upload once
      stemcell_id = @suite_cpi.create_stemcell(stemcell_image, nil)
    end
  end

  rspec_config.before(:all) do
    setup_global_config
    fetch_global_properties

    @cpi = VSphereCloud::Cloud.new(cpi_options)
    @stemcell_id = stemcell_id
  end

  rspec_config.after(:all) do
    @cpi.cleanup
  end

  rspec_config.after(:suite) do
    delete_stemcell(@suite_cpi, stemcell_id)
  end
end
