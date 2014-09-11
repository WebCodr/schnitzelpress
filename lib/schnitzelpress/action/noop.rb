module Schnitzelpress
  class Action
    # Noop class
    # does virtually nothing
    class Noop < self

      private

      def call
        success(input)
      end
    end
  end
end
