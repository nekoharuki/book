Rails.application.routes.draw do
  resources :items, param: :id do
    collection do
      get :index, :like, :categorize, :publishers, :authors, :details
      get "category/:category", action: :category, as: :category
      get "publisher/:publisher", action: :publisher, as: :publisher
      get "author/:author", action: :author, as: :author
    end

    member do
      get :edit, :destroy_form, :traded, :trade_items
      post :update, :destroy
    end

    post ":item_requested_id/:item_offered_id/trade", action: :trade, as: :trade
    post ":item_requested_id/:item_offered_id/detail", action: :detail, as: :detail
  end

  resources :users, param: :id do
    member do
      get :edit, :destroy_form, :user_items
      post :update, :destroy
    end
  end

  resources :reviews, only: [] do
    member do
      get :edit
      post :create, :update, :destroy
    end
  end

  resources :likes, only: [] do
    collection do
      post ":item_id/:user_id/create", action: :create, as: :create
      post ":item_id/:user_id/destroy", action: :destroy, as: :destroy
    end
  end

  get "login", to: "users#login_form"
  post "login", to: "users#login"
  post "logout", to: "users#logout"

  get "/about", to: "home#about"
  root "home#top"
end
