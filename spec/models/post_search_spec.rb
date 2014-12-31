require 'rails_helper'

RSpec.describe PostSearch, :type => :model do
  describe 'get posts by different conditions' do
    before do
      user = FactoryGirl.create(:user)
      Post.create(title: 'apple', media_type: 'NTD', tag_list: 'fruit', user: user, content: 'An apple a day, keep doctor away!')
      Post.create(title: 'banana', media_type: 'EET', tag_list: 'fruit', user: user, content: 'A banana a day, keep doctor away!')
      Post.create(title: 'grape', media_type: 'DJY', tag_list: 'fruit', user: user, content: 'A grape a day, keep doctor away!')
      Post.create(title: 'orange', media_type: 'MAGAZINE', tag_list: 'fruit', user: user, content: 'An orange a day, keep doctor away!')
      Post.create(title: 'pear', media_type: 'WEBSITE', tag_list: 'fruit', user: user, content: 'A pear a day, keep doctor away!')
    end
    it 'should get search result by title' do
      post_search = PostSearch.new({title: 'apple'})
      post_search.search.count.should eq 1
      post_search.search.first.title.should eq 'apple'
    end

    it 'should get search result by tag' do
      post_search = PostSearch.new({tag: 'fruit'})
      post_search.search.count.should eq 5
    end

    it "should get search result by multiple conditions" do
      post_search = PostSearch.new(title: 'apple', media_type: 'NTD', tag: 'fruit')
      post_search.search.count.should eq 1
    end
  end
end
