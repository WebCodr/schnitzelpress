$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler/setup'
require 'schnitzelpress'

Schnitzelpress.mongo_uri = ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO_URL']

run Schnitzelpress::App