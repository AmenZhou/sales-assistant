require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Posts", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) {FactoryGirl.create(:category)}
  before do
    login_as user, scope: :user
  end

  describe "new post" do
    before :each do
      visit category_posts_path(category_id: category.id)
    end

    it "/category/:id/posts should has category name" do
      expect(page).to have_content category.name
    end

    it "click new post button should pop up a new post form", js: true do
      page.should have_content 'New Post'
      click_link 'New Post'
      page.should have_selector ".new_post"
    end

    it "click new post should pop up an upload file form", js: true  do
      click_link 'New Post'
      page.should have_selector ".new_upload_file"
      page.should have_selector "input[value='Upload File']"
    end

    #it "upload file should success", js: true do
      #click_link 'New Post'
      #uploading_file
      #wait_for_ajax
      #page.should have_selector '#file_list li'
      #page.has_selector? 'input[name="upload_file_ids[]"]'
    #end

    #it "delete existing file should success", js: true do
      #click_link 'New Post'
      #uploading_file
      #wait_for_ajax
      #delete_uploaded_file
      #wait_for_ajax
      #page.should_not have_selector '#file_list li'
      #page.has_no_selector? 'input[name="upload_file_ids[]"]'
    #end


    #it "create a new post test 2 should success", js: true do
      #click_link 'New Post'
      #uploading_file
      #wait_for_ajax
      #delete_uploaded_file
      #wait_for_ajax
      #within('#post_form') do
        #fill_in 'post_title', with: 'Hello World'
        #fill_in 'post_content', with: 'Hello World'
        #select('EET', from: 'Media type')
        #find('input[value="Submit"]').click
      #end
      #page.should have_content 'Success'
    #end

    it "create a new post should success", js: true do
      click_link 'New Post'
      within('#post_form') do
        fill_in 'post_title', with: 'Hello World'
        fill_in 'post_content', with: 'Hello World'
        select('EET', from: 'Media type')
        find('input[value="Submit"]').click
      end
      page.should have_content 'Success'
    end

    it "create a new post with tags should success", js: true do
      click_link 'New Post'
      within('#post_form') do
        fill_in 'post_title', with: 'Hello World'
        fill_in 'post_content', with: 'Hello World'
        select('EET', from: 'Media type')
        find('#tag_name_input').set('Tag Test')
        find('input[value="Submit"]').click
      end
      page.should have_content 'Success'
      page.should have_content 'Tag Test'
    end

    it "create a new post with multiple tags should success", js: true do
      click_link 'New Post'
      click_link 'Add Tag'
      within('#post_form') do
        fill_in 'post_title', with: 'Hello World'
        fill_in 'post_content', with: 'Hello World'
        select('EET', from: 'Media type')
        first('#tag_name_input').set('Tag Test')
        find('input[value="Submit"]').click
      end
      page.should have_content 'Success'
      page.should have_content 'Tag Test'
    end
  end

  describe "edit post" do
    it "edit post should success", js: true do
      click_link 'New Post'
      within('#post_form') do
        fill_in 'post_title', with: 'Hello World'
        fill_in 'post_content', with: 'Hello World'
        select('EET', from: 'Media type')
        find('#tag_name_input').set('Tag Test')
        find('input[value="Submit"]').click
      end
      page.should have_content 'Success'
      page.should have_content 'Tag Test'
    end
  end
end
