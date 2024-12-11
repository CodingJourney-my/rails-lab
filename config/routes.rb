Rails.application.routes.draw do
  root 'articles#index'

  namespace :api do
    resources :users, only: [:index, :show]
  end

  resources :users
  resources :articles
  resources :basic_auth, only: [:index]
  resources :redirect_back, only: [:index]
  namespace :user do
    resources :video_views
  end
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get "/docs/api", to: "docs#index", filename: "api"

  get  '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
