Rails.application.routes.draw do
  root 'home#top'
  get 'top0', to: 'home#top0', as: :top
  get 'about', to: 'home#about'
  get 'login', to: 'users#login_form'
  post 'login', to: 'users#login'
  delete 'logout', to: 'users#logout'
  get 'terms_of_service', to: 'users#terms_of_service', as: :terms
  get 'users/:id/likes', to: 'users#likes', as: :like
  get 'posts/:user_id/index', to: 'posts#index'
  post 'likes/:post_id/create', to: 'likes#create'
  delete 'likes/:post_id/destroy', to: 'likes#destroy'

  resources :users do
    member do
      get :following, :followers
    end
    collection do
      get 'search'
    end
  end
  resources :posts do
    resources :comments, only: [:create]
    collection do
      get 'search'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[edit update create new]
  resources :relationships, only: %i[create destroy]
  resources :medicines, only: %i[new create destroy]
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
