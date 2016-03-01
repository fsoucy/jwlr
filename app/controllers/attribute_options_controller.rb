class AttributeOptionsController < ApplicationController
  def create
    attr = AttributeOption.new(attr_params)
    attr.save
    redirect_to attr.category_option.category
  end

  def destroy
    attr = AttributeOption.find(params[:id])
    cat = attr.category_option.category
    attr.destroy
    redirect_to cat
  end

  private
  def attr_params
    params.require(:attribute_option).permit(:value, :category_option_id)
  end
end
