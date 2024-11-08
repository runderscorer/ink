Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :games, only: [:create] do
        collection do
          get :search
        end
      end

      patch "/games/:room_code/start", to: "games#start"
      patch "/games/:room_code/next_round", to: "games#next_round"
      patch "/games/:room_code/restart", to: "games#restart"
      patch "/games/:room_code/timer_end", to: "games#timer_end"

      resources :players, only: [:create, :update, :destroy]
      resources :responses, only: [:create]
      resources :votes, only: [:create]
      resources :reactions, only: [:create]
    end
  end
end
