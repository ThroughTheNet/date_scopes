require 'spec_helper'

class Post < ActiveRecord::Base;end
class Page < ActiveRecord::Base;end
class Empty < ActiveRecord::Base;end

describe DateScopes do
  
  context 'with default options' do
    before(:all) {Post.class_exec {has_date_scopes}}
    
    it 'has un-scopes' do
      Post.scopes.should include(:unpublished)
      Post.scopes.should include(:nonpublished)
      Post.scopes.should include(:non_published)
      Post.scopes.should include(:not_published)
    end
    
    it 'has on-scope' do
      Post.scopes.should include(:published)
    end
    
    it "accepts true to boolean setter and sets as the time" do
      Timecop.freeze do
        post = Post.new
        post.published = true
        post.published_at.should == Time.now
      end
    end
    
    it "doesn't reset the time with a boolean when time is already set" do
      Timecop.freeze
      post = Post.new
      post.published = true
      post.save
      time = post.published_at
      Timecop.return
      post.update_attributes :published => true
      time.should == post.published_at
    end
    
    it "accepts false to boolean setter and sets column as nil" do
      post = Post.new
      post.published_at = Time.now
      post.save
      post.published_at.should_not be_nil
      post.should be_published
      post.published = false
      post.save
      post.published_at.should be_nil
      post.should_not be_published
    end
    
    it 'copes with string passed to boolean setter' do
      post = Post.new
      post.published = 'true'
      post.should be_published
      post.published = 'False'
      post.should_not be_published
    end
    
    it 'copes with integer as string passed to boolean setter' do
      post = Post.new
      post.published = '1'
      post.should be_published
      post.published = '0'
      post.should_not be_published
    end
    
    it 'copes with integer passed to boolean setter' do
      post = Post.new
      post.published = 1
      post.should be_published
      post.published = 0
      post.should_not be_published
    end
    
    context 'when published_at is in the past' do
      before(:all) {@post = Post.create(:published_at => Time.now - 10.minutes)}
      
      it 'is in the published scope' do
        Post.published.should include(@post)
      end
      
      it 'is not in the unpublished scope' do
        Post.unpublished.should_not include(@post)
      end
      
      it "is published" do
        @post.should be_published
      end
      
    end
    
    context 'when published_at is in the future' do
      before(:all) {@post = Post.create :published_at => Time.now + 10.minutes}
      
      it "is in the unpublished scope" do
        Post.unpublished.should include(@post)
      end
      
      it "is not in the published scope" do
        Post.published.should_not include(@post)
      end
      
      it "is not published" do
        @post.should_not be_published
      end
      
    end
    
    context 'when published_at is empty' do
      before(:all) {@post = Post.create(:published_at => nil)}
      
      it "is in the unpublished scope" do
        Post.unpublished.should include(@post)
      end
      
      it "is not in the published scope" do
        Post.published.should_not include(@post)
      end
      
      it "is not published" do
        @post.should_not be_published
      end
    end
    
    context 'with custom column name' do
      before(:all) {Page.class_exec{has_date_scopes :column => :sold}}
      
      it 'has un-scopes' do
        Page.scopes.should include(:unsold)
        Page.scopes.should include(:nonsold)
        Page.scopes.should include(:non_sold)
        Page.scopes.should include(:not_sold)
      end
      
      it 'has on-scope' do
        Page.scopes.should include(:sold)
      end
    end
    
    context 'when missing the required column' do
      it "raises an exception" do
        lambda {Empty.class_exec{has_date_scopes(:column => :foobar)}}.should raise_error
      end
    end
  end
  
end
