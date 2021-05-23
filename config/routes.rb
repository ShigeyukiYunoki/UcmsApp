Rails.application.routes.draw do

  root "home#top"
  get "about", to: "home#about"
  get "login", to: "users#login_form"
  post "login", to: "users#login"
  delete "logout", to: "users#logout"
  get "posts/:user_id/index", to: "posts#index"

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :users
  resources :account_activations, only:[:edit]
  resources :password_resets, only: [:edit,:update,:create,:new]
  resources :posts
  resources :relationships, only:[:create,:destroy]
  resources :medicines, only:[:index,:new,:create,:destroy]

  # post "posts/:id/destroy", to: "posts#destroy", as: :destroy_post
  # post "posts/:id/update", to: "posts#update"
  # get "posts/:id/edit", to: "posts#edit", as: :edit_post
  # post "posts/:user_id/create", to: "posts#create", as: :posts_path
  # get "posts/:user_id/new", to: "posts#new", as: :new_post
  # get "posts/:id", to: "posts#show", as: :post
  # get "posts/:user_id/index", to: "posts#index", as: :posts_index

  # post "users/:id/update", to: "users#update"
  # get "users/:id/edit", to: "users#edit"
  # post "signup", to: "users#create"
  # get "signup", to: "users#new"
  # get "index", to: "users#index"
  # get "users/:id", to: "users#show"

end
