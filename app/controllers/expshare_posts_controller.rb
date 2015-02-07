class ExpsharePostsController < PostsController
  def index
    super
    @categories = ExpshareCategory.all
  end
end
