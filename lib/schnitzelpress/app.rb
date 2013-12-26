module Schnitzelpress
  class App < Sinatra::Base
    set :views, Schnitzelpress.root.join('views')

    use Rack::Session::Cookie, :secret => Random.rand.to_s

    helpers Sinatra::ContentFor
    helpers Schnitzelpress::Helpers

    Mongoid.load!(Schnitzelpress.mongoid_config, ENV['RACK_ENV'])

    get '/assets/*' do
      ASSETS_HANDLER.call(::Request::Rack.new(request.env)).to_rack_response
    end

    include Schnitzelpress::Actions::Auth
    include Schnitzelpress::Actions::Admin
    include Schnitzelpress::Actions::Blog

    before do
      # Reload configuration before every request. I know this isn't ideal,
      # but right now it's the easiest way to get the configuration in synch
      # across multiple instances of the app.
      #
      Config.instance.reload
    end

    not_found do
      slim :"404"
    end
  end
end
