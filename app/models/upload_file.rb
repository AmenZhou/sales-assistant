class UploadFile < ActiveRecord::Base
  require 'file_size_validator' 
  belongs_to :post
  mount_uploader :image, ImageUploader

  validates :image, :file_size => {
    :maximum => 5.megabytes.to_i
  }
end
