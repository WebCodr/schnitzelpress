module Schnitzelpress
  class Action
    class Home < self
      # Return response
      #
      # @return [Substation::Response]
      #
      # @api private
      #
      def call
        posts = Model::Post.latest.limit(posts_per_page).skip(skipped_posts)

        dto = DTO::Page.new(
          :content    => posts,
          :pagination => pagination
        )

        success(dto)
      end

    private

      # Return pagination DTO
      #
      # @return [DTO::Pagination]
      #
      # @api private
      #
      def pagination
        DTO::Pagination.new(
          :current_page      => current_page,
          :elements_per_page => posts_per_page,
          :total_elements    => total_posts
        )
      end

      # Return numbers of posts per page
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def posts_per_page
        10
      end

      # Return number of posts to skip for current page
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def skipped_posts
        (current_page - 1) * posts_per_page
      end

      # Return number of current page
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def current_page
        params.fetch('page', 1).to_i
      end

      # Return number of total pages
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def total_posts
        Model::Post.posts.count
      end
    end # Home
  end # Action
end # Schnitzelpress
