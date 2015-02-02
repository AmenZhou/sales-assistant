require 'rails_helper'

RSpec.describe UploadFile, :type => :model do
  describe "get_filepath_by_id" do
    let(:file) {UploadFile.create!(image: File.open(Rails.root + 'spec/factories/download.jpg'))}
    it "get a file path by id should success" do
      UploadFile.get_path_by_id(file.id).should be_an_instance_of String
    end
  end
end
