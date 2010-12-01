require 'rubygems'
require 'bundler'

ENV["RAILS_ENV"] ||= 'test'
Bundler.require(:default, :development)

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'spec/support/test.sqlite3'
)
