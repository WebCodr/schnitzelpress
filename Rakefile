$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

ENV['RACK_ENV'] = 'development'

require 'bundler/setup'
require 'schnitzelpress'

def type(post)
  return :page if post.page?

  :post
end

task :migrate do
  Schnitzelpress::Post.posts.each do |post|
    pg_post = Schnitzelpress::Model::Post.create(
      :published_at => post.published_at,
      :type => type(post),
      :status => post.status,
      :comments => post.disqus,
      :slug => post.slug,
      :title => post.title,
      :body => post.body,
      :rendered_body => post.body_html
    )

    puts "Post '#{post.title}' migrated successfully!" if pg_post.saved?
  end
end