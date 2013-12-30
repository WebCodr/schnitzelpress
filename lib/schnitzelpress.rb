require 'sinatra'
require 'active_support'
require "active_support/inflector"
require "active_support/time_with_zone"
require 'yaml'
require 'erb'
require 'slim'
require 'compass'
require 'schnitzelstyle'
require 'data_mapper'
require 'chronic'
require 'slodown_py'
require 'assets'
require 'omniauth'
require 'omniauth-browserid'
require 'sinatra/content_for'

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
  def self.env
    @env ||= Schnitzelpress::Environment.new(ENV)
  end

  # Return assets
  #
  # @return [Schnitzelpress::Assets]
  #
  # @api private
  #
  def self.assets
    @assets ||= Schnitzelpress::Assets.new
  end

end

require 'schnitzelpress/environment'
require 'schnitzelpress/database'
require 'schnitzelpress/helpers'
require 'schnitzelpress/model/config'
require 'schnitzelpress/model/post'
require 'schnitzelpress/actions/blog'
require 'schnitzelpress/actions/auth'
require 'schnitzelpress/actions/admin'
require 'schnitzelpress/assets'
require 'schnitzelpress/app'

Schnitzelpress::Database.setup(Schnitzelpress.env.state)