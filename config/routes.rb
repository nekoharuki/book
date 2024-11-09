Rails.application.routes.draw do
  resources :items, param: :id do
    collection do
      get 'like', to: 'items#like'
      get 'categorize', to: 'items#categorize'
      get 'publishers', to: 'items#publishers'
      get 'authors', to: 'items#authors'
      get 'details', to: 'items#details'

      get 'category/:category', to: 'items#category'
      get 'publisher/:publisher', to: 'items#publisher'
      get 'author/:author', to: 'items#author'
    end
    member do
      get 'trade_items', to: 'items#trade_items'
      get 'destroy_form', to: 'items#destroy_form'
      get 'traded', to: 'items#traded'
    end
  end

  post 'items/:item_requested_id/:item_offered_id/trade', to: 'items#trade'
  post 'items/:item_requested_id/:item_offered_id/detail', to: 'items#detail'

  resources :users, param: :id do
    collection do
      get 'users/new', to: 'users#new'
      post 'users/create', to: 'users#create'
    end
    member do
      get 'items', to: 'users#user_items'
      get 'destroy_form', to: 'users#destroy_form'
    end
  end

  post 'likes/:item_id/:user_id/create', to: 'likes#create'
  post 'likes/:item_id/:user_id/destroy', to: 'likes#destroy'

  resources :reviews, only: [:create, :edit, :update, :destroy], param: :id do
    collection do
      post ':item_id/create', to: 'reviews#create'
    end
    member do
      get ':item_id/edit', to: 'reviews#edit'
      post ':item_id/update', to: 'reviews#update'
      post ':item_id/destroy', to: 'reviews#destroy'
    end
  end

  get 'login', to: 'users#login_form'
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout'

  get '/about', to: 'home#about'
  root 'home#top'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

end
