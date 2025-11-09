Rails.application.routes.draw do
  get "dogs/index"
  get "pages/about"
  # get "breeds/index"
  # get "breeds/show"

  # Set the root page
  root "breeds#index"

  # RESTful routes for breeds (only index and show)
  resources :breeds, only: [ :index, :show ]

  # RESTful routes for dogs (only index and show)
  resources :dogs, only: [ :index, :show ]

  resources :owners


  # Static about page
  get "/about", to: "pages#about"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
  get "/up", to: "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
