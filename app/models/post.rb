class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :upload_files, dependent: :destroy
  validates :user, :category, :title, presence: true

  acts_as_taggable
  MediaType = %w(DJY EET NTD MAGZINE WEBSITE ELSE)
end
