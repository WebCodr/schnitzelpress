# encoding: UTF-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler/setup'
require 'schnitzelpress'

# FIX ME ASAP: only for current debugging process
ENV['MONGOLAB_URI'] = 'mongodb://localhost:27017/_schreihals_test'
ENV['SCHNITZELPRESS_OWNER'] = 'madcat.me@gmail.com'

run Schnitzelpress.omnomnom!