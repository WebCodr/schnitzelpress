module Schnitzelpress
  # Presenter base class
  class Presenter
    include AbstractType, Adamantium::Flat, Concord.new(:response)

    def self.call(response)
      new(response.output)
    end

    abstract_method :serializable_hash

    def json
      MultiJson.dump(serializable_hash)
    end
    memoize :json

    # Return page title
    #
    # @return [String]
    #
    # @api private
    #
    def page_title
      Model::Config.instance.blog_title
    end

    # Define delegator on output
    #
    # @param [Symbol] name
    #
    # @api private
    #
    def self.define_delegator(name)
      define_method(name) do
        response.output.public_send(name)
      end
    end
    private_class_method :define_delegator
  end
end
