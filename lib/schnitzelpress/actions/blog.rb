module Schnitzelpress
  module Actions
    module Blog
      extend ActiveSupport::Concern

      included do
        get '/' do
          render_blog
        end

        get '/blog/?' do
          render_blog
        end

        get '/blog.atom' do
          content_type 'application/atom+xml; charset=utf-8'
          @posts = Post.latest.limit(10)

          slim :atom, :format => :xhtml, :layout => false
        end

        get '/feed/?' do
          redirect config.blog_feed_url, 307
        end

        get %r{^/(\d{4})/(\d{1,2})/(\d{1,2})/?$} do
          year, month, day = params[:captures]
          @posts = Post.latest.for_day(year.to_i, month.to_i, day.to_i)
          render_posts
        end

        get %r{^/(\d{4})/(\d{1,2})/?$} do
          year, month = params[:captures]
          @posts = Post.latest.for_month(year.to_i, month.to_i)
          render_posts
        end

        get %r{^/(\d{4})/?$} do
          year = params[:captures].first
          @posts = Post.latest.for_year(year.to_i)
          render_posts
        end

        get '/:year/:month/:day/:slug/?' do |year, month, day, slug|
          @post = Post.
            for_day(year.to_i, month.to_i, day.to_i).
            where(:slugs => slug).first

          render_post
        end

        get '/*/?' do
          slug = params[:splat].first
          @post = Post.where(:slugs => slug).first
          render_post
        end

        def skipped
          params[:page].to_i * 10
        end

        def render_blog
          @posts = Post.latest.skip(skipped).limit(10)

          displayed_count = @posts.count(true)
          @show_previous_posts_button = Post.total > skipped + displayed_count
          @show_description = true

          render_posts
        end

        def render_posts
          slim :index
        end

        def requested_canonical_url?(post)
          request.path == url_for(post)
        end

        def post_exists?(post)
          !!post
        end

        def render_post
          unless post_exists?(@post)
            return halt 404
          end

          unless requested_canonical_url?(@post)
            return redirect url_for(@post)
          end

          slim :post
        end
      end
    end
  end
end
