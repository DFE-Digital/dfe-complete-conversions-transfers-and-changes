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

  concern :task_listable do
    get "task-list", to: "task_lists#index", as: :task_list
    get "task-list/:task_id", to: "task_lists#edit", as: :edit_task
    put "task-list/:task_id", to: "task_lists#update", as: :update_task
  end

  concern :contactable do
    resources :contacts, path: :external_contacts, except: %i[show], concerns: :has_destroy_confirmation, controller: "/contacts"
  end

  concern :notable do
    resources :notes, except: %i[show], concerns: :has_destroy_confirmation, controller: "/notes"
  end

  concern :assignable do
    namespace :assign, controller: "/assignments" do
      get "team-lead", action: :assign_team_leader
      post "team-lead", action: :update_team_leader
      get "regional-delivery-officer", action: :assign_regional_delivery_officer
      post "regional-delivery-officer", action: :update_regional_delivery_officer
      get "caseworker", action: :assign_caseworker
      post "caseworker", action: :update_caseworker
    end
  end

  concern :informationable do
    get "information", to: "/project_information#show"
  end

  concern :completable do
    put "complete", to: "/projects_complete#complete"
  end

  namespace :conversions do
    get "/", to: "/conversions/projects#index"
    namespace :voluntary do
      get "/", to: "/conversions/voluntary/projects#index"
      resources :projects,
        only: %i[show new create],
        concerns: %i[task_listable contactable notable assignable informationable completable]
    end
    namespace :involuntary do
      get "/", to: "/conversions/involuntary/projects#index"
      resources :projects,
        only: %i[show new create],
        concerns: %i[task_listable contactable notable assignable informationable completable]
    end
  end

  resources :projects, only: %i[index show] do
    collection do
      get "completed"
    end
    get "information", to: "project_information#show"

    put "complete", to: "projects_complete#complete"

    get "internal_contacts", to: "assignments#show"

    resources :notes, except: %i[show], concerns: :has_destroy_confirmation
    resources :contacts, path: :external_contacts, except: %i[show], concerns: :has_destroy_confirmation

    namespace :assign, controller: "/assignments" do
      get "team-lead", action: :assign_team_leader
      post "team-lead", action: :update_team_leader
      get "regional-delivery-officer", action: :assign_regional_delivery_officer
      post "regional-delivery-officer", action: :update_regional_delivery_officer
      get "caseworker", action: :assign_caseworker
      post "caseworker", action: :update_caseworker
    end
  end

  get "cookies", to: "cookies#edit"
  post "cookies", to: "cookies#update"

  # High voltage configuration for static pages. Matches routes from the root of the domain. Uses
  # HighVoltage::Constraints::RootRoute to validate that the view exists.
  get "/*id" => "pages#show", :as => :page, :format => false, :constraints => HighVoltage::Constraints::RootRoute.new
end
