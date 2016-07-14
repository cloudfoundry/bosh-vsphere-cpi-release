require 'spec_helper'

RSpec.configure do |config|
  include LifecycleProperties
  config.include LifecycleHelpers

  config.before(:all) do
    config = VSphereSpecConfig.new
    config.logger = Logger.new(STDOUT)
    config.logger.level = Logger::DEBUG
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)

    @logger = config.logger

    fetch_properties
    verify_properties

    @cpi = VSphereCloud::Cloud.new(cpi_options)

    Dir.mktmpdir do |temp_dir|
      stemcell_image = stemcell_image(@stemcell_path, temp_dir)
      @stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
    end
  end

  config.after(:all) do
    delete_stemcell(@cpi, @stemcell_id)
  end
end
