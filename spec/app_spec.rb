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
    its(:body) { should have_tag 'title', :text => Schnitzelpress::Config.instance.blog_title }
    its(:body) { should have_tag 'section.posts > article.post', :count => 5 }
    its(:body) { should_not have_tag 'section.posts > article.post.draft' }
  end

  describe 'viewing a single post' do
    before do
      create_post(:published_at => "2011-12-10 12:00", :slug => 'slug')
      get "/2011/12/10/slug/"
    end

    subject { last_response }

    it { should be_ok }
  end
end
