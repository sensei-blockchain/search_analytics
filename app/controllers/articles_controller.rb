class ArticlesController < ApplicationController
  def search_articles
    # articles related to the query will be returned
    # but as of now we are just recording the search query
    record_search_query
    render json: { status: :ok }
 end

  def record_search_query
    return if only_excluded_word?
    UpsertSearchQueryJob.perform_later(params[:search_query])
  end

  def autocomplete
    render json: matched_search_queries.to_json
  end

  private

  def matched_search_queries
    all_search_queries.map(&:query)
  end

  def all_search_queries
    # SearchQuery.search: Search from Elasticsearch
    # fields: Search specific fields
    # load: To fetch everything from Elasticsearch
    SearchQuery.search(params[:input], fields: [:query], load: false, limit: 5, order: { hits: :desc })
  end

  def only_excluded_word?
    # check search query if it only contain excludes word.
    (params[:search_query].downcase.strip.split(/[^A-Za-z0-9]/i) - ExcludedWord::LIST).blank?
  end
end
