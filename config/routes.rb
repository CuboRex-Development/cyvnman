Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :types
  resources :models do
    member do
      post 'add_block'
      delete 'remove_block'
    end
  end
  resources :blocks do
    member do
      post 'add_part'
      delete 'remove_part'
    end
    resources :parts, only: [:new, :create]
  end
  resources :parts do
    member do
      post 'add_related_part'
      delete 'remove_related_part'
    end
    resources :versions, only: [:new, :create]
  end
  resources :versions do
    member do
      get 'download'
    end
  end
  resources :versions do
    member do
      patch :check
      patch :approve
    end
  end
  resources :comparisons, only: [:index] do
    collection do
      get 'compare'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
