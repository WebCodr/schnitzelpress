require 'spec_helper'

describe Schnitzelpress::Model::Post do
  include FactoryHelper

  subject do
    create_post
  end

  context 'slug' do
    before do
      subject.slug = 'a-new-slug'
    end

    its(:slug) { should == 'a-new-slug' }
  end

  context 'saving' do
    context 'when no slug is set' do
      before { subject.slug = nil }

      context 'when a title is available' do
        before { subject.title = 'Team Schnitzel is AWESOME!' }

        it 'should set its slug to a sluggified version of its title' do
          expect { subject.save }.to change(subject, :slug).
            from(nil).
            to('team-schnitzel-is-awesome')
        end
      end
    end
  end

  describe '.latest' do
    before do
      5.times { create_post }
    end

    subject do
      Schnitzelpress::Model::Post.latest
    end

    it 'should return the latest published posts' do
      expect(subject.size).to eql(5)
    end
  end

  context 'date methods' do
    before { subject.published_at = '2012-01-02 12:23:13' }
    its(:year)  { should == 2012 }
    its(:month) { should == 01 }
    its(:day)   { should == 02 }
  end

  context 'to_url' do
    subject do
      post.to_url
    end

    let(:post) do
      create_post(published_at: '2012-1-1 12:00:00', slug: 'test')
    end

    it 'should produce double-digit months and days' do
      expect(subject).to eql('/2012/01/01/test')
    end
  end
end
