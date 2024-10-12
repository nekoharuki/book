Rails.application.routes.draw do
  get "items/index" => "items#index"
  get "items/new" => "items#new"
  post "items/create" => "items#create"
  get "items/:id/edit" => "items#edit"
  post "items/:id/update" => "items#update"
  delete "items/:id/destroy" => "items#destroy"


  get "items/:id" => "items#show"
  get "/" => "home#top"
end
