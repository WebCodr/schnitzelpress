module Schnitzelpress
  module Handler
    # User authenticator
    class Authenticator
      include Adamantium::Flat, Concord.new(:request)

      def self.call(request)
        new(request).response
      end

      def response
        call
      end
      memoize :response

      def call
        if authenticated?
          success(uid)
        else
          error(:unauthenticated)
        end
      end

    private

      def auth?
        !!auth
      end

      def auth
        session[:auth]
      end

      def authenticated?
        auth? && (uid == ENV['SCHNITZELPRESS_OWNER'])
      end

      def uid
        auth[:uid]
      end

      def input
        request.input
      end

      def session
        input.session
      end

      def success(output)
        Result::Success.new(output)
      end

      def error(output)
        Result::Failure.new(output)
      end

      class Result
        include Concord::Public.new(:output)

        alias_method :data, :output

        def success?
          self.class::STATE
        end

        class Success < self
          STATE = true
        end

        class Failure < self
          STATE = false
        end
      end
    end
  end
end