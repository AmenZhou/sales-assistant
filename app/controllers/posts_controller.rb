class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order('updated_at desc')
  end

  def new
    @post = Post.new
    @tag = @post.tags.build
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

  def by_tag
    if params[:tag] == 'all'
      @posts = Post.order('updated_at desc')
    else
      @posts = Post.tagged_with(params[:tag]).order('updated_at desc')
    end
  end

  def by_username
    if params[:username] == 'all'
      @posts = Post.order('updated_at desc')
    else
      user = User.find_by_email(params[:username])
      @posts = user.posts.order('updated_at desc') if user
    end
  end

  def by_media_type
    if params[:media_type] == 'all'
      @posts = Post.order('updated_at desc')
    else
      @posts = Post.where(media_type: params[:media_type]).order('updated_at desc')
    end
  end

  def by_category
    if params[:category] == 'all'
      @posts = Post.order('updated_at desc')
    else
      @posts = Post.joins(:category).where(categories: {name: params[:category]} ).order('updated_at desc')
    end
  end

  def by_quick_search
    if params[:query]
      @posts = Post.by_quick_search(params[:query]).order('updated_at desc')
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :media_type, :tag_list, :category_id)
  end
end
