# coding: utf-8
Gem::Specification.new do |s|
  s.name        = 'bosh_vsphere_cpi'
  s.version     = '2.2.0'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'BOSH VSphere CPI'
  s.description = "BOSH VSphere CPI"
  s.author      = 'VMware'
  s.homepage    = 'https://github.com/cloudfoundry/bosh'
  s.license     = 'Apache 2.0'
  s.email       = 'support@cloudfoundry.com'
  s.required_ruby_version = Gem::Requirement.new('>= 1.9.3')

  s.files        = Dir['lib/**/*'].select { |f| File.file? f } 
  s.require_path = 'lib'
  s.bindir       = 'bin'

  s.executables = %w(vsphere_cpi vsphere_cpi_console)

  s.add_dependency 'bosh_common'
  s.add_dependency 'bosh_cpi'
  s.add_dependency 'membrane',    '~>1.1.0'
  s.add_dependency 'builder',     '~>3.1.4'
  s.add_dependency 'nokogiri',    '~>1.6.6'
  s.add_dependency 'httpclient',  '=2.4.0'
  s.add_dependency 'mono_logger', '~>1.1.0'
end
