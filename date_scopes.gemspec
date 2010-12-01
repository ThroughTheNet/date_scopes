# -*- encoding: utf-8 -*-
require File.expand_path("../lib/date_scopes/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "date_scopes"
  s.version     = DateScopes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/date_scope"
  s.summary     = "TODO: Write a gem summary"
  s.description = "TODO: Write a gem description"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "activerecord", "~> 3"
  
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency 'timecop', '>= 0'
  s.add_development_dependency 'sqlite3-ruby', '>= 0'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
