module Schnitzelpress
  class Presenter
    # Home presenter
    class Home < self

      def posts
        response.output
      end

      def page_title
        "Home | #{super}"
      end

    end
  end
end