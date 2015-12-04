Rails.application.routes.draw do
  root 'sessions#new'

  resources :admin, only: :index
  resources :sessions, only: [:new, :create]
  get "/signout", to: "sessions#destroy", as: :signout
  resources :users, except: :index

end
