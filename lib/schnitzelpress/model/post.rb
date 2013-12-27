module Schnitzelpress
  module Model
    class Post
      include DataMapper::Resource

      property :id,           Serial
      property :created_at,   DateTime
      property :updated_at,   DateTime
      property :published_at, DateTime
    end
  end
end