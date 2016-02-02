class StaticPagesController < ApplicationController
  def home
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(8)
    @products = Product.all
  end

  def help
  end

  def about
  end

  def contact
  end
end
