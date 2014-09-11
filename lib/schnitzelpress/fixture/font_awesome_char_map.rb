module Schnitzelpress
  module Fixture
    # Fixture class for font_awesome_char_map.yml
    class FontAwesomeCharMap

      FILE = 'font_awesome_char_map.yml'.freeze

      # Return all items of Font Awesome char map
      #
      # @return [Hash]
      #
      # @api private
      #
      def self.all
        @all ||= YAML.load_file(Schnitzelpress.fixtures.join(FILE))
      end
    end
  end
end
