module Schnitzelpress
  class Presenter
    # Home presenter
    class Home < self
      # Return post presenters
      #
      # @return [Enumberable<Presenter::Post>]
      #
      # @api private
      #
      def posts
        content.map do |post|
          Presenter::Post.wrap(post)
        end
      end

      # Test if button for previous page has to be displayed
      #
      # @return [Boolean]
      #
      # @api private
      #
      def previous_posts_button?
        current_page < total_pages
      end

      # Return number of page page
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def next_page
        current_page + 1
      end

      # Return page title
      #
      # @return [String]
      #
      # @api private
      #
      def page_title
        "Home | #{super}"
      end

    private

      # Return DTO from response
      #
      # @return [DTO::Page]
      #
      # @api private
      #
      def dto
        response.output
      end

      # Return post models
      #
      # @return [Enumerable<Model::Post>]
      #
      # @api private
      #
      def content
        dto.content
      end

      # Return pagination
      #
      # @return [DTO::Pagination]
      #
      # @api private
      #
      def pagination
        dto.pagination
      end

      # Return number of current page
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def current_page
        pagination.current_page
      end

      # Return number of total pages
      #
      # @return [Fixnum]
      #
      # @api private
      #
      def total_pages
        (pagination.total_elements / pagination.elements_per_page).ceil
      end
    end
  end
end
