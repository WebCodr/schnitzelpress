SPEC_DIR = File.dirname(__FILE__)
lib_path = File.expand_path("#{SPEC_DIR}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'schnitzelpress'
require 'awesome_print'
require 'rack/test'
require 'rspec-html-matchers'
require 'database_cleaner'
require 'ffaker'
require 'factory_girl'
require File.expand_path("../factories.rb", __FILE__)
require 'timecop'
Timecop.freeze

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
    Schnitzelpress::Config.forget_instance
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
end
