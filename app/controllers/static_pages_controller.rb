class StaticPagesController < ApplicationController
  def home
    @top_products = Product.joins(:productviews).order('productviews.views DESC').limit(8)
    @products = Product.all
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
