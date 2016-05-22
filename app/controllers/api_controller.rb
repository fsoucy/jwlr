class ApiController < ApplicationController

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

end
