class StaticPagesController < ApplicationController

  def home
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(9)
    if logged_in?
      searches = current_user.searches.order('"search_relationships"."frequency" DESC').limit(9).pluck(:search_text)
      results = Array.new
      searches.each do |search_text|
        search = Product.search do
          fulltext search_text do
            query_phrase_slop 3
            boost_fields :title => 2.0
            phrase_fields :title => 2.0
            phrase_slop 1
            boost_fields :description => 1.0
          end
          paginate :page => 1, :per_page => 1
          with :sold, false
          with :hold, false
          with :activated, true
        end
        results += search.results
      end
      if results.count < 9
        product = current_user.productviews.order(views: :desc).limit(1).pluck(:product_id)
        unless product.empty?
          search = Sunspot.more_like_this(Product.find(product.first)) do
            fields :description, :title
            boost_by_relevance true
            paginate :page => 1, :per_page => (9 - results.count)  
            with :sold, false
            with :hold, false
            with :activated, true
          end
          results += search.results
         end
      end
      @for_you = results
      @feed_items = Array.new
      
      page = params[:page].to_i     
      page = 1 if page < 1
      per_page = 15

      notifications = current_user.notifications.order(updated_at: :desc).limit(per_page * page)
      @feed_items += notifications
      
      deals = current_user.buying_deals.order(updated_at: :desc).limit(per_page * page)
      @feed_items += deals

      deals = current_user.selling_deals.order(updated_at: :desc).limit(per_page * page)
      @feed_items += deals      

      blogposts = current_user.blogposts.order(created_at: :desc).limit(per_page * page)
      @feed_items += blogposts

      microposts = current_user.microposts.order(created_at: :desc).limit(per_page * page)
      @feed_items += microposts

      current_user.following.each do |user|
        microposts = user.microposts.order(created_at: :desc).limit(per_page * page)
        @feed_items += microposts

        blogposts = user.blogposts.order(created_at: :desc).limit(per_page * page)
        @feed_items += blogposts
      end

      @feed_items = @feed_items.sort_by(&:updated_at).reverse.paginate(:page => page, :per_page => per_page)
    
      @conversations = Conversation.where("first_user_id = ? OR second_user_id = ?", current_user.id, current_user.id).order(updated_at: :desc)
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
