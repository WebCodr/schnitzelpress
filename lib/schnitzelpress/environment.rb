module Schnitzelpress
  class Environment
    include Concord.new(:env_vars)

    # Return current environment
    #
    # @return [Symbol]
    #
    # @api private
    #
    def state
      case env_vars['RACK_ENV']
      when 'test', 'development', 'production'
        env_vars['RACK_ENV'].to_sym
      else
        raise 'Could not determine current environment!'
      end
    end

    # Test for testing environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def test?
      state == :test
    end

    # Test for development environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def development?
      state == :development
    end

    # Test for production environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def production?
      state == :production
    end

  end
end