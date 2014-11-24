class PostsController < ApplicationController
  before_action :set_category
  def index
    @posts = @category.posts
  end

  def new
  end

  def create
    @post = Post.new(post_params.merge(user: current_user, category: @category))
    if @post.save
      @posts = @category.posts
      render 'index', notice: 'Post Success'
      #redirect_to category_posts_path(@category), notice: 'Post successful'
    else
      flash[:error] = @post.errors.full_messages.join(', ')
      render 'index'
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
