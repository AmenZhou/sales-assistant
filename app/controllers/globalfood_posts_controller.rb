class GlobalfoodPostsController < PostsController
  private

  def set_categories
    @categories = GlobalfoodCategory.all
  end
end
