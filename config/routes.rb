Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }

  get '/users', to: redirect('/users/sign_up')
  root 'pages#home'

  resources :books, only: %i[index show]
  scope '/categories/:category_id', as: 'category' do
    resources :books, only: :index
  end

  resources :reviews, only: :create
  resources :coupons, only: :update
  resources :addresses, only: %i[create update]
  resources :checkout_steps, only: %i[show update]

  resources :order_items, only: %i[create update destroy]
  resources :orders, only: :show do
    resources :order_items, only: :index
  end

  resources :users do
    resources :orders, only: :index
  end
end
