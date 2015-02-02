require 'rails_helper'

RSpec.describe UploadFilesController, :type => :controller do
  describe "get download file" do
    let(:user) {User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')}
    let(:file) {UploadFile.create!(image: File.open(Rails.root + 'spec/factories/download.jpg'))}

    before :each do
      sign_in user
    end

    it "should success" do
      get :download_file, id: file.id
      response.should be_successful
    end
  end
end
