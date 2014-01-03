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

    end
  end
end