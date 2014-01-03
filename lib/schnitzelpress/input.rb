module Schnitzelpress

  class Input
    include Anima.new(:http_request, :params, :state), Anima::Update

    alias_method :data, :state
  end

end