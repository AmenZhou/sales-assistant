class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :upload_files, dependent: :destroy
  validates :user, :title, presence: true

  acts_as_taggable
  MediaType = %w(中文大紀元 英文大紀元 新唐人 雜誌 網站 亞洲美食 其他)

  scope :by_quick_search, ->(query) { joins(:upload_files).where('title like :query OR content like :query OR upload_files.image like :query', query: "%#{query}%") }

  self.per_page = 10
end
