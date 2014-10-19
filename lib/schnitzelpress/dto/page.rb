module Schnitzelpress
  class DTO
    class Page < self
      include Anima.new(
        :content,
        :pagination
      )
    end
  end
end
