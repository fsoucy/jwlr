class StaticPagesController < ApplicationController
  def home
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(8)
    if logged_in?
      searches = current_user.searches.all.sort_by(&:frequency).take(5).map(&:search_text)
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
        end
        results += search.results
      end
      if results.count < 5
        product = current_user.productviews.all.sort_by(&:views).take(1).map(&:product_id)
        unless product.empty?
          search = Sunspot.more_like_this(Product.find(product)) do
            fields :description, :title
            boost_by_relevance true
            paginate :page => 1, :per_page => (5 - results.count)  
          end
          results += search.results
         end
      end

      @for_you = results
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
