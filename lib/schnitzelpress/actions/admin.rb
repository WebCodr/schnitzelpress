module Schnitzelpress
  module Actions
    # Route definitions for Admin
    module Admin
      extend ActiveSupport::Concern

      included do
        before '/admin/?*' do
          admin_only!
        end

        get '/admin/?' do
          @posts  = Schnitzelpress::Model::Post.latest
          @pages  = Schnitzelpress::Model::Post.published.pages
          @drafts = Schnitzelpress::Model::Post.drafts

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
          @post = Schnitzelpress::Model::Post.new

          slim :'admin/new'
        end

        post '/admin/new/?' do
          post = Schnitzelpress::Model::Post.new(params[:post])

          if post.save
            redirect url_for(post)
          else
            @post = post

            post.errors.each do |error|
              puts "Error '#{error}'"
            end

            slim :'admin/new'
          end
        end

        get '/admin/edit/:id/?' do
          @post = Schnitzelpress::Model::Post.get(params[:id])

          slim :'admin/edit'
        end

        post '/admin/edit/:id/?' do
          post = Schnitzelpress::Model::Post.get(params[:id])
          post.update(params[:post])

          if post.save
            redirect url_for(post)
          else
            @post = post

            post.errors.each do |error|
              puts "Error '#{error}'"
            end

            slim :'admin/edit'
          end
        end

        delete '/admin/edit/:id/?' do
          post = Schnitzelpress::Model::Post.get(params[:id])
          post.destroy

          redirect '/admin'
        end
      end
    end
  end
end
