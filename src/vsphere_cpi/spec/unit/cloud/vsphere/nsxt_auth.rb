require 'digest'
require 'spec_helper'

module VSphereCloud
  describe NSXTConfig do
    subject(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-passowrd') }
    let(:logger) { instance_double('Logger') }
    before { allow(Bosh::Clouds::Config).to receive(:logger).and_return(logger) }

    before(:each) do
        @configuration = NSXT::Configuration.new
        @configuration.host = nsxt_config.host
        @configuration.username = nsxt_config.username
        @configuration.password = nsxt_config.password
        @configuration
    end

    context "remote_auth not set" do
      before(:each) do
        @configuration.remote_auth = nil
      end

      it 'should have Authorization header start with "Basic"' do
        expect(@configuration.nsxt_auth_token).to start_with('Basic ')
      end
    end

    context "remote_auth set to false" do
      before(:each) do
        @configuration.remote_auth = false
      end

      it 'should have Authorization header start with "Basic"' do
        expect(@configuration.nsxt_auth_token).to start_with('Basic ')
      end
    end

    context "remote_auth set to true" do
      before(:each) do
        @configuration.remote_auth = true
      end

      it 'should have Authorization header start with "Basic"' do
        expect(@configuration.nsxt_auth_token).to start_with('Remote ')
      end
    end
  end
end
