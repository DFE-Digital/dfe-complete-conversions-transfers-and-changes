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

  concern :has_destroy_confirmation do
    get "/delete", action: :confirm_destroy
  end

  resources :projects do
    get "information", to: "project_information#show"

    resources :tasks, only: %i[show update]
    resources :notes, except: %i[show], concerns: :has_destroy_confirmation
    resources :contacts, except: %i[show], concerns: :has_destroy_confirmation
  end
end
