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

  # Set MongoDB URI connection string and initialize Mongoid
  #
  # @param [String] uri
  #
  # @return [String]
  #
  # @api private
  #
  def self.mongo_uri=(uri)
    init_mongoid(uri)
    @mongo_uri ||= uri
  end

  # Test if mongo_uri is set
  #
  # @return [Boolean]
  #
  # @api private
  #
  def self.mongo_uri?
    defined(@mongo_uri)
  end

  # Return mongo_uri
  #
  # @return [String]
  #
  # @api private
  #
  def self.mongo_uri
    raise 'Please set a MongoDB URI!' unless mongo_uri?

   @mongo_uri
  end

private

  # Initialize Mongoid
  #
  # @param [String] uri
  #
  # @api private
  #
  def self.init_mongoid(uri)
    Mongoid::Config.from_hash('uri' => uri)
    Schnitzelpress::Post.create_indexes
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
