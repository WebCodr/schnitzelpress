# encoding: UTF-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'bundler'
require 'schnitzelpress'
Bundler.require

$stdout.sync = true
ENV['MONGOLAB_URI'] = 'mongodb://localhost:27017/_schreihals_test'
ENV['SCHNITZELPRESS_OWNER'] = 'madcat.me@gmail.com'

set :environment, :test
run Schnitzelpress.omnomnom!