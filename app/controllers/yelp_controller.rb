class YelpController < ApplicationController
  def index
  	@yelps = YelpGrab.order(updated_at: :desc).page(params[:page])
  end

  def regrab
  	YelpGrabWorker.perform_async('bob', 5)
  	redirect_to action: :index
  end
end
