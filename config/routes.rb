Rails.application.routes.draw do

  get 'category_options/create'

  get 'attribute_options/create'
  
  #api
  get 'api/getToggleOptions'
  get 'api/getMicropost'
  get 'api/isStreetAddress'
  
  root 'static_pages#home'
  get 'help' =>  'static_pages#help'
  get 'about' =>  'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'logout' => 'sessions#destroy'
  get 'search' => 'search#new'
  get 'test' => 'products#test'
  get 'search_suggestions' => 'search#suggestions'

  get 'conversations/conversations_index'

  resources :conversations do
    member do
      get :pull_messages
    end
  end

  resources :messages
  resources :attribute_options, only: [:create, :destroy]
  resources :category_options, only: [:create, :destroy]
  resources :bugs, only: [:new, :create, :destroy, :update, :index]

  resources :users do
    member do
      get :edit_description, :user_stores, :selling, :buying, :edit_default_preferences
      post :follow, :like
      get 'reviews' => 'reviews#index'
      resources :notifications, only: [:update, :index] 
    end
  end  

  resources :blogposts, only: [:new, :create, :destroy, :edit, :update]

  resources :stores do
    member do
      get :edit_times
	    resources :faqs, only: [:new, :create, :destroy, :edit, :update]
    end
  end

  resources :products, only: [:new, :create, :show, :destroy, :edit, :update] do
    member do
      get :edit_toggle_options, :edit_exchange_methods, :edit_payment_methods, :edit_selling_methods
      resources :pictures do
        member do
          post :add_cropped
        end
      end
    end
  end

  resources :deals do
    member do
      resources :reviews, only: [:new, :create]
    end
  end
  resources :payments, only: [:create]  
  
  resources :microposts, only: [:create, :update, :destroy]
  
  resources :account_activations, only: [:edit]
  resources :categories
  
  resources :password_resets, only: [:new, :create, :edit, :update]
end
