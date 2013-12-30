module Schnitzelpress
  module Model
    class Post
      include DataMapper::Resource

      property :id,               Serial
      timestamps :at
      property :published_at,     DateTime
      property :type,             Enum[:page, :post], :default => :post
      property :status,           Enum[:draft, :published], :default => :draft
      property :comments,         Boolean, :default => true
      property :slug,             Slug
      property :title,            String, :length => 150
      property :body,             Text, :lazy => false
      property :transformed_body, Text, :lazy => false

      before :valid?, :create_slug
      validates_presence_of :slug
      validates_with_method :validate_slug

      before :save do
        transform_body
      end

      # Scope for published posts
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.published
        all(:status => :published)
      end

      # Scope for drafts
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.drafts
        all(:status => :draft)
      end

      # Scope for pages
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.pages
        all(:type => :page)
      end

      # Scope for posts
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.posts
        all(:type => :post)
      end

      # Scope for posts ordered by published_at desc
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.latest
        published.posts.all(:order => [:published_at.desc])
      end

      # Scope for skipping records
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.skip(offset)
        all(:offset => offset)
      end

      # Scope for limiting records
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.limit(limit)
        all(:limit => limit)
      end

      # Return posts for given day
      #
      # @param [Integer] year
      # @param [Integer] month
      # @param [Integer] day
      #
      # @return [DataMapper::Collection]
      #
      # @api private
      #
      def self.for_day(year, month, day)
        date = Date.new(year, month, day)

        all(:published_at => (date.beginning_of_day)..(date.end_of_day))
      end

      # Test if record is a post
      #
      # @return [Boolean]
      #
      # @api private
      #
      def post?
        type == :post
      end

      # Test if record is a page
      #
      # @return [Boolean]
      #
      # @api private
      #
      def page?
        type == :page
      end

      # Test if record is published
      #
      # @return [Boolean]
      #
      # @api private
      #
      def published?
        status == :published
      end

      # Test if record is a draft
      #
      # @return [Boolean]
      #
      # @api private
      #
      def draft?
        status == :draft
      end

      # Test if comments are allowed
      #
      # @return [Boolean]
      #
      # @api private
      #
      def comments?
        comments && published?
      end

      # Return publishing year
      #
      # @return [Integer]
      #
      # @api private
      #
      def year
        published_at.year
      end

      # Return publishing month
      #
      # @return [Integer]
      #
      # @api private
      #
      def month
        published_at.month
      end

      # Return publishing day
      #
      # @return [Integer]
      #
      # @api private
      #
      def day
        published_at.day
      end

      # Return identifier for record (f.e. as ID for disqus)
      #
      # @return [String]
      #
      # @api private
      #
      def post_identifier
        "post-#{id}"
      end

      # Return URL for record
      #
      # @return [String]
      #
      # @api private
      #
      def to_url
        "/#{sprintf('%04d', year)}/#{sprintf('%02d', month)}/#{sprintf('%02d', day)}/#{slug}/"
      end

      # Return transformed HTML
      #
      # @return [String]
      #
      # @api private
      #
      def to_html
        if transformed_body.empty?
          transform_body
          save
        end

        transformed_body
      end

      # Set publishing date and parse it with Chronic if it's a string
      #
      # @param [String] value
      #
      # @api private
      #
      def published_at=(value)
        value = Chronic.parse(value) if value.is_a?(String)

        super(value)
      end

    private

      # Validate slug
      #
      # @api private
      #
      def validate_slug
        conflicting_posts = self.class.all(:slug => self.slug)

        if conflicting_posts.any? && conflicting_posts.first.id != self.id
          return [false, "Slug '#{self.slug}' already exists!"]
        end

        true
      end

      # Create slug for post
      #
      # @api private
      #
      def create_slug
        if !self.slug || self.slug.empty?
          self.slug = title.parameterize
        end
      end

      # Transform body markdown source into HTML
      #
      # @api private
      #
      def transform_body
        self.transformed_body = transform_markdown(body)
      end

      # Transform given markdown source into HTML with slodown.py
      #
      # @param [String] source
      #
      # @returm [String]
      #
      # @api private
      #
      def transform_markdown(source)
        Slodown::Formatter.new(source).complete.to_s
      end

    end
  end
end