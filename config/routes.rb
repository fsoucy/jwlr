Rails.application.routes.draw do

  get 'api/get_status'

  root 'static_pages#home'
  get 'help' =>  'static_pages#help'
  get 'about' =>  'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'search' => 'search#new'
  get 'search_suggestions' => 'search#suggestions'
  # option 'search_suggestions' => 'search#suggestions'
  #post 'signin' => 'api#signin'
  #post 'signup' => 'api#signup'
  #get 'localusers' => 'api#localusers'
  #post 'newstatus' => 'api#newstatus'  
  #get 'users' => 'api#users'
    

  resources :users do
    member do
      get :selling, :buying, :completed, :edit_description, :user_stores, :noties
    end
  end  

  resources :stores do
    member do
      get :edit_times
	    resources :faqs, only: [:new, :create, :destroy, :edit, :update]
      resources :blogposts, only: [:new, :create, :destroy, :edit, :update]
    end
  end
  resources :completed_deals, only: [:create, :destroy, :show, :update]
  resources :pending_deals, only: [:create, :destroy, :show, :update]
  resources :products, only: [:new, :create, :show, :destroy]
  resources :statuses, only: [:new, :create, :destroy, :show] do
    member do
      get :matches
    end
  end
  resources :account_activations, only: [:edit]
  resources :categories
  
  resources :password_resets, only: [:new, :create, :edit, :update]
end
