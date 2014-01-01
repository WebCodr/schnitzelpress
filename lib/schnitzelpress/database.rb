module Schnitzelpress
  class Database

    # Sets up database connect, finalizes the models and starts migration
    #
    # @api private
    #
    def self.setup(environment)
      uri = self.config.fetch(environment.to_s).fetch('uri')
      DataMapper::Logger.new($stdout, :fatal)
      DataMapper.setup(:default, uri)
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

  private

    # Retrieve and return database config
    #
    # @return [Hash]
    #
    # @api private
    #
    def self.config
      @config ||= YAML.load(ERB.new(File.new(config_file).read).result)
    end

    # Return path to database config file
    #
    # @return [Pathname]
    #
    # @api private
    #
    def self.config_file
      @config_file ||= Schnitzelpress.root.join('config').join('schnitzelpress.yml')
    end

  end
end