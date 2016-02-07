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
      with(:commodity).all_of(params[:commodity]) unless params[:commodity].blank?
      facet :commodity
      facet :price
    end

    if logged_in? && !search.results.empty?
      saved_search = current_user.searches.find_by(search_text: params[:search_string])
      if saved_search.nil?
        current_user.search_relationships.build(search_text: params[:search_string]).save
      else
        usersearch = current_user.search_relationships.find_by(search: saved_search)
        usersearch.frequency += 1
        usersearch.save
      end
    end
    
    @commodities = search.facet(:commodity)
    @results = search.results
  end

  def suggestions
    suggestions = Search.where('lower(search_text) LIKE lower(?)', "#{params[:search_string]}%").joins(:search_relationships).order('search_relationships.frequency DESC').limit(5).pluck(:search_text)   

    render json: suggestions.to_json, status: 200
  end

end
