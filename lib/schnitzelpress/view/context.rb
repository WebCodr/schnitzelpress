module Schnitzelpress
  class View
    # Template rendering context
    class Context
      include Anima.new(:presenter)

      # Render a partial template
      #
      # @param [String] template
      #   the logical template name
      #
      # @return [String]
      #
      # @api private
      #
      def partial(template, locals = {})
        Tilt.new(partials.join("#{template}.slim")).render(self, locals)
      end

      # Return HTML for icon
      #
      # @param [String] name
      #
      # @return [String]
      #
      # @api private
      #
      def icon(name)
        map = Fixture::FontAwesomeCharMap.all
        char = map.fetch(name, 'f06a')

        "<span class=\"font-awesome\">&#x#{char};</span>"
      end

      # Return Disqus ID
      #
      # @return [String]
      #
      # @api private
      #
      def disqus_id
        Model::Config.instance.disqus_id
      end

      # Return title
      #
      # @return [String]
      #
      # @api private
      #
      def page_title
        if presenter.respond_to?(:page_title)
          presenter.page_title
        else
          Model::Config.instance.blog_title
        end
      end

    private

      # Return partials path
      #
      # @return [Pathname]
      #
      # @api private
      #
      def partials
        Schnitzelpress.templates.join('partials')
      end
    end
  end
end
