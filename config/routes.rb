Rails.application.routes.draw do
  get 'oauths/oauth'
  get 'oauths/callback'
  root to: 'static_pages#home'
  resources :charts
  get 'levels', to: 'charts#levels'
  get 'ran_levels', to: 'charts#ran_levels'
  get 's_ran_levels', to: 'charts#s_ran_levels'
  resources :users
  namespace :admin do
    get 'login', to: 'user_sessions#new', as: :login
    post 'login', to: 'user_sessions#create'
    post 'logout', to: 'user_sessions#destroy', as: :logout
    resources :information
    resources :musics do
      collection { post :csv_import }
    end
    resources :charts
  end
  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: 'user_sessions#create'
  post 'logout', to: 'user_sessions#destroy', as: :logout
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
