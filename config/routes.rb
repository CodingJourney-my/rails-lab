Rails.application.routes.draw do
  root 'articles#index'

  resources :users
  resources :articles
  namespace :user do
    resources :video_views
  end
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
