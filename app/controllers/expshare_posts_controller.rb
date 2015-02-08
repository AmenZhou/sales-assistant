class ExpsharePostsController < PostsController
  private

  def set_categories
    @categories = ExpshareCategory.all
  end
end
