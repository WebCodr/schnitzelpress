require 'sinatra'
require 'slim'
require 'compass'
require 'schnitzelstyle'
require 'mongoid'
require 'data_mapper'
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
    @mongoid_config ||= root.join('config').join('mongoid.yml')
  end

  # Return template path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def templates
    @template ||= root.join('templates')
  end

  # Return environment
  #
  # @return [Schnitzelpress::Environment]
  #
  # @api private
  #
  def environment
    @environment ||= Schnitzelpress::Environment.new(ENV)
  end

end

require 'schnitzelpress/cache_control'
require 'schnitzelpress/env'
require 'schnitzelpress/environment'
require 'schnitzelpress/helpers'
require 'schnitzelpress/config'
require 'schnitzelpress/post'
require 'schnitzelpress/actions/blog'
require 'schnitzelpress/actions/auth'
require 'schnitzelpress/actions/admin'
require 'schnitzelpress/assets'
require 'schnitzelpress/app'
