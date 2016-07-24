class ApiController < ApplicationController

  require 'action_view'
  require 'action_view/helpers'
  include ActionView::Helpers::DateHelper

  def getUsers
    search = User.search do
      fulltext params[:search_string] do
        boost_fields :name => 3.0
      end
      with :activated, true
      paginate :page => 1, :per_page => 10
      order_by(:score, :desc)
      order_by_geodist :location, current_user.latitude, current_user.longitude
    end
    
    result = search.results.map{|e| {id: e.id, name: e.name, profile_picture: e.profile_picture(:thumbnail), following: current_user.following?(e)}}
    render json: result.to_json, status: 200
  end

  def getUnreadNotifications
    user = User.find_by(id: params[:user_id])
    notifications = current_user.notifications.where(read: false).order(created_at: :desc)
    result = notifications.map{ |n| {id: n.id, message: n.message, url: n.url, time_ago: time_ago_in_words(n.created_at), updated_at: n.updated_at}}
    render json: result.to_json, status: 200
  end

  def isStreetAddress
    location = Geocoder.search params[:dropoff]
    returning = Array.new
    values = {}
    if location[0].nil? || location[0].street_address.nil? || location[0].street_address == ""
      values["valid"] = 0
    else
      values["valid"] = 1
    end
    returning.append(values)
    
    render json: returning.to_json, status: 200
  end
  
  def getChildrenCategories
    category = Category.find_by_id(params[:id])
    if !category.nil?
      returning = Array.new
      categories = category.children
      categories.each do |cat|
        values = {}
        values["name"] = cat.name
        values["id"] = cat.id
        if cat.children.count == 0
          values["children"] = 0
        else
          values["children"] = 1
        end
        returning.append(values)
      end
      render json: returning.to_json, status: 200
    else
      render json: nil, status: 400
    end
  end
  
  def getToggleOptions
    category = Category.find_by_id(params[:id])
    if !category.nil?
      returning = Array.new
      toggle_options = category.category_options
      toggle_options.each do |option|
        values = {}
        values["name"] = option.name
        values["id"] = option.id
        values["attribute_options"] = Array.new
        option.attribute_options.pluck(:id, :value).each do |attr|
          values["attribute_options"].append(attr)
        end
        returning.append(values)
      end

      render json: returning.to_json, status: 200
    else
      render json: nil, status: 400
    end
  end

  def getMicropost
    micropost = Micropost.find_by_id(params[:id])
    if !micropost.nil?
      returning = {}
      returning["content"] = micropost.content
      returning["user"] = micropost.user.name

      render json: returning.to_json, status: 200
    else
      render json: nil, status: 400
    end
  end

  def getLikes
    post = Like.new(post_id: params[:post_id], post_type: params[:post_type]).post
    if !post.nil?
      returning = Array.new
      post.likes.each do |like|
        values = {}
        values["name"] = like.user.name
        values["id"] = like.user.id
        values["profile_picture"] = like.user.profile_picture(:thumbnail)
        returning.append(values)
      end

      render json: returning.to_json, status: 200
    else
      render json: nil, status: 400
    end
  end

end
