require 'integration/spec_helper'
require 'pathname'

context 'CPI plugin', {:order => :defined} do
  @packages_dir_env_var = nil
  let(:configured_plugin_options) { { "size" => 2 } }
  let(:rel_path_to_plugin_load_path) { File.dirname(__FILE__) + "/../../../cpi_plugins/example/src" }

  ## To find plugin code somewhere other than in '/var/vcap/packages', the plugin loader relies
  ## on BOSH_PACKAGES_DIR being set to that directory.
  before (:each) do
    @packages_dir_env_var = ENV['BOSH_PACKAGES_DIR']
    ENV['BOSH_PACKAGES_DIR'] = Pathname.new(rel_path_to_plugin_load_path).cleanpath.to_s
  end

  after (:each) do
    ENV['BOSH_PACKAGES_DIR'] = @packages_dir_env_var
  end

  it 'correctly loads and calls the plugin code' do
    cpi = nil

    ## Ensure plugin load succeeds.
    ##
    ## NOTE: This initialization is here rather than in a let because we cannot properly sequence
    ## RSpec test runs. If for some reason the CPI construction fails to load the plugin code,
    ## it will throw. This throw means that we will never get a chance to run the follow-on tests.
    ## So, if we broke this into two tests, they both would fail with the same error... which is
    ## pretty pointless.
    expect {
      cpi = VSphereCloud::Cloud.new(
        cpi_options({:plugins => { :example => configured_plugin_options } }))
      }.to_not raise_error

    ## Call into the example plugin code.
    expect { cpi.has_vm?("bogus_cid") }.to_not raise_error

    ## Ensure that the call into plugin code succeeded and the plugin got its configuration.
    ##
    ## Uses the fact that the code of the example plugin manipulates the environment passed
    ## into it as a communications channel.
    expect(cpi.config.instance_variable_get("@config")["example_plugin_has_vm_pre_called"]).to(eq(true))
    expect(cpi.config.instance_variable_get("@config")["configured_plugin_options"]).to(eq(configured_plugin_options))
  end
end