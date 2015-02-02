class UploadFile < ActiveRecord::Base
  require 'file_size_validator' 
  belongs_to :post
  mount_uploader :image, ImageUploader

  validates :image, :file_size => {
    :maximum => 5.megabytes.to_i
  }

  def self.get_path_by_id id
    find(id).image.current_path
  rescue
    ''
  end
end
