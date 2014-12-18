class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order('updated_at desc')
  end

  def new
    @post = Post.new
    @tag = @post.tags.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.new(post_params.merge(user: current_user))
    params[:upload_file_ids].try(:each) {|id| @post.upload_files << UploadFile.try(:find, id)}

    if @post.save
      flash[:notice] = 'Post Success'
      redirect_to action: 'index'
    else
      flash[:error] = @post.errors.full_messages.join(', ')
      render 'index'
    end
  end

  def edit
    @tags = @post.tags
    respond_to do |format|
      format.js
    end
  end

  def update
    if @post.update(post_params)
      params[:upload_file_ids].try(:each) {|id| @post.upload_files << UploadFile.try(:find, id)}
      flash[:notice] = 'Update Success'
      redirect_to action: 'index'
    else
      flash[:error] = @post.errors.full_messages.join(', ')
      render 'index'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Delete Success'
    redirect_to action: :index
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :media_type, :tag_list, :category_id)
  end
end
