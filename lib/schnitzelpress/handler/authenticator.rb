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

    end
  end
end