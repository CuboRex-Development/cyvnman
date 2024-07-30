Rails.application.routes.draw do
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
    resources :versions, only: [:new, :create]
  end
  resources :versions do
    member do
      get 'download'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
