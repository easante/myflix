Myflix::Application.routes.draw do

  root to: "videos#front"

  get "/register", to: "users#new"
  get "/home", to: "videos#index"
  get '/sign_in', to: 'sessions#new', as: 'sign_in'
  post '/sign_in', to: 'sessions#create'
  get "/my_queue", to: "queue_items#index"

  resources :categories
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :destroy]
  resources :queue_items, only: [:index, :create, :destroy]

  resources :videos, only: [:index,:show] do
    resources :reviews, only: [:create]
    collection do
      post :search, to: 'videos#search'
    end
  end
  get 'ui(/:action)', controller: 'ui'
end
