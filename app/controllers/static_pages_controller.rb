class StaticPagesController < ApplicationController
  def home
    @products = Product.all
  end

  def help
  end

  def about
  end

  def contact
  end
end
