Rails.application.routes.draw do
  post "likes/create/:item_id/:user_id" => "likes#create"
  post "likes/destroy/:item_id/:user_id" => "likes#destroy"

  get "items/index" => "items#index"
  get "items/like" => "items#like"
  get "items/new" => "items#new"
  post "items/create" => "items#create"
  get "items/categorize" => "items#categorize"
  get "items/category/:category" => "items#category"
  get "items/:id/edit" => "items#edit"
  post "items/:id/update" => "items#update"
  get "items/:id/destroy_form" => "items#destroy_form"
  post "items/:id/destroy" => "items#destroy"

  get "users/index" => "users#index"
  get "users/new" => "users#new"
  post "users/create" => "users#create"
  get "users/:id/myitems" => "users#myitems"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  get "users/:id/destroy_form" => "users#destroy_form"
  post "users/:id/destroy" => "users#destroy"

  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "users/:id" => "users#show"
  get "items/:id" => "items#show"

  get "/" => "home#top"
end
