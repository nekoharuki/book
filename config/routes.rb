Rails.application.routes.draw do
  resources :items, param: :id do
    collection do
      get 'like', to: 'items#like'
      get 'search', to: 'items#search'
      get 'details', to: 'items#details'

      get 'category/:category', to: 'items#category'
      get 'publisher/:publisher', to: 'items#publisher'
      get 'author/:author', to: 'items#author'
      get 'title_results/:title_name', to: 'items#title_results'
      post 'title_search', to: 'items#title_search'
    end
    member do
      get 'trade_items', to: 'items#trade_items'
      get 'traded', to: 'items#traded'
    end
  end

  get "/items/delivery/:number/:myitem/:youitem", to: "items#delivery"
  post '/items/delivery_success/:number/:myitem_id/:youitem_id', to: 'items#delivery_success'

  get "/items/title_results/:title_name", to: "items#title_results"

  post 'items/:item_requested_id/:item_offered_id/trade', to: 'items#trade'
  post 'items/:item_requested_id/:item_offered_id/detail', to: 'items#detail'

  resources :users, param: :id do
    collection do
      get 'follows', to: 'users#follows'
      get 'new', to: 'users#new'
      post 'create', to: 'users#create'
    end
    member do
      post 'password_change', to: 'users#password_change'
      get 'password_form', to: 'users#password_form'
      get 'items', to: 'users#user_items'
      post 'follows_create', to: 'users#follows_create'
      post 'follows_destroy', to: 'users#follows_destroy'
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
