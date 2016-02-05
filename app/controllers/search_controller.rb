class SearchController < ApplicationController

  def new
    search = Product.search do
      fulltext params[:search_string] do
        boost_fields :title => 2.0
        boost_fields :description => 1.0
      end
      paginate :page => params[:page]
      if !params[:place].nil?
        geocode = Geocoder.search(params[:place])
        order_by_geodist :location, geocode[0].latitude, geocode[0].longitude 
      elsif logged_in?
        order_by_geodist :location, current_user.latitude, current_user.longitude        
      else
        geocode = request.location
        order_by_geodist :location, geocode.latitude, geocode.longitude
      end
      order_by(:created_at, :desc) 
      with :sold, false
    end

    @results = search.results
  end

end
