class PostSearch
  attr_accessor :tag, :category_id, :media_type, :user_id, :title, :klass_name
  include ActiveModel::Model

  def initialize search_params = {}, controller_name = 'posts'
    search_params.try(:each) do |key, value|
      self.send("#{key}=", value.present? ? value : nil)
    end
    self.klass_name = controller_name.classify.constantize
  end

  def search
    posts = klass_name.all
    posts = posts.where('title LIKE :title', title: "%#{title}%") if title
    posts = posts.tagged_with(tag) if tag
    posts = posts.where(category_id: category_id) if category_id
    posts = posts.where(user_id: user_id) if user_id
    posts = posts.where(media_type: media_type) if media_type
    posts
  end
end
