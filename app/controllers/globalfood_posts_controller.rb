class GlobalfoodPostsController < PostsController
  def index
    super
    @categories = GlobalfoodCategory.all
  end
end
