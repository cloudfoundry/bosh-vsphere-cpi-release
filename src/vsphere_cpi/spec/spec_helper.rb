require 'fakefs/spec_helpers'

require 'cloud'
require 'cloud/vsphere'

Dir[Pathname(__FILE__).parent.join('support', '**/*.rb')].each { |file| require file }

class VSphereSpecConfig
  attr_accessor :logger, :uuid
end
