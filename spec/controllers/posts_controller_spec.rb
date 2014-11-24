require 'rails_helper'
require 'spec_helper'

RSpec.describe PostsController, :type => :controller do
  describe "GET index" do
    let(:user) {User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')}

    before :each do
      sign_in user
    end

    it "load index with a post" do
      category = Category.create(name: 'Art')
      post = Post.create(category: category, title: 'Hello', content: 'Hellow World', user: user)
      get :index, category_id: category.id
      expect(assigns(:posts)).to match_array([post])
    end
  end

  describe "POST create" do
    let(:user) {User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')}

    before :each do
      sign_in user
    end

    it "create a new post" do
      category = Category.create(name: 'Art')
      post :create, post: {title: 'Hello', content: 'Hellow World'}, category_id: category.id
      expect(response).to render_template(:index)
      Post.count.should eq 1
    end
  end
end
