module Schnitzelpress
  module Actions
    module Admin
      extend ActiveSupport::Concern

      included do
        before '/admin/?*' do
          admin_only!
        end

        get '/admin/?' do
          @posts  = Post.published.posts.desc(:published_at)
          @pages  = Post.published.pages
          @drafts = Post.drafts
          slim :'admin/admin'
        end

        get '/admin/config/?' do
          slim :'admin/config'
        end

        post '/admin/config' do
          config.attributes = params[:config]
          if config.save
            redirect '/admin'
          else
            slim :'admin/config'
          end
        end

        get '/admin/new/?' do
          @post = Post.new
          slim :'admin/new'
        end

        post '/admin/new/?' do
          @post = Post.new(params[:post])
          if @post.save
            redirect url_for(@post)
          else
            slim :'admin/new'
          end
        end

        get '/admin/edit/:id/?' do
          @post = Post.find(params[:id])
          slim :'admin/edit'
        end

        post '/admin/edit/:id/?' do
          @post = Post.find(params[:id])
          @post.attributes = params[:post]
          if @post.save
            redirect url_for(@post)
          else
            slim :'admin/edit'
          end
        end

        delete '/admin/edit/:id/?' do
          @post = Post.find(params[:id])
          @post.destroy
          redirect '/admin'
        end
      end
    end
  end
end
