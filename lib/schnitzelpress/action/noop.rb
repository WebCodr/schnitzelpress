module Schnitzelpress
  class Action
    class Noop < self

      private

      def call
        success(input)
      end

    end
  end
end