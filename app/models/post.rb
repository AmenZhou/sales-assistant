class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  validates :user, :category, presence: true

  mount_uploader :image, ImageUploader

  MediaType = %w(DJY EET NTD MAGZINE WEBSITE ELSE)
end
