require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Posts", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) {FactoryGirl.create(:category)}
  before do
    login_as user, scope: :user
  end

  describe "new post", js: true do
    it "/category/:id/posts should has category name" do
      visit category_posts_path(category_id: category.id)
      expect(page).to have_content category.name
    end

    it "click new post button should pop up a new post form" do
      visit category_posts_path(category_id: category.id)
      page.should have_content 'New Post'
      click_link 'New Post'
      page.should have_selector ".new_post"
    end

    it "click new post should pop up an upload file form" do
      visit category_posts_path(category_id: category.id)
      click_link 'New Post'
      page.should have_selector ".new_upload_file"
      page.should have_selector "input[value='Upload File']"
    end

    it "upload file should success" do
      visit category_posts_path(category_id: category.id)
      click_link 'New Post'
      within('.new_upload_file') do
        attach_file 'upload_file[image]', Rails.root + 'spec/factories/download.jpg'
        find("input[value='Upload File']").click
      end
      page.should have_selector '#file_list'
    end
  end
end
