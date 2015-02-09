class YelpController < ApplicationController
  def index
  	@yelps = YelpGrab.page(params[:page])
  end
end
