# -*- encoding: utf-8 -*-
# stub: bosh_cpi 2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "bosh_cpi".freeze
  s.version = "2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["VMware".freeze]
  s.date = "2018-04-10"
  s.description = "BOSH CPI".freeze
  s.email = "support@cloudfoundry.com".freeze
  s.files = ["lib/bosh/cpi.rb".freeze, "lib/bosh/cpi/cli.rb".freeze, "lib/bosh/cpi/compatibility_helpers.rb".freeze, "lib/bosh/cpi/compatibility_helpers/delete_vm.rb".freeze, "lib/bosh/cpi/logger.rb".freeze, "lib/bosh/cpi/redactor.rb".freeze, "lib/bosh/cpi/registry_client.rb".freeze, "lib/bosh/cpi/tasks.rb".freeze, "lib/bosh/cpi/tasks/spec.rake".freeze, "lib/cloud.rb".freeze, "lib/cloud/config.rb".freeze, "lib/cloud/errors.rb".freeze, "lib/cloud/version.rb".freeze]
  s.homepage = "https://github.com/cloudfoundry/bosh".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.13".freeze
  s.summary = "BOSH CPI".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<membrane>.freeze, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<httpclient>.freeze, ["~> 2.8.3"])
    else
      s.add_dependency(%q<membrane>.freeze, ["~> 1.1.0"])
      s.add_dependency(%q<httpclient>.freeze, ["~> 2.8.3"])
    end
  else
    s.add_dependency(%q<membrane>.freeze, ["~> 1.1.0"])
    s.add_dependency(%q<httpclient>.freeze, ["~> 2.8.3"])
  end
end
