class StaticPagesController < ApplicationController

  def activities_index
    if logged_in?
      all_activities = []
      all_activities += current_user.selling_deals.order(updated_at: :desc).where(deal_complete: false)
      all_activities += current_user.buying_deals.order(updated_at: :desc).where(deal_complete: false)
      action_needed = []
      not_action_needed = []
      all_activities.each do |activity|
        if (current_user?(activity.seller) and activity.status(true)[1]) or (current_user?(activity.buyer) and activity.status(false)[1])
          action_needed.append(activity)
        else
          not_action_needed.append(activity)
        end
      end
      @activities = action_needed + not_action_needed
    end
  end
  
  def home
    if logged_in?
      all_activities = []
      all_activities += current_user.selling_deals.order(updated_at: :desc).where(deal_complete: false)
      all_activities += current_user.buying_deals.order(updated_at: :desc).where(deal_complete: false)
      action_needed = []
      not_action_needed = []
      all_activities.each do |activity|
        if (current_user?(activity.seller) and activity.status(true)[1]) or (current_user?(activity.buyer) and activity.status(false)[1])
          action_needed.append(activity)
        else
          not_action_needed.append(activity)
        end
      end
      @activities = action_needed + not_action_needed

      @notifications = current_user.notifications.order(updated_at: :desc)
      if @notifications.count > 4
        @notifications = @notifications[0...4]
      end

      @note = current_user.notifications.last
    end
    
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(9)
    if logged_in?
      searches = current_user.searches.order('`search_relationships`.`frequency` DESC').limit(3).pluck(:search_text)
      results = Array.new
      searches.each do |search_text|
        search = Product.search do
          fulltext search_text do
            query_phrase_slop 1
            boost_fields :title => 2.0
            phrase_fields :title => 2.0
            phrase_slop 1
            boost_fields :description => 1.0
          end
          paginate :page => 1, :per_page => 3
          with :sold, false
          with :hold, false
          with :activated, true
          with :confirmed, true
        end
        results += search.results
        results = results.uniq
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
            with :confirmed, true
          end
          results += search.results
         end
      end
      @for_you = results
      @feed_items = Array.new

      page = params[:page].to_i     
      page = 1 if page < 1
      per_page = 15

      _user = nil

      if !params[:user].present? or params[:user].to_i == 0
        _user = current_user
        deals = _user.buying_deals.order(updated_at: :desc).limit(per_page * page)
        @feed_items += deals

        deals = _user.selling_deals.order(updated_at: :desc).limit(per_page * page)
        @feed_items += deals
      else
        _user = User.find(params[:user].to_i)
      end

      blogposts = _user.blogposts.order(created_at: :desc).limit(per_page * page)
      @feed_items += blogposts

      microposts = _user.microposts.order(created_at: :desc).limit(per_page * page)
      @feed_items += microposts

      shares = _user.shares.order(created_at: :desc).limit(per_page * page)
      @feed_items += shares

      products = _user.products.where(activated: true).order(created_at: :desc).limit(per_page * page)
      @feed_items += products

      if !params[:user].present? or params[:user].to_i == 0
        current_user.following.each do |user|
          microposts = user.microposts.order(created_at: :desc).limit(per_page * page)
          @feed_items += microposts

          blogposts = user.blogposts.order(created_at: :desc).limit(per_page * page)
          @feed_items += blogposts

          shares = user.shares.order(created_at: :desc).limit(per_page * page)
          @feed_items += shares

          products = user.products.where(activated: true).order(created_at: :desc).limit(per_page * page)
          @feed_items += products
        end
      end

      @feed_items = @feed_items.sort_by(&:updated_at).reverse.paginate(:page => page, :per_page => per_page)

      if @feed_items.length < 5 and page == 1
        search = User.search do
        order_by_geodist :location, current_user.latitude, current_user.longitude
        with :activated, true
        paginate :page => 1, :per_page => 10
        end

        @recommended_users = search.results.map{|e| {id: e.id, name: e.name, profile_picture: e.profile_picture(:thumbnail), following: current_user.following?(e)}}
      end

      conversations_group = Array.new
      current_user.groups.each do |group|
        conversations_group.append(group.conversations.first)
      end
      conversations_normal = Conversation.where('second_user_id = ? OR first_user_id = ?', current_user.id, current_user.id).order(updated_at: :desc).all
      @conversations = conversations_group + conversations_normal
      @conversations = @conversations.sort_by{ |convo| -convo.updated_at.to_time.to_i }
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
        @for_you.append(product) unless !product.activated || product.sold || product.hold || !product.confirmed
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
        @featured.append(product) unless !product.activated || product.sold || product.hold || !product.confirmed
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
