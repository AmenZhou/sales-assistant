class YelpGrabsController < ApplicationController
  before_action :set_yelp, only: [:edit, :update]

  def index
    @yelps = YelpGrab.order(updated_at: :desc).page(params[:page])
    @yelpdata_search = YelpdataSearch.new
  end

  def export_data
    YelpGrab.export
    send_file(Rails.root.join('public', 'yelp.csv'))
  end

  def search
    @yelpdata_search = YelpdataSearch.new(yelpdata_search_params)
    @yelps = @yelpdata_search.results.order(updated_at: :desc).page(params[:page])
    render :index
  end

  def edit
   
  end

  def new
    @yelp = YelpGrab.new
  end

  def create
    @yelp = YelpGrab.new(yelp_params)

    if @yelp.save
      flash[:notice] = t "yelp.created_success"
      redirect_to action: :index
    else
      flash[:alert] = t "yelp.created_failed"
      render :edit
    end
  end

  def update
    if @yelp.update(yelp_params)
      flash[:notice] = t "yelp.updated_success"
      redirect_to action: :index
    else
      flash[:alert] = t "yelp.updated_failed"
      render :edit
    end
  end

  private

  def set_yelp
    @yelp = YelpGrab.find params[:id]
  end

  def yelpdata_search_params
    params.require(:yelpdata_search).permit(:name, :genre, :address, :borough, :zipcode, :city)
  end

  def yelp_params
    params.require(:yelp_grab).permit(:name, :address, :phone_num, :yelp_id, :city, :zipcode, :street, :genre,
                                      :rating, :account_name, :description, :revenue, :employees, :ownership,
                                      :primary_industry, :state, :country, :lead_source, :parent_name, :address_remark,
                                      :remark, :borough, :user_id)
  end
end
