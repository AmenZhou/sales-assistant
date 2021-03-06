class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy, :show]
  before_action :check_authorization
  before_action :set_categories, only: [:index, :create, :by_category, :by_complex_search, :new, :edit]

  def index
    if params[:post_search]
      @post_search = PostSearch.new(post_search_params, controller_name)
      @posts = @post_search.search
    else
      @post_search = PostSearch.new
      @posts = model_name.order('updated_at desc')
    end
    @posts ||= model_name.none
    @posts = @posts.page(params[:page])
  end

  def clear_search
    current_user.tmp_params={}
    current_user.save
    redirect_to  :action => "index"
  end

  def show
  end

  def new
    @post = model_name.new
    @tag = @post.tags.build
  end

  def create
    @post = model_name.new(post_params.merge(user: current_user))
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
      @posts = model_name.order('updated_at desc').page(params[:page])
    else
      @posts = model_name.tagged_with(params[:tag]).order('updated_at desc').page(params[:page])
    end
  end

  def by_username
    if params[:username] == 'all'
      @posts = model_name.order('updated_at desc').page(params[:page])
    else
      user = User.find_by_email(params[:username])
      @posts = user.posts.order('updated_at desc').page(params[:page]) if user
    end
  end

  def by_media_type
    if params[:media_type] == 'all'
      @posts = model_name.order('updated_at desc').page(params[:page])
    else
      @posts = model_name.where(media_type: params[:media_type]).order('updated_at desc').page(params[:page])
    end
  end

  def by_category
    if params[:category] == 'all'
      @posts = model_name.order('updated_at desc').page(params[:page])
    else
      @posts = model_name.joins(:category).where(categories: {name: params[:category]} ).order('updated_at desc').page(params[:page])
    end
  end

  def by_quick_search
   if params[:query]
     @posts = model_name.by_quick_search(params[:query]).order('updated_at desc')
   end
    @posts ||= model_name.none
    @posts = @posts.page(params[:page])
  end

  def by_complex_search
    if params[:post_search]
      @post_search = PostSearch.new(post_search_params, controller_name)
      @posts = @post_search.search
    else
      @post_search = PostSearch.new
    end
    @posts ||= model_name.none
    @posts = @posts.page(params[:page])
  end

  private

  def set_categories
    @categories = Category.all
  end

  def check_authorization
    raise 'authorization unaccessed' if controller_name == 'posts' and action_name != 'by_quick_search'
  end

  def model_name
    controller_name.classify.constantize
  end

  helper_method :model_name

  def set_post
    @post = model_name.find(params[:id])
  end

  def post_params
    params.require(controller_name.singularize).permit(:title, :content, :tag_list, :category_id)
  end

  def post_search_params
    set_params
    params.require(:post_search).permit(:title, :content, :media_type, :tag, :category_id, :user_id)
  end

  def set_params
    params[:post_search] = current_user.tmp_params.merge!(params[:post_search])
    current_user.tmp_params = params[:post_search]
    current_user.save    
  end
end
