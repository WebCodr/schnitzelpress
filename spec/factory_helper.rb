module FactoryHelper

  def create_post(properties = {})
    post_properties = {
      published_at: Time.now,
      type: :post,
      status: :published,
      comments: true,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraphs
    }.merge(properties)

    Schnitzelpress::Model::Post.create(post_properties)
  end

end