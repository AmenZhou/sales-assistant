class ActivityPostsController < PostsController
  private

  def set_categories
    @categories = ActivityCategory.all
  end
end
