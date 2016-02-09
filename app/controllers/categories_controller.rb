class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:edit, :update, :create, :new, :destroy]  

  def new
    @category = Category.new
  end

  def index
    @categories = Category.all
  end
  
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Created category successfully"
      #redirect_to @category
    #else
      render 'new'
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated"
      redirect_to @category
    else
      render 'edit'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category deleted"
    redirect_to index
  end

  private
    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
end
