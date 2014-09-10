module Schnitzelpress
  module Actions
    # Route definitions for Auth
    module Auth

      extend ActiveSupport::Concern

      included do
        use OmniAuth::Builder do
          provider :browser_id
          if Schnitzelpress.config.developer_login?
            provider :developer , fields: [:email], uid_field: :email
          end
        end

        post '/auth/:provider/callback' do
          auth = request.env['omniauth.auth']
          session[:auth] = { provider: auth['provider'], uid: auth['uid'] }

          if admin_logged_in?
            response.set_cookie('show_admin', value: true, path: '/')
            redirect '/admin/'
          else
            redirect '/'
          end
        end

        get '/login' do
          slim :login
        end

        get '/logout' do
          session[:auth] = nil
          response.delete_cookie('show_admin')

          redirect '/login'
        end

      end
    end
  end
end
