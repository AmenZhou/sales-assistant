class EvaluationPostsController < PostsController
  def index
    super
    @categories = EvaluationCategory.all
  end
end
