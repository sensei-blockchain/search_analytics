class SearchQuery < ApplicationRecord
  searchkick

  default_scope { order(hits: :desc) }
end
