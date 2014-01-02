module Schnitzelpress
  module Actions
    # Route definitions for Blog
    module Blog

      extend ActiveSupport::Concern

      included do
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
