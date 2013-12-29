module Schnitzelpress
  class Environment
    include Concord.new(:environment)

    # Return current environment
    #
    # @return [Symbol]
    #
    # @api private
    #
    def current
      return :test if test?
      return :development if development?
      return :production if production?

      raise 'Could not determine current environment!'
    end

  private

    # Test for testing environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def test?
      environment['RACK_ENV'] == 'test'
    end

    # Test for development environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def development?
      environment['RACK_ENV'] == 'development'
    end

    # Test for production environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def production?
      environment['RACK_ENV'] == 'production'
    end

  end
end