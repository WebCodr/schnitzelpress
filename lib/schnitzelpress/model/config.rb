module Schnitzelpress
  module Model
    # Config model
    class Config

      include DataMapper::Resource

      DEFAULT_TITLE    = 'A New Schnitzelpress Blog'.freeze
      DEFAULT_FOOTER   = <<-FOOTER.freeze
              powered by [Schnitzelpress](http://schnitzelpress.org)
      FOOTER
      DEFAULT_FEED_URL =  '/blog.atom'.freeze
      DEFAULT_AUTHOR   = 'Joe Schnitzel'.freeze

      property :id, String, key: true
      timestamps :at
      property :blog_title, String, default: DEFAULT_TITLE
      property :blog_description, Text, default: ''
      property :blog_footer, Text, default: DEFAULT_FOOTER
      property :blog_feed_url, String, default: DEFAULT_FEED_URL
      property :author_name, String, default: DEFAULT_AUTHOR
      property :disqus_id, String
      property :google_analytics_id, String
      property :gauges_id, String
      property :gosquared_id, String
      property :twitter_id, String

      validates_presence_of :blog_title, :author_name

      # Create or return config instance from ID schnitzelpress
      #
      # @return [Schnitzelpress::Model::Config]
      #
      # @api private
      #
      def self.instance
        @instance ||= first_or_create(id: 'schnitzelpress')
      end

      # Reset instance variable
      #
      # @api private
      #
      def self.forget_instance
        @instance = nil
      end

      # Return a value from instance of given key
      #
      # @param [Symbol|String] key
      #
      # @api private
      #
      def self.get(key)
        instance.send(key)
      end

      # Set a value for given key
      #
      # @param [Symbol|String] key
      # @param [String] key
      #
      # @return [String]
      #
      # @api private
      #
      def self.set(key, value)
        instance.update(key => value)

        value
      end

    end
  end
end
