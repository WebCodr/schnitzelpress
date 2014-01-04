$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['RACK_ENV'] = 'test'
ENV['SCHNITZELPRESS_OWNER'] = 'schnitzel@press.de'

require 'bundler/setup'
require 'schnitzelpress'
require 'awesome_print'
require 'database_cleaner'
require 'ffaker'
require 'timecop'
require 'factory_helper'
require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.app = Schnitzelpress::App
Capybara.javascript_driver = :poltergeist

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
