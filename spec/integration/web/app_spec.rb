require 'spec_helper'

feature Schnitzelpress::App, '/' do
  include FactoryHelper

  let(:blog_title) do
    Schnitzelpress::Model::Config.instance.blog_title
  end

  context 'view home page' do

    before do
      5.times { create_post }
    end

    specify do
      visit('/')
      expect(page.status_code).to be 200
      expect(body.empty?).to be(false)
      expect(page).to have_title "Home | #{blog_title}"
      expect(body).to have_selector('section.posts > article.post', count: 5)
    end
  end

  context 'view a single post' do

    let(:post) { create_post(published_at: '2011-12-10 12:00', slug: 'slug') }

    specify do
      visit(post.to_url)
      expect(page.status_code).to be 200
      expect(body.empty?).to be(false)
      expect(page).to have_title "#{post.title} | #{blog_title}"
      expect(page).to have_content(post.title)
    end
  end
end
