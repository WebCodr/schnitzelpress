module Schnitzelpress
  # Environment class
  class Environment

    include Concord.new(:env_vars)
    include Adamantium::Flat

    # Return environment state
    #
    # @return [Symbol]
    #
    # @api private
    #
    def state
      case environment
      when 'test', 'development', 'production', 'circleci', 'travisci'
        environment.to_sym
      else
        fail 'Could not determine current environment!'
      end
    end
    memoize :state

  private

    # Return value of SCHNITZEL_ENV environmental variable
    #
    # @return [String]
    #
    # @api private
    #
    def environment
      env_vars['SCHNITZEL_ENV'] || 'development'
    end
    memoize :environment

  end
end
