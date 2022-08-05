Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "projects#index"

  # Sign in
  get "/sign-in", to: "sessions#new"
  # Sign out
  get "/sign-out", to: "sessions#delete"
  # Sign in fails
  get "auth/failure", to: "sessions#failure"

  # Omniauth callbacks
  get "auth/:provider/callback", to: "sessions#create"

  resources :projects do
    resources :tasks
    resources :notes
  end

  get "/projects/:id/information", to: "project_information#show", as: :project_information
end
