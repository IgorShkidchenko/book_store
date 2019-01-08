Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get 'books/show', as: 'book'
  get 'categories/index', as: 'shop'
end
