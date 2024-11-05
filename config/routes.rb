Rails.application.routes.draw do
  resources :items do
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

  resources :users do
    collection do
      get 'login', to: 'users#login_form'
      post 'login', to: 'users#login'
      post 'logout', to: 'users#logout'
      get 'signup', to: 'users#new'
    end
    member do
      get 'items', to: 'users#user_items'
      get 'destroy_form', to: 'users#destroy_form'
    end
  end
  get '/about', to: 'home#about'
  get '/', to: 'home#top'
end
