class SearchController < ApplicationController

  def new
    @params = params
    search = Product.search do
      fulltext params[:search_string] do
        query_phrase_slop 3
        boost_fields :title => 2.0
        phrase_fields :title => 2.0
        phrase_slop 1
        boost_fields :description => 1.0
      end
    paginate :page => params[:page]
    with :sold, false
    with :hold, false
    with :activated, true
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
    
      if !params[:price_lower].nil? || !params[:price_upper].nil?
        with(:price).between(Range.new(params[:price_lower].to_i, params[:price_upper].to_i))
      end

      if !params[:category_id].nil?
        categories = params[:category_id].split(',')
        category = with :category_id, categories
      end

      if !params[:attribute_option_id].nil?
        ids = params[:attribute_option_id].split(',')
        with(:attribute_option_id).all_of(ids)
      end

      if !params[:selling_method_id].nil?
        methods = params[:selling_method_id].split(',')
        with(:selling_method_id).any_of(methods)
      end

      if !params[:exchange_method_id].nil?
        methods = params[:exchange_method_id].split(',')
        with(:exchange_method_id).any_of(methods)
      end

      if !params[:payment_method_id].nil?
        methods = params[:payment_method_id].split(',')
        with(:payment_method_id).any_of(methods)
      end

      facet :category_id, :exclude => category
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
  
    @params = params
    @categories = search.facet(:category_id)
    @results = search.results
    @selling_methods = SellingMethod.all
    @payment_methods = PaymentMethod.all
    @exchange_methods = ExchangeMethod.all
    if !params[:category_id].nil?
      category_options = Array.new
      params[:category_id].split(',').each do |cat|
        Category.find(cat).category_options.each do |category_option|
          category_options.append(category_option)
        end
      end
      @category_options = category_options.uniq
    end
  end

  def suggestions
    suggestions = Search.where('lower(search_text) LIKE lower(?)', "#{params[:search_string]}%").joins(:search_relationships).order('search_relationships.frequency DESC').limit(5).pluck(:search_text)   
    render json: suggestions.to_json, status: 200
  end

end
