$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler/setup'
require 'schnitzelpress'

run Schnitzelpress::App