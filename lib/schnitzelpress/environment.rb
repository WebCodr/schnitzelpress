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
      return :test if test?
      return :development if development?
      return :production if production?

      raise 'Could not determine current environment!'
    end

    # Test for testing environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def test?
      env_vars['RACK_ENV'] == 'test'
    end

    # Test for development environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def development?
      env_vars['RACK_ENV'] == 'development'
    end

    # Test for production environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def production?
      env_vars['RACK_ENV'] == 'production'
    end

  end
end