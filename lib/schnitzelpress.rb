require 'schnitzelpress/version'

require 'sinatra'
require 'haml'
require 'compass'
require 'schnitzelstyle'
require 'rack/contrib'
require 'rack/cache'
require 'mongoid'
require 'chronic'
require 'slodown_py'
require 'assets'
require 'omniauth'
require 'omniauth-browserid'
require 'sinatra/content_for'

Mongoid.logger.level = 3

module Schnitzelpress
  mattr_reader :mongo_uri

  def self.root
    @root ||= Pathname.new(__FILE__).parent.parent.freeze
  end

  def self.mongo_uri=(uri)
    Mongoid::Config.from_hash("uri" => uri)
    Schnitzelpress::Post.create_indexes
    @@mongo_uri = uri
  end

  def self.init!
    # Mongoid.load!("./config/mongo.yml")
    if mongo_uri = ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO_URL']
      self.mongo_uri = mongo_uri
    else
      raise "Please set MONGO_URL, MONGOHQ_URL or MONGOLAB_URI to your MongoDB connection string."
    end
    Schnitzelpress::Post.create_indexes
  end

  def self.omnomnom!
    init!
    App.with_local_files
  end
end

require 'schnitzelpress/cache_control'
require 'schnitzelpress/env'
require 'schnitzelpress/static'
require 'schnitzelpress/helpers'
require 'schnitzelpress/config'
require 'schnitzelpress/post'
require 'schnitzelpress/actions/blog'
require 'schnitzelpress/actions/auth'
require 'schnitzelpress/actions/admin'
require 'schnitzelpress/assets'
require 'schnitzelpress/app'
