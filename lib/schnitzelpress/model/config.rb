module Schnitzelpress
  module Model
    class Config
      include DataMapper::Resource

      property :id,                  String, :key => true
      timestamps :at
      property :blog_title,          String, :default => "A New Schnitzelpress Blog"
      property :blog_description,    Text, :default => ""
      property :blog_footer,         Text, :default => "powered by [Schnitzelpress](http://schnitzelpress.org)"
      property :blog_feed_url,       String, :default => "/blog.atom"
      property :author_name,         String, :default => "Joe Schnitzel"
      property :disqus_id,           String
      property :google_analytics_id, String
      property :gauges_id,           String
      property :gosquared_id,        String
      property :twitter_id,          String

      validates_presence_of :blog_title, :author_name

      def self.instance
        @instance ||= first_or_create(:id => 'schnitzelpress')
      end

      def self.forget_instance
        @instance = nil
      end

      def self.get(key)
        instance.send(key)
      end

      def self.set(key, value)
        instance.update(key => value)

        value
      end
    end
  end
end