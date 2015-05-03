class YelpController < ApplicationController
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

  private

  def yelpdata_search_params
    params.require(:yelpdata_search).permit(:name, :genre, :address, :borough, :zipcode, :city)
  end
end
