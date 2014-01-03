module Schnitzelpress
  # Views
  class View

    include Concord.new(:response)

    def self.call(response)
      new(response).call
    end

    def call
      layout.render(context, content: content)
    end

    def context
      Context.new(presenter: response.output)
    end

    def content
      template.render(context)
    end

    def template(name = self.class::TEMPLATE)
      Tilt.new(Schnitzelpress.templates.join(name.to_s).to_s)
    end

    def layout(name = self.class::LAYOUT)
      template(name)
    end

    class Template < self

      LAYOUT = 'layout.slim'.freeze

      class Home < self
        TEMPLATE = 'home.slim'.freeze
      end

      class Post < self
        TEMPLATE = 'post.slim'.freeze
      end

    end

    class AdminTemplate < self

      LAYOUT = 'admin/layout.slim'.freeze

      class Home < self
        TEMPLATE = 'admin/home.slim'.freeze
      end

    end

  end
end
