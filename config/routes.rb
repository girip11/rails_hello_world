# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :microposts
  resources :users

  # root "application#hello_world"
  root "users#index"
end
