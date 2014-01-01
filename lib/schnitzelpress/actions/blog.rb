module Schnitzelpress
  module Actions
    # Route definitions for Blog
    module Blog

      extend ActiveSupport::Concern

      included do
        get '/' do
          render_blog
        end

        get '/blog.atom' do
          content_type 'application/atom+xml; charset=utf-8'
          @posts = Schnitzelpress::Model::Post.latest.limit(10)

          slim :atom, format: :xhtml, layout: false
        end

        get '/:year/:month/:day/:slug/?' do |year, month, day, slug|
          @post = Schnitzelpress::Model::Post
            .for_day(year.to_i, month.to_i, day.to_i)
            .all(slug: slug).first

          render_post
        end

        def skipped
          params[:page].to_i * 10
        end

        def render_blog
          @posts = Schnitzelpress::Model::Post.latest.limit(10).skip(skipped)
          @show_previous_posts_button = show_previous_button?(@posts)
          @show_description = true

          render_posts
        end

        def show_previous_button?(posts)
          Schnitzelpress::Model::Post.posts.count > (skipped + posts.length)
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
          return halt 404 unless post_exists?(@post)
          return redirect url_for(@post) unless requested_canonical_url?(@post)

          slim :post
        end

      end
    end
  end
end
