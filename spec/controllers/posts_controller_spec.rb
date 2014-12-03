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
    let(:category) {Category.create(name: 'Art')}

    before :each do
      sign_in user
    end

    after(:each) do
      if Rails.env.test? || Rails.env.cucumber?
        @document.try(:versions).try(:each) do |v|
          store_path = File.dirname(File.dirname(v.document_file.url))
          temp_path = v.document_file.cache_dir
          FileUtils.rm_rf(Dir["#{Rails.root}/public/#{store_path}/[^.]*"])
          FileUtils.rm_rf(Dir["#{temp_path}/[^.]*"])
        end
      end
    end

    it "create a new post" do
      post :create, post: {title: 'Hello', content: 'Hellow World'}, category_id: category.id
      expect(response).to redirect_to(action: :index)
      Post.count.should eq 1
    end

    it "create a new post with pictures" do
      file = FactoryGirl.create(:upload_file)
      file2 = FactoryGirl.create(:upload_file)
      post :create, post: {title: 'Hello', content: 'Hello World'}, category_id:category.id, upload_file_ids: [file.id, file2.id]
      assigns(:post).upload_files.should eq [file, file2]
    end
  end
end
