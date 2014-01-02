require 'spec_helper'

describe Schnitzelpress::App do
  include Rack::Test::Methods
  include FactoryHelper

  def app
    Schnitzelpress::App
  end

  describe 'the home page' do
    before do
      5.times { create_post }
      get '/'
    end

    subject { last_response }

    it { should be_ok }
    its(:body) { should have_tag 'title', :text => "Home | #{Schnitzelpress::Model::Config.instance.blog_title}" }
    its(:body) { should have_tag 'section.posts > article.post', :count => 5 }
    its(:body) { should_not have_tag 'section.posts > article.post.draft' }
  end

  describe 'viewing a single post' do

    let(:post) { create_post(:published_at => "2011-12-10 12:00", :slug => 'slug') }

    subject { last_response }

    before do
      get post.to_url
    end

    it { should be_ok }
    its(:body) { should have_tag 'title', :text => "#{post.title} | #{Schnitzelpress::Model::Config.instance.blog_title}" }
  end
end
