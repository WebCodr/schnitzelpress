require 'sinatra'
require 'substation'
require 'adamantium'
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
require 'multi_json'
require 'encrypted_cookie'
require 'securerandom'
require 'logger'
require 'morpher'
require 'slugify'

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
  def self.config_path
    @config_path ||= root.join('config')
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
    @env ||= Environment.new(ENV)
  end

  # Return assets
  #
  # @return [Schnitzelpress::Assets]
  #
  # @api private
  #
  def self.assets
    @assets ||= Assets.new
  end

  # Return config
  #
  # @return [Schnitzelpress::Config]
  #
  # @api private
  #
  def self.config
    @config ||= Schnitzelpress::Config.load(env.state)
  end
end

require 'schnitzelpress/environment'
require 'schnitzelpress/config'
require 'schnitzelpress/database'
require 'schnitzelpress/model/config'
require 'schnitzelpress/model/post'
require 'schnitzelpress/dto/home'
require 'schnitzelpress/dto/page'
require 'schnitzelpress/action'
require 'schnitzelpress/action/noop'
require 'schnitzelpress/action/home'
require 'schnitzelpress/action/show_post'
require 'schnitzelpress/error'
require 'schnitzelpress/presenter'
require 'schnitzelpress/presenter/home'
require 'schnitzelpress/presenter/post'
require 'schnitzelpress/view/context'
require 'schnitzelpress/view'
require 'schnitzelpress/input'
require 'schnitzelpress/handler'
require 'schnitzelpress/handler/authenticator'
require 'schnitzelpress/handler/deserializer'
require 'schnitzelpress/facade/foundation'
require 'schnitzelpress/facade'
require 'schnitzelpress/assets'
require 'schnitzelpress/fixture/font_awesome_char_map'
require 'schnitzelpress/app'

Schnitzelpress::Database.setup(Schnitzelpress.config.postgres_url)
