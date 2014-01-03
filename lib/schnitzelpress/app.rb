module Schnitzelpress
  # App class
  class App < Sinatra::Base

    set :views, Schnitzelpress.root.join('views')

    use Rack::Session::Cookie, secret: Random.rand.to_s

    helpers Sinatra::ContentFor
    helpers Helpers

    def initialize(app = nil)
      super(app)

      asset_routes
      blog_routes
      auth_routes
      login_routes
    end

    def asset_routes
      self.class.get '/assets/*' do
        rack = ::Request::Rack.new(request.env)
        Schnitzelpress.assets.assets_handler.call(rack).to_rack_response
      end
    end

    def blog_routes
      self.class.get '/' do
        action(:home)
      end

      self.class.get '/:year/:month/:day/:slug/?' do
        action(:view_post)
      end

      self.class.get '/blog.atom' do
        content_type 'application/atom+xml; charset=utf-8'
        @posts = Model::Post.latest.limit(10)

        slim :atom, format: :xhtml, layout: false
      end
    end

    def developer_auth
      self.class.use OmniAuth::Builder do
        provider :browser_id
        if Schnitzelpress.env.development?
          provider :developer , fields: [:email], uid_field: :email
        end
      end
    end

    def auth_routes
      developer_auth

      self.class.post '/auth/:provider/callback' do
        auth = request.env['omniauth.auth']
        session[:auth] = { provider: auth['provider'], uid: auth['uid'] }

        if admin_logged_in?
          response.set_cookie('show_admin', value: true, path: '/')
          redirect '/admin/'
        else
          redirect '/'
        end
      end
    end

    def login_routes
      self.class.get '/login' do
        slim :login
      end

      self.class.get '/logout' do
        session[:auth] = nil
        response.delete_cookie('show_admin')

        redirect '/login'
      end
    end

    include Actions::Admin

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

    def action(name, input = params)
      response = Facade.dispatcher.call(name, input)
      output = response.output
      handle_error(output) unless response.success?

      output.respond_to?(:output) ? output.output : output
    end

    def handle_error(output)
      case output
      when Substation::Chain::FailureData
        exception = output.exception
        backtrace = exception.backtrace.join("\n")
        puts "Caught exception: #{exception}: #{backtrace}"

        fail output.exception
      else
        puts "Chain #{name.inspect} halted with output: #{output.inspect}"
        status(400)

        output.print_debug if output.respond_to?(:print_debug)
      end
    end

  end
end
