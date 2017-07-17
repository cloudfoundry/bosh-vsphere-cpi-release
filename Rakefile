require 'rubygems'
require 'bundler/setup'
require 'rspec'

task :source do
  cd 'src/vsphere_cpi'
end

namespace :test do
  task :unit => :source do
    RSpec::Core::Runner.run ['spec/unit']
  end

  task :integration => :source do
    RSpec::Core::Runner.run ['spec/integration']
  end
end
