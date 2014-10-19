module Schnitzelpress
  class DTO
    class Pagination < self
      include Anima.new(
        :current_page,
        :elements_per_page,
        :total_elements
      )
    end
  end
end
