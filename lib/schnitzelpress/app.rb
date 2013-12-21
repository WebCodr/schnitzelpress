module Schnitzelpress
  class App < Sinatra::Base
    STATIC_PATHS = ["/favicon.ico", "/img", "/js"]

    set :views, ['./views/', File.expand_path('../../views/', __FILE__)]
    set :public_folder, File.expand_path('../../public/', __FILE__)

    use Rack::Session::Cookie
    set :session_secret, Random.rand.to_s

    helpers Sinatra::ContentFor
    helpers Schnitzelpress::Helpers

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

    def fresh_when(options)
      last_modified options[:last_modified]
      etag options[:etag]
    end

    not_found do
      haml :"404"
    end
  end
end
