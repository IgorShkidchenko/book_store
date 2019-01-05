Rails.application.routes.draw do
  get 'book/show'
  get 'categories/index'
  root 'home#index'
end
