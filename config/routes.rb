Rails.application.routes.draw do
  root 'home#index'
  get 'books/show', as: 'book'
  get 'categories/index', as: 'shop'
end
