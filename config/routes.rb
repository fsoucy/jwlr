Rails.application.routes.draw do

  root 'static_pages#home'
  get 'help' =>  'static_pages#help'
  get 'about' =>  'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users
  resources :products, only: [:new, :create, :show, :destroy]
  resources :statuses, only: [:new, :create, :destroy, :show] do
    member do
      get 'matches' => 'statuses#matches'
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
