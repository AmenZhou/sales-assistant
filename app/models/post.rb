class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :upload_files, dependent: :destroy
  validates :user, :category, presence: true


  MediaType = %w(DJY EET NTD MAGZINE WEBSITE ELSE)
end
