class EvaluationPostsController < PostsController
  private

  def set_categories
    @categories = EvaluationCategory.all
  end
end
