Rails.application.routes.draw do
  get 'categories/index'
  root 'home#index'
end
