class SearchQueriesController < ApplicationController
  def index
    @search_queries = SearchQuery.all.page(params[:page]).per(10)
  end

  def reset_all_search_queries_hits
    SearchQuery.update_all hits: 0
    handle_reset_hits_response
  end

  def reset_search_query_hits
    search_query = SearchQuery.find(params[:id])
    search_query.update hits: 0
    handle_reset_hits_response
  end

  private

  def handle_reset_hits_response
    respond_to do |format|
      format.js { render json: { status: :ok } }
      format.html { redirect_to search_queries_path }
    end
  end
end
