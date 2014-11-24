class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  validates :user, :category, presence: true

  mount_uploader :image, ImageUploader
end
