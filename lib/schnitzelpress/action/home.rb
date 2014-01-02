module Schnitzelpress
  class Action
    class Home < self

      private

      def call
        posts = Model::Post.latest.limit(10).skip(skipped)

        success(posts)
      end

      def skipped
        input.fetch('page', 0).to_i * 10
      end

    end
  end
end