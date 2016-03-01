class CategoryOptionsController < ApplicationController
  def create
    opt = CategoryOption.new(opt_params)
    opt.save
    redirect_to opt.category
  end

  def destroy
    opt = Category.find(params[:id])
    cat = opt.category
    opt.destroy
    redirect_to cat
  end

  private
  def opt_params
    params.require(:category_option).permit(:category_id, :name, :required)
  end
end
