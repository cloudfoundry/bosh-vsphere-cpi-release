require 'rspec'
require 'spec_helper'

describe 'BATs environment' do
  before do
    expect(ENV.has_key?('BOSH_VSPHERE_VCENTER')).to be true
    expect(ENV.has_key?('BOSH_VSPHERE_VCENTER_USER')).to be true
    expect(ENV.has_key?('BOSH_VSPHERE_VCENTER_PASSWORD')).to be true

    config = VSphereSpecConfig.new
    config.logger = logger
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)
  end

  let(:logger) do
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
  end
  let(:client) do
    vcenter_host = ENV['BOSH_VSPHERE_VCENTER']
    vcenter_user = ENV['BOSH_VSPHERE_VCENTER_USER']
    vcenter_password = ENV['BOSH_VSPHERE_VCENTER_PASSWORD']
    client = VSphereCloud::VCenterClient.new(
      vcenter_api_uri: URI.parse("https://#{vcenter_host}/sdk/vimService"),
      http_client: VSphereCloud::CpiHttpClient.new(logger),
      logger: logger,
    )
    client.login(vcenter_user, vcenter_password, 'en')

    client
  end

  it 'should be using the correct version of vSphere' do
    expected_version = ENV['BOSH_VSPHERE_VERSION']
    skip 'No expected version of vSphere specified' if expected_version.nil?
    actual_version = client.service_content.about.version
    fail("vSphere version #{expected_version} required. Found #{actual_version}.") if expected_version != actual_version
  end
end
