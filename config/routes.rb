Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }

  get '/users', to: redirect('/users/sign_up')
  root 'home#index'
  resources :books, only: :show
  resources :categories, only: :index
  resources :reviews, only: :create
  resource :cart, only: :show
  resources :coupons, only: :update
  resources :order_items, only: [:create, :update, :destroy]
end
