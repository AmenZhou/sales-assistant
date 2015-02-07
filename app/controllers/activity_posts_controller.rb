class ActivityPostsController < PostsController
  def index
    super
    @categories = ActivityCategory.all
  end
end
