module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_uri, :developer_login, :tracking)

    # Return config object
    #
    # @return [Config]
    #
    # @api private
    #
    def self.load(environment)
      Loader.call(environment)
    end

    alias_method :developer_login?, :developer_login
    alias_method :tracking?, :tracking

    class Loader
      include Concord.new(:environment)

      # Return response
      #
      # @return [Config]
      #
      # @api private
      #
      def self.call(environment)
        new(environment).response
      end

      # Return transformed config object
      #
      # @return [Config]
      #
      # @api private
      #
      def response
        Transformer.call(parsed_content)
      end

    private

      # Return file path
      #
      # @return [Pathname]
      #
      # @api private
      #
      def filepath
        Schnitzelpress.config_path.join("#{environment}.yml")
      end

      # Return file content
      #
      # @return [String]
      #
      # @api private
      #
      def file_content
        File.new(filepath).read
      end

      # Parse file content with ERB und YAML and return hash
      #
      # @return [Hash]
      #
      # @api private
      #
      def parsed_content
        parsed_erb_content = ERB.new(file_content).result

        YAML.load(parsed_erb_content)
      end

      class Transformer
        include Concord.new(:hash)
        include Morpher::NodeHelpers

        # Return response
        #
        # @return [Config]
        #
        # @api private
        #
        def self.call(hash)
          new(hash).response
        end

        # Return transformed config object
        #
        # @return [Config]
        #
        # @api private
        #
        def response
          evaluator.call(hash)
        end

      private

        # Return evaluator
        #
        # @return [Morpher::Evaluator]
        #
        # @api private
        #
        def evaluator
          Morpher.compile(node_tree)
        end

        # Return boolean AST node
        #
        # @param [Symbol] name
        #
        # @return [Parser::AST::Node]
        #
        # @api private
        #
        def boolean_node(name)
          s(:key_symbolize, name,
            s(:or,
              s(:primitive, TrueClass),
              s(:primitive, FalseClass)
            )
          )
        end

        # Return string AST node
        #
        # @param [Symbol] name
        #
        # @return [Parser::AST::Node]
        #
        # @api private
        #
        def string_node(name)
          s(:key_symbolize, name,
            s(:guard, s(:primitive, String))
          )
        end


        # Return AST node tree
        #
        # @return [Parser::AST::Node]
        #
        # @api private
        #
        def node_tree
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
