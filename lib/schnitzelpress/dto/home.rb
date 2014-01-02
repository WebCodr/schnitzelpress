module Schnitzelpress
  class DTO
    class Home < self
      include Anima.new(:posts, :page)
    end
  end
end
