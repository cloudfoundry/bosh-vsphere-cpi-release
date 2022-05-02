$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
project_root = File.expand_path('../../../..', __FILE__)
project_ruby_version = File.read(File.join(project_root, '.ruby-version')).strip

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.coverage_dir(File.join(project_root, 'coverage'))
  SimpleCov.start do
    add_filter '/nsxt_manager_client/'
    add_filter '/nsxt_policy_client/'
    add_filter '/spec/'
  end
end

require 'fakefs/spec_helpers'

require 'vmodl_version'
require 'cloud'

# Use a closure here so that local variables don't escape to the actual tests
proc {
  host = ENV["BOSH_VSPHERE_CPI_HOST"]
  logger = Logger.new(STDERR)
  $vc_version = VmodlVersionDiscriminant.retrieve_vmodl_version(host, logger)
}.call if ENV["BOSH_VSPHERE_CPI_HOST"]

# set $vc_version for unit tests
$vc_version = '6.5' if $vc_version.nil?

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
    mocks.allow_message_expectations_on_nil = true
  end

  config.before do
    expect(RUBY_VERSION).to eq(project_ruby_version)
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
