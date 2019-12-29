# frozen_string_literal: true

# For details on the DSL available within this file,
# see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root "static_pages#home"

  get "help", to: "static_pages#help"

  # This page url will be /about_us.
  # And the url helper generated about_path and about_url
  get "about_us", to: "static_pages#about", as: :about
  get "contact", to: "static_pages#contact"

  get "signup", to: "users#new"
  # post "signup", to: "users#create"

  resources :users
end
