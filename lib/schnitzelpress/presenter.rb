module Schnitzelpress
  # Presenter base class
  class Presenter
    include AbstractType, Adamantium::Flat, Concord.new(:response)

    def self.call(response)
      new(response)
    end

    abstract_method :serializable_hash

    def json
      MultiJson.dump(serializable_hash)
    end
    memoize :json

    private

    def data
      response.output
    end

  end
end
