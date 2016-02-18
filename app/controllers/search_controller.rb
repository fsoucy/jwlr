class SearchController < ApplicationController

  def new
    @params = params
    search = Product.search do
      fulltext params[:search_string] do
        boost_fields :title => 2.0
        boost_fields :description => 1.0
      end
    paginate :page => params[:page]
    case params[:sort_by]
      when "low"
        order_by(:price, :asc)
      when "high"
        order_by(:price, :desc)
      else
        order_by(:score, :desc)
    end

    if !params[:place].nil?
      geocode = Geocoder.search(params[:place])
      order_by_geodist :location, geocode[0].latitude, geocode[0].longitude 
    elsif logged_in?
      order_by_geodist :location, current_user.latitude, current_user.longitude        
    else
      geocode = request.location
      order_by_geodist :location, geocode.latitude, geocode.longitude
    end

    if !params[:price].nil?
      prices = params[:price].split(',')
      prices.each do |price|
        with :price, Range.new(price.split("..").first, price.split("..").last)
      end
    end

    if !params[:category_id].nil?
      ids = params[:category_id].split(',')
      ids.each do |id|
        with :category_id, id
      end
    end

    with :sold, false
    facet :category_id
    facet :attribute_option_id, :zeros => true
    facet :price, :range => 0..100000, :range_interval => 100
  
    adjust_solr_params do |params|
      params[:"f.attribute_option_id_i.facet.domain.blockChildren"] = "type_s:ToggleOption"
    end
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

    @attribute_options = search.facet(:attribute_option_id)
    @prices = search.facet(:price)
    @categories = search.facet(:category_id)
    @results = search.results
    @search = search
  end

  def suggestions
    suggestions = Search.where('lower(search_text) LIKE lower(?)', "#{params[:search_string]}%").joins(:search_relationships).order('search_relationships.frequency DESC').limit(5).pluck(:search_text)   
    render json: suggestions.to_json, status: 200
  end

end
