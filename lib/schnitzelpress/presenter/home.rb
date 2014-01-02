module Schnitzelpress
  class Presenter
    # Home presenter
    class Home < self

      def posts
        dto.posts.map do |post|
          Presenter::Post.new(post)
        end
      end

      def previous_posts_button?
        current_page < dto.page.max
      end

      def current_page
        dto.page.current
      end

      def next_page
        current_page + 1
      end

      def page_title
        "Home | #{super}"
      end

      def dto
        response.output
      end

    end
  end
end