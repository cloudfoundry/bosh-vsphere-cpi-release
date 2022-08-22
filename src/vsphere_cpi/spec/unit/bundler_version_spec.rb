require 'spec_helper'

describe "Bundler Version" do
  it "must match the bundler version that is in the ruby version vendored into release" do
    #why? you ask? If these do not match, then airgapped deployments will fail because they will attempt to install
    # the Gemfile.lock bundler version which will not work well on an environment with no internet.
    gemfile_path = File.join(File.dirname(__FILE__), '..', '..', 'Gemfile.lock')
    expect(File.read(gemfile_path).split("BUNDLED WITH").last.strip).to eq("2.3.11")
  end
end
