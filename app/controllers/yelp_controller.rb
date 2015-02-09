class YelpController < ApplicationController
  def index
  	@yelps = YelpGrab.order(updated_at: :desc).page(params[:page])
  end

  def regrab
  	YelpGrab.grab
  	redirect_to action: :index
  end
end
