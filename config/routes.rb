Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :games, only: [:create]
    end
  end
end
