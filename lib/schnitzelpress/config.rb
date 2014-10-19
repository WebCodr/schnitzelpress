module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_uri, :developer_login, :tracking)

    def self.load(environment)
      Loader.call(environment)
    end

    alias_method :developer_login?, :developer_login
    alias_method :tracking?, :tracking

    class Loader
      include Concord.new(:environment)

      def self.call(environment)
        new(environment).call
      end

      def call
        Transformer.call(parsed_content)
      end

    private

      def filepath
        Schnitzelpress.config_path.join("#{environment}.yml")
      end

      def file_content
        File.new(filepath).read
      end

      def parsed_content
        parsed_erb_content = ERB.new(file_content).result

        YAML.load(parsed_erb_content)
      end

      class Transformer
        include Concord.new(:hash)
        include Morpher::NodeHelpers

        def self.call(hash)
          new(hash).call
        end

        def call
          evaluator.call(hash)
        end

      private

        def evaluator
          Morpher.compile(nodes)
        end

        def boolean_node(name)
          s(:key_symbolize, name,
            s(:or,
              s(:primitive, TrueClass),
              s(:primitive, FalseClass)
            )
          )
        end

        def string_node(name)
          s(:key_symbolize, name,
            s(:guard, s(:primitive, String))
          )
        end

        def nodes
          s(:block,
            s(:guard, s(:primitive, Hash)),
            s(:hash_transform,
              string_node(:postgres_uri),
              boolean_node(:developer_login),
              boolean_node(:tracking)
            ),
            s(:load_attribute_hash, s(:param, Config))
          )
        end
      end # Transformer
    end # Loader
  end # Config
end # Schnitzelpress
