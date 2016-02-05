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

    if logged_in?
      saved_search = current_user.searches.find_or_initialize_by(search_text: params[:search_string])
      saved_search.update(updated_at: Time.now)
    end  
  
    @results = search.results
  end

  def suggestions
    search = Search.search do
      fulltext params[:search_string]
      order_by(:score, :desc)
      order_by(:updated_at, :desc)
      paginate :page => 1, :per_page => 5
    end
    
    suggestions = Array.new

    search.results.each do |p|
      suggestions.append p.search_text
    end

    render json: suggestions.to_json, status: 200
  end

end
