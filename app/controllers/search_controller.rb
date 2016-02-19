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
      order_by_geodist :location, geocode.latitude, geocode.longitude unless geocode.nil?
    end

    if !params[:price].nil?
      prices = params[:price].split(',')
      prices.each do |price|
        with :price, Range.new(price.split("..").first, price.split("..").last)
      end
    end

    if !params[:category_id].nil?
      with :category_id, params[:category_id]
    end

    if !params[:attribute_option_id].nil?
      ids = params[:attribute_option_id].split(',')
      with :attribute_option_id, ids
    end

    with :sold, false
    facet :category_id
    facet :price, :range => 0..100000, :range_interval => 100 
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

    @prices = search.facet(:price)
    @categories = search.facet(:category_id)
    @results = search.results
    @category = params[:category_id]
  end

  def suggestions
    suggestions = Search.where('lower(search_text) LIKE lower(?)', "#{params[:search_string]}%").joins(:search_relationships).order('search_relationships.frequency DESC').limit(5).pluck(:search_text)   
    render json: suggestions.to_json, status: 200
  end

end
