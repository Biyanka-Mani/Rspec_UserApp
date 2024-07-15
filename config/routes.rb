Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/show'
  get 'categories/create'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :articles do
    resource :like, only: [:create, :destroy]
    collection do
      get 'filter'
      get 'article_verification'
      # post '/articles/approve/:id', to: 'articles#approve', as: 'approve_article'
    end 
    member do
      post 'approve', to: 'articles#approve', as: 'approve'
    end
   
  end
  resources :articles 
  resources :users
  resources :categories
  resources :tags
 
  root 'home#welcome'

  #  root to: "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
 
  # Defines the root path route ("/")
  # root "posts#index"
end
