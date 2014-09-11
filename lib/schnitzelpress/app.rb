module Schnitzelpress
  # App class
  class App < Sinatra::Base

    set :views, Schnitzelpress.root.join('views')

    use Rack::Session::EncryptedCookie, key: 's', secret: ENV['SESSION_SECRET'] || SecureRandom.hex(32)

    helpers Sinatra::ContentFor
    helpers Helpers

    def initialize(app = nil)
      super(app)

      asset_routes
      blog_routes
      auth_routes
      login_routes
      admin_routes
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

        if Schnitzelpress.config.developer_login?
          provider :developer , fields: [:email], uid_field: :email
        end
      end
    end

    def auth_routes
      developer_auth

      self.class.post '/auth/:provider/callback' do
        auth = request.env['omniauth.auth']
        session[:uid] = auth['uid']

        redirect '/admin'
      end
    end

    def login_routes
      self.class.get '/login' do
        action(:login_form)
      end

      self.class.get '/logout' do
        session[:auth] = nil
        response.delete_cookie('show_admin')

        redirect '/login'
      end
    end

    def admin_routes
      self.class.get '/admin' do
        action(:admin_home)
      end

      self.class.get '/admin/config' do
        action(:admin_config)
      end

      self.class.post '/admin/config' do
        action(:admin_save_config)
      end

      post_routes
    end

    def post_routes
      self.class.get '/admin/post' do
        action(:admin_new_post)
      end

      self.class.post '/admin/post' do
        action(:admin_save_post)
      end

      self.class.put '/admin/post/:id' do
        action(:admin_save_post)
      end

      self.class.put '/admin/post/:id' do
        action(:admin_delete_post)
      end
    end

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

    def action(name)
      input = Input.new(
        http_request: request,
        params: params,
        state: nil
      )

      response = Facade::ENV.dispatcher.call(name, input)
      output = response.output
      handle_error(output, name) unless response.success?

      output.respond_to?(:output) ? output.output : output
    end

    def handle_error(output, name)
      case output
      when Substation::Response::Exception::Output
        exception = output.exception
        backtrace = exception.backtrace.join("\n")
        puts "Caught exception: #{exception}: #{backtrace}"

        fail output.exception
      else
        puts "Chain #{name.inspect} halted with output: #{output.response.output.inspect}"
        status(400)

        output.print_debug if output.respond_to?(:print_debug)
      end
    end

  end
end
