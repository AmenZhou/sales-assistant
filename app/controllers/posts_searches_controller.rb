class PostsSearchesController < ApplicationController
  def by_tag
    @posts = Post.tagged_with(params[:tag]) if params[:tag]
  end

  def by_username
  end

  def by_media_type
  end
end
