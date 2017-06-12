Rails.application.routes.draw do
  root to: "landing#index"
  get 'landing/index'

  devise_for :users

  resources :users
  resources :messages
  resources :waitings
  resources :tasks do
    member do
      get :begin
      get :finish
    end
  end
  resources :my_processes do 
    member do 
      get :success
      get :new_tasks
      patch :create_tasks
    end
  end
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
