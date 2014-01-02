module Schnitzelpress
  class Presenter
    class Post < self

      define_delegator(:title)
      define_delegator(:comments?)
      define_delegator(:identifier)

      def content
        post.to_html
      end

      def url
        post.to_url
      end

      def formatted_date
        post.published_at.to_date.strftime('%-d.%-m.%Y')
      end

      def page_title
        "#{title} | #{super}"
      end

    private

      def post
        response.output
      end

    end
  end
end
