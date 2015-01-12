require 'rails_helper'
require 'spec_helper'

RSpec.describe SalesToolsController, :type => :controller do
  describe "GET index" do
    let(:user) {User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')}

    before :each do
      sign_in user
    end

    it "load index with a post" do
      category = Category.create(name: 'Art')
      post = SalesTool.create(category: category, title: 'Hello', content: 'Hellow World', user: user)
      get :index
      expect(assigns(:posts)).to match_array([post])
    end
  end

  describe "POST create" do
    let(:user) {User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')}
    let(:category) {Category.create(name: 'Art')}

    before :each do
      sign_in user
    end


    it "create a new post" do
      post :create, sales_tool: {title: 'Hello', content: 'Hellow World', category_id: category.id}
      expect(response).to redirect_to(action: :index)
      SalesTool.count.should eq 1
    end

    it "create a new post with pictures" do
      file = FactoryGirl.create(:upload_file)
      file2 = FactoryGirl.create(:upload_file)
      post :create, sales_tool: {title: 'Hello', content: 'Hello World', category_id:category.id}, upload_file_ids: [file.id, file2.id]
      assigns(:post).upload_files.should eq [file, file2]
    end

    it "create a post with tags" do
      post :create, sales_tool: {title: 'Hello', content: 'Hello World', tag_list: 'animal, plant', category_id:category.id}
      assigns(:post).tags.pluck(:name).should eq ['animal', 'plant']
    end
  end
end
