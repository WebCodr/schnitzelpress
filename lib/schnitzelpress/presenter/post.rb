module Schnitzelpress
  class Presenter
    class Post < self

      def title
        post.title
      end

      def content
        post.to_html
      end

      def url
        post.to_url
      end

      def formatted_date
        post.published_at.to_date.strftime('%-d.%-m.%Y')
      end

    private

      def post
        response
      end

    end
  end
end
