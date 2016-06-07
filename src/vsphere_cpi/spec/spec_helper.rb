$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  project_root = File.expand_path('../../../..', __FILE__)
  SimpleCov.coverage_dir(File.join(project_root, 'coverage'))
  SimpleCov.start
end

require 'fakefs/spec_helpers'

require 'cloud'
require 'cloud/vsphere'

require 'base64'

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
