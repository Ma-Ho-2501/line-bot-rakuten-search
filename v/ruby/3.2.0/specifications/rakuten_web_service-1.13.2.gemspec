# -*- encoding: utf-8 -*-
# stub: rakuten_web_service 1.13.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rakuten_web_service".freeze
  s.version = "1.13.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tatsuya Sato".freeze]
  s.date = "2023-03-25"
  s.description = "Ruby Client for Rakuten Web Service".freeze
  s.email = ["tatsuya.b.sato@mail.rakuten.com".freeze]
  s.homepage = "http://webservice.rakuten.co.jp/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Ruby Client for Rakuten Web Service".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<json>.freeze, ["~> 2.3"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<debug>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rexml>.freeze, ["~> 3.2"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9"])
  s.add_development_dependency(%q<tapp>.freeze, ["~> 1.5.1"])
  s.add_development_dependency(%q<terminal-table>.freeze, ["~> 1.8.0"])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 3.9"])
end
