Rails.application.routes.draw do

  post "likes/:item_id/:user_id/create" => "likes#create"
  post "likes/:item_id/:user_id/destroy" => "likes#destroy"

  post "reviews/:item_id/create" => "reviews#create"
  get "reviews/:item_id/:id/edit" => "reviews#edit"
  post "reviews/:item_id/:id/update" => "reviews#update"
  post "reviews/:item_id/:id/destroy" => "reviews#destroy"

  get "items/index" => "items#index"
  get "items/like" => "items#like"
  get "items/new" => "items#new"
  post "items/create" => "items#create"
  get "items/categorize" => "items#categorize"
  get "items/publishers" => "items#publishers"

  get "items/details" => "items#details"

  get "items/category/:category" => "items#category"

  get "items/publisher/:publisher" => "items#publisher"

  get "items/:item_id/trade_items" => "items#trade_items"

  get "items/:id/edit" => "items#edit"
  post "items/:id/update" => "items#update"
  get "items/:id/destroy" => "items#destroy_form"
  post "items/:id/destroy" => "items#destroy"

  get "items/:id/traded" => "items#traded"

  post "items/:item_requested_id/:item_offered_id/trade" => "items#trade"
  post "items/:item_requested_id/:item_offered_id/detail" => "items#detail"


  get "users/index" => "users#index"
  get "users/new" => "users#new"
  post "users/create" => "users#create"
  get "users/:id/items" => "users#user_items"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  get "users/:id/destroy" => "users#destroy_form"
  post "users/:id/destroy" => "users#destroy"

  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "users/:id" => "users#show"
  get "items/:id" => "items#show"

  get "/about" => "home#about"
  get "/" => "home#top"
end
