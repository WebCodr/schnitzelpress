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

    get '/home' do
      action(:home)
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

    def action(name, input = params)
      response = Facade.dispatcher.call(name, input)
      output = response.output

      unless response.success?
        case output
        when Substation::Chain::FailureData
          puts "Catched exception: #{output.exception}: #{output.exception.backtrace.join("\n")}"
          raise output.exception
        else
          puts "Chain #{name.inspect} halted with output: #{output.inspect}"
          status(400)

          if output.respond_to?(:print_debug)
            output.print_debug
          end
        end
      end

      output = output.output if output.respond_to?(:output)
      output
    end

  end
end
