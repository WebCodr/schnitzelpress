module Schnitzelpress
  # Views
  class View

    include Concord.new(:response)

    def self.call(response)
      new(response).call
    end

    def call
      layout.render(Page.new(:content => content), :helper => Helper)
    end

    def content
      template.render(response.output, :helper => Helper)
    end

    def template(name = self.class::TEMPLATE)
      Tilt.new(Kickipedia.templates.join(name.to_s).to_s)
    end

    def layout(name = self.class::LAYOUT)
      template(name)
    end

    class Page
      include Anima.new(:content)
    end

    class Helper
      def self.partial(name, locals = {})
        locals.store(:helper, Helper)
        template('partials/' + name.to_s + '.slim').render(nil, locals)
      end
    end

    class Template < self

      LAYOUT = 'layout.slim'.freeze

      class Home < self
        TEMPLATE = 'home.slim'.freeze
      end

    end

  end
end