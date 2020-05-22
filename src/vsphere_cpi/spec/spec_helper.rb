$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  project_root = File.expand_path('../../../..', __FILE__)
  SimpleCov.coverage_dir(File.join(project_root, 'coverage'))
  SimpleCov.start do
    add_filter '/nsxt/'
    add_filter '/spec/'
  end
end

PROJECT_RUBY_VERSION = ENV.fetch('PROJECT_RUBY_VERSION', '2.6.5')

require 'fakefs/spec_helpers'

require 'vapi_version'
require 'cloud'

def get_vc_version()
  require 'cloud/vsphere/cpi_http_client'
  require 'cloud/vsphere/retryer'
  require 'cloud/vsphere/logger'
  require 'cloud/vsphere/base_http_client'
  require 'cloud/vsphere/sdk_helpers/log_filter'
  require 'nokogiri'

  begin
    http_client = VSphereCloud::CpiHttpClient.new()
    url = "https://#{ENV["BOSH_VSPHERE_CPI_HOST"]}/sdk/vimServiceVersions.xml"

    response = VSphereCloud::Retryer.new.try do
      resp = http_client.get(url, {})
      if resp.code >= 400
        err = "Could not fetch '#{url}', received status code '#{resp.code}'"
        Bosh::Clouds::Config.logger.warn(err)
        [nil, RuntimeError.new(err)]
      else
        [resp, nil]
      end
    end
    VAPIVersionDiscriminant.vapi_version(Nokogiri.XML(response.body))
  rescue
    '6.5'
  end
end


$vc_version = get_vc_version()
require 'cloud/vsphere'
require 'base64'

Dir[Pathname(__FILE__).parent.join('support', '**/*.rb')].each { |file| require file }

class VSphereSpecConfig
  attr_accessor :logger, :uuid
end

RSpec.shared_context 'with a fake logger' do
  require 'cloud/vsphere/logger'
  before { VSphereCloud::Logger.logger = logger }
  let(:logger) { Logger.new(StringIO.new('')) }
end

RSpec.shared_context 'with fast retries' do
  require 'bosh/cpi'
  before do
    allow_any_instance_of(Bosh::Retryable).to receive(:sleep).with(any_args)
  end
end

RSpec.configure do |config|
  config.include Support

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  config.before do
    expect(RUBY_VERSION).to eq(PROJECT_RUBY_VERSION)
  end

  config.include_context 'with a fake logger', fake_logger: true
  config.include_context 'with fast retries', fast_retries: true
end

# Silence output from pending examples in documentation formatter
module FormatterOverrides
  def example_pending(_)
  end

  def dump_pending(_)
  end
end

RSpec::Core::Formatters::DocumentationFormatter.prepend FormatterOverrides

# Silence output from pending examples in progress formatter
RSpec::Core::Formatters::ProgressFormatter.prepend FormatterOverrides