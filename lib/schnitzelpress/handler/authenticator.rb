module Schnitzelpress
  class Handler
    # User authenticator
    class Authenticator < self

      def call
        if authenticated?
          success(uid)
        else
          error(:unauthenticated)
        end
      end

    private

      def uid
        session[:uid]
      end

      def uid?
        !!uid
      end

      def authenticated?
        uid? && (uid == ENV['SCHNITZELPRESS_OWNER'])
      end

    end
  end
end
