Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations' }

  root 'home#index'
  resources :books, only: :show
  resources :categories, only: :index
  resources :reviews, only: :create
  get '/users', to: redirect('/users/sign_up')
end
