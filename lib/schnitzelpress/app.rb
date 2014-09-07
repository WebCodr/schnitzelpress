module Schnitzelpress
  # App class
  class App < Sinatra::Base

    set :views, Schnitzelpress.root.join('views')

    use Rack::Session::EncryptedCookie, key: 's', secret: ENV['SESSION_SECRET'] || Random.new.bytes(32)

    helpers Sinatra::ContentFor
    helpers Schnitzelpress::Helpers

    get '/assets/*' do
      rack = ::Request::Rack.new(request.env)
      Schnitzelpress.assets.assets_handler.call(rack).to_rack_response
    end

    include Schnitzelpress::Actions::Auth
    include Schnitzelpress::Actions::Admin
    include Schnitzelpress::Actions::Blog

    before do
      # Reload configuration before every request. I know this isn't ideal,
      # but right now it's the easiest way to get the configuration in synch
      # across multiple instances of the app.
      #
      Model::Config.instance.reload
    end

    not_found do
      slim :"404"
    end

  end
end
