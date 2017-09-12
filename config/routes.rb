Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  resources :search_queries, only: [:index] do
    collection do
      put :reset_all_search_queries_hits
    end
    member do
      put :reset_search_query_hits
    end
  end

  resources :articles, only: [:index] do
    collection do
      get :search_articles
      get :autocomplete
    end
  end

  root to: 'articles#index'
end
