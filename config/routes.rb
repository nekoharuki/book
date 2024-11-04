Rails.application.routes.draw do
  resources :items, param: :id do
    collection do
      get 'like'
      get 'categorize'
      get 'publishers'
      get 'authors'
      get 'details'
    end
    member do
      get 'category/:category', action: :category, as: :category
      get 'publisher/:publisher', action: :publisher, as: :publisher
      get 'author/:author', action: :author, as: :author
      get 'trade_items'
      get 'traded'
      post 'trade/:item_requested_id/:item_offered_id', action: :trade, as: :trade
      post 'detail/:item_requested_id/:item_offered_id', action: :detail, as: :detail
    end
  end

  resources :users, param: :id do
    member do
      get 'items', action: :user_items, as: :user_items
    end
  end

  resources :reviews, param: :id do
    collection do
      post ':item_id/create', action: :create, as: :create
    end
    member do
      get ':item_id/edit', action: :edit, as: :edit
      post ':item_id/update', action: :update, as: :update
      post ':item_id/destroy', action: :destroy, as: :destroy
    end
  end

  resources :likes, param: :id do
    collection do
      post ':item_id/:user_id/create', action: :create, as: :create
      post ':item_id/:user_id/destroy', action: :destroy, as: :destroy
    end
  end

  get 'login', to: 'users#login_form'
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout'

  get 'about', to: 'home#about'
  root 'home#top'
end
