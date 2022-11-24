Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "projects#index"

  # Errors
  match "/404" => "pages#page_not_found", :via => :all
  match "/500" => "pages#internal_server_error", :via => :all

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

  scope :projects do
    namespace :conversion do
      namespace :involuntary do
        get "new", to: "projects#new"
        post "new", to: "projects#create"
      end
    end
  end

  resources :projects, only: %i[index show new create] do
    collection do
      get "completed"
    end
    get "information", to: "project_information#show"

    put "complete", to: "projects_complete#complete"

    resources :tasks, only: %i[show update]
    resources :notes, except: %i[show], concerns: :has_destroy_confirmation
    resources :contacts, except: %i[show], concerns: :has_destroy_confirmation

    namespace :assign, controller: "/assignments" do
      get "team-lead", action: :assign_team_leader
      post "team-lead", action: :update_team_leader
      get "regional-delivery-officer", action: :assign_regional_delivery_officer
      post "regional-delivery-officer", action: :update_regional_delivery_officer
      get "caseworker", action: :assign_caseworker
      post "caseworker", action: :update_caseworker
    end
  end

  # High voltage configuration for static pages. Matches routes from the root of the domain. Uses
  # HighVoltage::Constraints::RootRoute to validate that the view exists.
  get "/*id" => "pages#show", :as => :page, :format => false, :constraints => HighVoltage::Constraints::RootRoute.new
end
