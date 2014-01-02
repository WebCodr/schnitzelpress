require 'sinatra'
require 'substation'
require 'adamantium'
require 'active_support'
require 'active_support/inflector'
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

# FIXME: remove when ActiveRecord was removed
I18n.enforce_available_locales = false

# Schnitzelpress base
module Schnitzelpress

  # Return root path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.root
    @root ||= Pathname.new(__FILE__).parent.parent.freeze
  end

  # Return config path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.config
    @config ||= root.join('config')
  end

  # Return fixture path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.fixtures
    @fixtures ||= root.join('fixtures')
  end

  # Return template path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.templates
    @templates ||= root.join('templates')
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
require 'schnitzelpress/action'
require 'schnitzelpress/action/noop'
require 'schnitzelpress/action/home'
require 'schnitzelpress/actions/blog'
require 'schnitzelpress/actions/auth'
require 'schnitzelpress/actions/admin'
require 'schnitzelpress/error'
require 'schnitzelpress/presenter'
require 'schnitzelpress/presenter/home'
require 'schnitzelpress/view/context'
require 'schnitzelpress/view'
require 'schnitzelpress/facade'
require 'schnitzelpress/assets'
require 'schnitzelpress/fixture/font_awesome_char_map'
require 'schnitzelpress/app'

Schnitzelpress::Database.setup(Schnitzelpress.env.state)
