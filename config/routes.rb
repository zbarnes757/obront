Rails.application.routes.draw do
  root 'sessions#new'

  resources :admin, only: :index
  resources :sessions, only: [:new, :create]
  get "/signout", to: "sessions#destroy", as: :signout
  resources :users, except: :index
  get "/change-status", to: "users#insta_change_status", as: :change_status

end
