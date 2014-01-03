module Schnitzelpress
  class Action
    class Home < self

      private

      def call
        posts = Model::Post.latest.limit(10).skip(skipped)

        page = DTO::Page.new(
          current: current_page,
          max: max_pages
        )

        dto = DTO::Home.new(
          posts: posts,
          page: page
        )

        success(dto)
      end

      def skipped
        current_page * 10
      end

      def current_page
        params.fetch('page', 0).to_i
      end

      def max_pages
        (Model::Post.posts.count / 10).ceil
      end

    end
  end
end
