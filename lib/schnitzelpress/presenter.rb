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

  end
end
