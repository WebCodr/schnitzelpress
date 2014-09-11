module Schnitzelpress
  # Facade module
  module Facade
    # Input module
    module Input
      class Authenticated
        include Anima.new(:uid, :state), Anima::Update
      end
    end

    # Authenticator module
    module Authenticator
      decomposer = lambda do |request|
        request
      end

      composer = lambda do |request, output|
        Input::Authenticated.new(
          uid: output,
          state: nil
        )
      end

      EXECUTOR = Substation::Processor::Executor.new(decomposer, composer)
    end

    # Serializer module
    module Serializer
      decomposer = lambda do |request|
        request
      end

      composer = lambda do |request, output|
        output
      end

      EXECUTOR = Substation::Processor::Executor.new(decomposer, composer)
    end

    # Deserializer module
    module Deserializer
      decomposer = lambda do |request|
        request
      end

      composer = lambda do |request, output|
        output.data
      end

      EXECUTOR = Substation::Processor::Executor.new(decomposer, composer)
    end
  end
end