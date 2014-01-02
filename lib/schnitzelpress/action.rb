module Schnitzelpress
  # Base class for Actions
  class Action

    include AbstractType, Adamantium::Flat, Concord.new(:request)

    def self.call(request)
      new(request).response
    end

    def response
      call
    end
    memoize :response

    private

    def success(object)
      request.success(object)
    end

    def error(object)
      request.error(object)
    end

    def input
      request.input
    end

    def session
      input.session
    end

    def environment
      request.env
    end

    def dto
      input.state
    end

    abstract_method :call

  end
end
