class SalesToolsController < PostsController
  def index
    super
    @categories = SalesToolCategory.all
  end

  private

  def post_params
    params.require(:sales_tool).permit(:title, :content, :media_type, :tag_list, :category_id)
  end
end
