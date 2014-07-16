SPEC_DIR = File.dirname(__FILE__)
lib_path = File.expand_path("#{SPEC_DIR}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'rspec/its'
require 'schnitzelpress'
require 'awesome_print'
require 'rack/test'
require 'rspec-html-matchers'
require 'database_cleaner'
require 'ffaker'
require 'timecop'
require 'factory_helper'
Timecop.freeze

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:data_mapper].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:data_mapper].start
    Schnitzelpress::Model::Config.forget_instance
  end

  config.after(:each) do
    DatabaseCleaner[:data_mapper].clean
  end
end
