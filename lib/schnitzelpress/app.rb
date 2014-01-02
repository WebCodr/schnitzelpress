module Schnitzelpress
  # App class
  class App < Sinatra::Base

    set :views, Schnitzelpress.root.join('views')

    use Rack::Session::Cookie, secret: Random.rand.to_s

    helpers Sinatra::ContentFor
    helpers Schnitzelpress::Helpers

    get '/assets/*' do
      rack = ::Request::Rack.new(request.env)
      Schnitzelpress.assets.assets_handler.call(rack).to_rack_response
    end

    get '/' do
      action(:home)
    end

    get '/:year/:month/:day/:slug/?' do
      action(:view_post)
    end

    get '/blog.atom' do
      content_type 'application/atom+xml; charset=utf-8'
      @posts = Schnitzelpress::Model::Post.latest.limit(10)

      slim :atom, format: :xhtml, layout: false
    end

    include Schnitzelpress::Actions::Auth
    include Schnitzelpress::Actions::Admin

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
