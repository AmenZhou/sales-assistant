class PostsController < ApplicationController
  before_action :set_category
  before_action :set_post, only: [:edit, :update]

  def index
    @posts = @category.posts.order('updated_at desc')
  end

  def new
    @post = Post.new
    respond_to do |format|
      format.js
    end
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

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @post.update(post_params)
      params[:upload_file_ids].try(:each) {|id| @post.upload_files << UploadFile.find(id)}
      flash[:notice] = 'Update Success'
      redirect_to action: 'index'
    else
      flash[:error] = @post.errors.full_messages.join(', ')
      render 'index'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :media_type)
  end
end
