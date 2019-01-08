Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :books, only: :show
  resources :categories, only: :index
end
