Rails.application.routes.draw do

  get "items/index" => "items#index"
  get "items/new" => "items#new"
  post "items/create" => "items#create"
  get "items/:id/edit" => "items#edit"
  post "items/:id/update" => "items#update"
  get "items/:id/destroy" => "items#destroy"

  get "users/index" => "users#index"
  get "users/new" => "users#new"
  post "users/create" => "users#create"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  get "users/:id/destroy" => "users#destroy"

  get "login" => "users#login_form"
  post "login" => "users#login"
  get "logout" => "users#logout"

  get "users/:id" => "users#show"
  get "items/:id" => "items#show"

  get "/" => "home#top"
end
