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

      end
    end
  end
end
