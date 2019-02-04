Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }

  get '/users', to: redirect('/users/sign_up')

  root 'pages#home'

  resources :books, only: :index
  resources :categories, only: :show do
    resources :books, only: [:index, :show]
  end

  resources :reviews, only: :create
  resources :coupons, only: :update
  resources :orders, only: :show
  resources :order_items, only: [:create, :update, :destroy]
end
