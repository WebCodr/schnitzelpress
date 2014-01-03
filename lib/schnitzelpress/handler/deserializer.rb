module Schnitzelpress
  class Handler
    # Collection of deserializers
    class Deserializer < self

      class HttpQueryString < self

        def call
          params = Rack::Utils.parse_nested_query(input.query_string)

          success(params)
        end

      end

      class JSON < self

        def call
          unless input.content_type <=> 'application/json'
            return error(:content_type)
          end

          success(MultiJson.load(input.body))
        end

      end

    end
  end
end