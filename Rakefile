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

def migrate_posts
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

def migrate_config
  config = Schnitzelpress::Config.instance

  pg_config = Schnitzelpress::Model::Config.create(
    :id => 'schnitzelpress',
    :blog_title => config.blog_title,
    :blog_description => config.blog_description,
    :blog_footer => config.blog_footer,
    :blog_feed_url => config.blog_feed_url,
    :author_name => config.author_name,
    :disqus_id => config.disqus_id,
    :gauges_id => config.gauges_id,
    :gosquared_id => config.gosquared_id,
    :twitter_id => config.twitter_id
  )

  pg_config.errors.each do |error|
    puts "Error '#{error}'"
  end

  puts "Config migrated successfully!" if pg_config.saved?
end

task :migrate do
  migrate_config
end