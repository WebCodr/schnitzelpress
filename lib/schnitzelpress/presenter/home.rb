module Schnitzelpress
  class Presenter
    # Home presenter
    class Home < self

      def posts
        response.output.map do |post|
          Presenter::Post.new(post)
        end
      end

      def page_title
        "Home | #{super}"
      end

    end
  end
end