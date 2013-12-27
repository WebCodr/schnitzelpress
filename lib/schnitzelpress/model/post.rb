module Schnitzelpress
  module Model
    class Post
      include DataMapper::Resource

      property :id,            Serial
      property :published_at,  DateTime, :key => true
      property :type,          Enum[:page, :post], :default => :post, :key => true
      property :status,        Enum[:draft, :published], :default => :draft, :key => true
      property :comments,      Boolean, :default => true
      property :slug,          Slug, :key => true
      property :title,         String, :key => true
      property :body,          Text
      property :rendered_body, Text

      timestamps :at
      timestamps :on
    end
  end
end