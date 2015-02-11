class YelpController < ApplicationController
	helper_method :current_job_id, :job_running?
  def index
  	@yelps = YelpGrab.order(updated_at: :desc).page(params[:page])
  end

  def regrab
  	job_id = YelpGrabWorker.perform_async('bob', 5)
  	set_current_job_id job_id
  	redirect_to action: :index
  end

  private

    def current_job_id
   	  $redis.get "current_job_id"
    end
    
    def set_current_job_id job_id
    	$redis.set "current_job_id", job_id
    end

    def job_running? job_id
    	Sidekiq::Status::working? job_id
    end

    def job_complete? job_id
    	Sidekiq::Status::complete? job_id
    end
end
