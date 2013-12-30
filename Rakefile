$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

ENV['RACK_ENV'] = 'production'

require 'bundler/setup'
require 'schnitzelpress'

def type(post)
  return :page if post.page?

  :post
end

def published_at(post)
  return Time.now unless post.published_at

  post.published_at
end

task :migrate do
  Schnitzelpress::Post.each do |post|
    pg_post = Schnitzelpress::Model::Post.create(
      :published_at => published_at(post),
      :type => type(post),
      :status => post.status,
      :comments => post.disqus,
      :slug => post.slug,
      :title => post.title,
      :body => post.body,
      :transformed_body => post.body_html
    )

    pg_post.errors.each do |error|
      puts "Error '#{error}' on post '#{post.title}'"
    end

    puts "Post '#{post.title}' migrated successfully!" if pg_post.saved?
  end
end