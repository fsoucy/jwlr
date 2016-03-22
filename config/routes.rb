Rails.application.routes.draw do

  get 'category_options/create'

  get 'attribute_options/create'

  get 'api/get_status'

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
  get 'search_suggestions' => 'search#suggestions'
  # option 'search_suggestions' => 'search#suggestions'
  #post 'signin' => 'api#signin'
  #post 'signup' => 'api#signup'
  #get 'localusers' => 'api#localusers'
  #post 'newstatus' => 'api#newstatus'  
  #get 'users' => 'api#users'

  resources :attribute_options, only: [:create, :destroy]
  resources :category_options, only: [:create, :destroy]

  resources :users do
    member do
      get :edit_description, :user_stores, :noties, :selling, :buying
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

  resources :deals
  resources :payments, only: [:create]  
    
  resources :account_activations, only: [:edit]
  resources :categories
  
  resources :password_resets, only: [:new, :create, :edit, :update]
end
