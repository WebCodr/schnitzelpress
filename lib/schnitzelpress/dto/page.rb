module Schnitzelpress
  class DTO
    class Page < self
      include Anima.new(:current, :max)
    end
  end
end