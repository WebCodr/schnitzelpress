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
      return :circle if circle?
      return :travis if travis?
      return :drone  if drone?
      return :test   if test?
      return :development if development?
      return :production if production?

      raise 'Could not determine current environment!'
    end

  private

    # Test for CI environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def ci?
      !!environment['CI']
    end

    # Test for Circle CI environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def circle?
      ci? && !!environment['CIRCLECI']
    end

    # Test for Travis CI environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def travis?
      ci? && !!environment['TRAVIS']
    end

    # Test for Drone.io CI environment
    #
    # @return [Boolean]
    #
    # @api private
    #
    def drone?
      ci? && !!environment['DRONE']
    end

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