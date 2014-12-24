class HomeController < ApplicationController
  def index
    @posts = Post.order('updated_at desc').limit(10)
  end
end
