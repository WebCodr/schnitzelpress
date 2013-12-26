require 'sinatra'
require 'haml'
require 'compass'
require 'schnitzelstyle'
require 'mongoid'
require 'chronic'
require 'slodown_py'
require 'assets'
require 'omniauth'
require 'omniauth-browserid'
require 'sinatra/content_for'

Mongoid.logger.level = 3

module Schnitzelpress

  # Return root
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.root
    @root ||= Pathname.new(__FILE__).parent.parent.freeze
  end

  # Return path to Mongoid config file
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.mongoid_config
    @mongoid_config ||= self.root.join('config').join('mongoid.yml')
  end

end

require 'schnitzelpress/cache_control'
require 'schnitzelpress/env'
require 'schnitzelpress/helpers'
require 'schnitzelpress/config'
require 'schnitzelpress/post'
require 'schnitzelpress/actions/blog'
require 'schnitzelpress/actions/auth'
require 'schnitzelpress/actions/admin'
require 'schnitzelpress/assets'
require 'schnitzelpress/app'
