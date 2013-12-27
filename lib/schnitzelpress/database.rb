module Schnitzelpress
  class Database

    # Sets up database connect, finalizes the models and starts migration
    #
    # @api private
    #
    def self.setup(environment)
      uri = config.fetch(environment)[:uri]
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
      @config ||= YAML.load_file(Schnitzelpress.root.join('config').join('database.yml'))
    end

  end
end