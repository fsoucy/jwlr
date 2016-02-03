class SearchController < ApplicationController

  def new
    search = Product.search do
      fulltext params[:search_string]
      paginate :page => params[:page]
    end

    @results = search.results
  end

end
