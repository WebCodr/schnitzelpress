module Schnitzelpress
  # DataMapper setup
  class Database

    # Set up database connect, finalizes the models and starts migration
    #
    # @api private
    #
    def self.setup(postgres_url)
      DataMapper::Logger.new($stdout, :fatal)
      DataMapper.setup(:default, postgres_url)
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

  end
end
