class CategoriesController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :create, :new, :destroy, :edit_attributes]  

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
      for i in 1..@category.no_of_options.to_i
        @category.category_options.new.save  
      end
      redirect_to edit_category_path(@category)
    else
      render 'new'
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      CategoryOption.update(params[:category_options].keys, params[:category_options].values) unless params[:category_options].nil?
      AttributeOption.update(params[:attribute_options].keys, params[:attribute_options].values) unless params[:attribute_options].nil?
      @category.no_of_options = @category.category_options.count
      @category.category_options.each do |opt|
        opt.no_of_options = opt.attribute_options.count
        if opt.no_of_options.to_i < params[:category_options][opt.id.to_s][:no_of_options].to_i
          for i in opt.no_of_options.to_i..params[:category_options][opt.id.to_s][:no_of_options].to_i - 1
            opt.attribute_options.new.save
          end
        end
        if params[:category_options][opt.id.to_s][:_delete] == "1"
          opt.delete
        end
      end
      if !params[:attribute_options].nil?
        params[:attribute_options].each do |attr|
          if attr[1]["_delete"] == "1"
            AttributeOption.destroy(attr[0])
          end
        end
      end
      if @category.no_of_options.to_i < params[:category][:no_of_options].to_i
        for i in @category.no_of_options.to_i..params[:category][:no_of_options].to_i - 1
          @category.category_options.new.save
        end
      end
      flash[:success] = "Category updated"
      redirect_to edit_category_path(params[:id])
    else
      render 'edit'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @category.no_of_options = @category.category_options.count
    @category.category_options.each do |opt|
      opt.no_of_options = opt.attribute_options.count
    end
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
      params.require(:category).permit(:name, :parent_id, :no_of_options)
    end
end
