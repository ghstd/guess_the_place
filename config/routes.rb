Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"

  get "/rating" => "pages#rating"
  get "/editor" => "pages#editor"
  post "/editor_create" => "pages#editor_create"

  resources :games, only: [ :index, :show ] do
    collection do
      get :stories
      get :lessons
      post :create_random
      post :create_story
      post :create_video
      post :create_lesson
    end

    member do
      get :lobby
      patch :update_game_phase
      patch :add_player
      patch :player_ready
    end

    resources :chat_messages, only: [ :create ]
  end
end
