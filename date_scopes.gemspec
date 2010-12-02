# -*- encoding: utf-8 -*-
require File.expand_path("../lib/date_scopes/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "date_scopes"
  s.version     = DateScopes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jonathan Davies', 'ThroughTheNet']
  s.email       = ['info@throughthenet.com']
  s.license     = "MIT"
  s.homepage    = "https://github.com/ThroughTheNet/date_scopes"
  s.summary     = "An ActiveRecord extension for automatic date-based scopes"
  s.description = "Adds a simple macro, has_date_scopes to ActiveRecord. When used it adds a number of convinience scopes to your models relating to a whether a particular date field on that model is in the past or future. It also has other handy features."
  s.has_rdoc    = "yard"

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
