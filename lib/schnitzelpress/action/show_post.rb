module Schnitzelpress
  class Action
    # Post action
    class ShowPost < self

      private

      def call
        post = Model::Post.for_day(*day).all(slug: slug).first

        if post
          success(post)
        else
          error(:post_not_found)
        end

      end

      def day
        [fetch_integer('year'), fetch_integer('month'), fetch_integer('day')]
      end

      def fetch_integer(name)
        input.fetch(name, 0).to_i
      end

      def slug
        input.fetch('slug', '')
      end
    end
  end
end
