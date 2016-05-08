class StaticPagesController < ApplicationController

  def home
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(15)
    if logged_in?
      #searches = current_user.searches.all.sort_by(&:frequency).take(5).map(&:search_text)
      #results = Array.new
      #searches.each do |search_text|
      #  search = Product.search do
      #    fulltext search_text do
      #      query_phrase_slop 3
      #      boost_fields :title => 2.0
      #      phrase_fields :title => 2.0
      #      phrase_slop 1
      #      boost_fields :description => 1.0
      #    end
      #    paginate :page => 1, :per_page => 1
      #    with :sold, false
      #    with :hold, false
      #    with :activated, true
      #  end
      #  results += search.results
      #end
      #if results.count < 5
      #  product = current_user.productviews.all.sort_by(&:views).take(1).map(&:product_id)
      #  unless product.empty?
      #    search = Sunspot.more_like_this(Product.find(product.first)) do
      #      fields :description, :title
      #      boost_by_relevance true
      #      paginate :page => 1, :per_page => (5 - results.count)  
      #      with :sold, false
      #      with :hold, false
      #      with :activated, true
      #    end
      #    results += search.results
      #   end
      #end
      #@for_you = results
      @feed_items = Array.new
      
      notifications = current_user.notifications.order(updated_at: :desc).limit(50)
      @feed_items += notifications
      
      deals = current_user.buying_deals.order(updated_at: :desc).limit(50)
      @feed_items += deals

      deals = current_user.selling_deals.order(updated_at: :desc).limit(50)
      @feed_items += deals      

      blogposts = current_user.blogposts.order(created_at: :desc).limit(50)
      @feed_items += blogposts

      @feed_items = @feed_items.sort_by(&:updated_at).reverse
    end
    @for_you = [] if @for_you.nil?
    @featured = [] if @featured.nil?
    index = 0
    while (@for_you.count < 5 and Product.count > @for_you.count and index < 20)
      product = nil
      while product.nil? and index < 20
        product = Product.find_by(id: index)
        index += 1
      end
      if !product.nil?
        @for_you.append(product) unless !product.activated || product.sold || product.hold
      end
    end
    
    index = 0
    while (@featured.count < 15 and Product.count > @featured.count and index < 20)
      product = nil
      while product.nil? and index < 20
        product = Product.find_by(id: index)
        index += 1
      end
      if !product.nil?
        @featured.append(product) unless !product.activated || product.sold || product.hold
      end
    end
    
  end

  def help
  end

  def about
  end

  def contact
  end
end
