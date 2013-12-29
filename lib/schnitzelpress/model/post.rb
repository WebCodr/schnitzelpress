module Schnitzelpress
  module Model
    class Post
      include DataMapper::Resource

      property :id,            Serial
      property :published_at,  DateTime, :key => true
      property :type,          Enum[:page, :post], :default => :post, :key => true
      property :status,        Enum[:draft, :published], :default => :draft, :key => true
      property :comments,      Boolean, :default => true
      property :slug,          Slug, :key => true
      property :title,         String, :length => 150, :key => true
      property :body,          Text, :lazy => false
      property :rendered_body, Text, :lazy => false

      timestamps :at

      def self.published
        all(:status => :published)
      end

      def self.drafts
        all(:status => :draft)
      end

      def self.pages
        all(:type => :page)
      end

      def self.posts
        all(:type => :post)
      end

      def self.latest
        published.posts.all(:order => [:published_at.desc])
      end

      def self.skip(offset)
        all(:offset => offset)
      end

      def self.limit(limit)
        all(:limit => limit)
      end

      def self.for_day(year, month, day)
        date = Date.new(year, month, day)

        all(:published_at => (date.beginning_of_day)..(date.end_of_day))
      end

      def post?
        type == :post
      end

      def page?
        type == :page
      end

      def published?
        status == :published
      end

      def draft?
        status == :draft
      end

      def year
        published_at.year
      end

      def month
        published_at.month
      end

      def day
        published_at.day
      end

      def comments?
        comments && published?
      end

      def post_identifier
        "post-#{id}"
      end

      def to_url
        "/#{sprintf '%04d', year}/#{sprintf '%02d', month}/#{sprintf '%02d', day}/#{slug}/"
      end

      def to_html
        rendered_body
      end

    end
  end
end