class SearchController < ApplicationController

  def new
    search = Product.search do
      fulltext params[:search_string] do
        boost_fields :title => 2.0
        boost_fields :description => 1.0
      end
      paginate :page => params[:page]
      order_by(:created_at, :desc) 
      with :sold, false
    end

    @results = search.results
  end

end
