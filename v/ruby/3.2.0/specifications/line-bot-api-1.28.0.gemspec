# -*- encoding: utf-8 -*-
# stub: line-bot-api 1.28.0 ruby lib

Gem::Specification.new do |s|
  s.name = "line-bot-api".freeze
  s.version = "1.28.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["LINE Corporation".freeze]
  s.date = "2023-03-14"
  s.description = "Line::Bot::API - SDK of the LINE Messaging API for Ruby".freeze
  s.email = ["kimoto@linecorp.com".freeze, "todaka.yusuke@linecorp.com".freeze, "masaki_kurosawa@linecorp.com".freeze]
  s.homepage = "https://github.com/line/line-bot-sdk-ruby".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "SDK of the LINE Messaging API".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<addressable>.freeze, ["~> 2.3"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 3.8"])
end
