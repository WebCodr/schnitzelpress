module FactoryHelper

  def create_post(properties = {})
    post_properties = {
      published_at: Time.now,
      type: :post,
      status: :published,
      comments: true,
      title: FFaker::Lorem.sentence,
      body: FFaker::Lorem.paragraphs
    }.merge(properties)

    Schnitzelpress::Model::Post.create(post_properties)
  end

end