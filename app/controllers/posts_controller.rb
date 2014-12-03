class PostsController < ApplicationController
  before_action :set_category
  def index
    @posts = @category.posts.order('updated_at desc')
    @post = Post.new
  end

  def new
  end

  def create
    @post = Post.new(post_params.merge(user: current_user, category: @category))
    params[:upload_file_ids].try(:each) {|id| @post.upload_files << UploadFile.find(id)}

    if @post.save
      @posts = @category.posts
      flash[:notice] = 'Post Success'
      redirect_to action: 'index'
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
    params.require(:post).permit(:title, :content, :media_type)
  end
end
