module Schnitzelpress
  # Error handlers
  class Error
    include Adamantium::Flat, Concord::Public.new(:response)
    extend Adamantium::Mutable

    InternalError = Class.new(self)
  end
end
