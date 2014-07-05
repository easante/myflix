Myflix::Application.routes.draw do

  root to: "videos#front"

  get "/register", to: "users#new"
  get "/home", to: "videos#index"
  get '/sign_in', to: 'sessions#new', as: 'sign_in'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get "/my_queue", to: "queue_items#index"
  put "/update_user_queue", to: "queue_items#update", as: :update_user_queue
  get "/reset_password", to: "password_resets#new"
  get "/expired_token", to: "password_resets#expired_token"
  get "/invite_friend", to: "invitations#new"
  get "/admin_add_video", to: "admin/videos#new"
  mount StripeEvent::Engine => '/stripe_events'

  resources :categories
  resources :users, only: [:show, :create]
  resources :friendships, only: [:create, :destroy]
  resource :session, only: [:new, :destroy]
  resources :queue_items, only: [:index, :create, :destroy]
  resources :people, only: [:index]
  resources :password_resets, only: [:create, :edit, :update]
  resources :invitations, only: [:create]

  resources :videos, only: [:index,:show] do
    resources :reviews, only: [:create]
    collection do
      post :search, to: 'videos#search'
    end
  end

  namespace :admin do
    root to: "base#index"
    resources :videos, only: [:index, :create]
  end

  get 'ui(/:action)', controller: 'ui'
end
