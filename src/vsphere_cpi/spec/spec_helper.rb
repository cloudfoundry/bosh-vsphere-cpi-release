$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fakefs/spec_helpers'

require 'cloud'
require 'cloud/vsphere'

Dir[Pathname(__FILE__).parent.join('support', '**/*.rb')].each { |file| require file }

class VSphereSpecConfig
  attr_accessor :logger, :uuid
end

RSpec.configure do |config|
  config.include Support

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
