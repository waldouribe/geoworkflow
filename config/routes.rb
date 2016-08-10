Rails.application.routes.draw do
  root to: "my_processes#new"
  get 'landing/index'

  devise_for :users

  resources :users
  resources :messages
  resources :waitings
  resources :tasks
  resources :my_processes
  resources :process_types

  # Omiauth for twitter
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  # get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'


  # Tests routes, can be deleted 
  get '/test', to: 'tests#index'
end
