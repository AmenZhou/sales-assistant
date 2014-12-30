class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :upload_files, dependent: :destroy
  validates :user, :title, presence: true

  acts_as_taggable
  MediaType = %w(DJY EET NTD MAGZINE WEBSITE ELSE)

  scope :by_quick_search, ->(query) { joins(:upload_files).where('title like :query OR content like :query OR upload_files.image like :query', query: "%#{query}%") }

  self.per_page = 10
end
