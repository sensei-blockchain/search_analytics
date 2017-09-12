class UpsertSearchQueryJob < ApplicationJob
  queue_as :default

  def perform(query)
    # Store search query with hits count in db for analytic purpose
    search_query = SearchQuery.find_or_initialize_by(query: query)
    search_query.increment(:hits)
    search_query.save!
  end
end
