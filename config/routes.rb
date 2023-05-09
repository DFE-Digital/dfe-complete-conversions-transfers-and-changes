VALID_UUID_REGEX = /[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/i
MONTH_1_12_REGEX = /(?:1[0-2]|[1-9])/
YEAR_2000_2499_REGEX = /(?:(?:20|21|23|24)[0-9]{2})/

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "root#home"

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
      get "assigned_to", action: :assign_assigned_to
      post "assigned_to", action: :update_assigned_to
    end
  end

  concern :informationable do
    get "information", to: "/project_information#show"
  end

  concern :completable do
    put "complete", to: "/projects_complete#complete"
  end

  concern :internal_contactable do
    get "internal_contacts", to: "/internal_contacts#show"
  end

  concern :memberable do
    get "mp", to: "/member_of_parliament#show"
  end

  concern :conversion_date_historyable do
    get "conversion-date", to: "/conversions/date_histories#new"
    post "conversion-date", to: "/conversions/date_histories#create"
  end

  concern :academy_urn_updateable do
    get "academy-urn", to: "/conversions/academy_urn#edit"
    post "academy-urn", to: "/conversions/academy_urn#check"
    patch "academy-urn", to: "/conversions/academy_urn#update_academy_urn"
  end

  constraints(id: VALID_UUID_REGEX) do
    namespace :conversions do
      get "/", to: "/conversions/projects#index"
      namespace :voluntary do
        get "/", to: "/conversions/voluntary/projects#index"
        get "projects/:id", to: "/conversions/voluntary/projects#show", as: :project

        resources :projects,
          only: %i[new create],
          concerns: %i[task_listable contactable notable assignable informationable completable internal_contactable conversion_date_historyable memberable academy_urn_updateable]
      end
    end
  end

  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[show] do
      collection do
        namespace :all do
          namespace :in_progress, path: "in-progress" do
            get "/", to: "projects#index"
            get "voluntary", to: "projects#voluntary"
            get "sponsored", to: "projects#sponsored"
          end
          namespace :completed do
            get "/", to: "projects#index"
            get "voluntary", to: "projects#voluntary"
            get "sponsored", to: "projects#sponsored"
          end
          namespace :conversion_date_changed, path: "conversion-date-changed" do
            get "/:month/:year", to: "projects#index", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
          end
          namespace :statistics do
            get "/", to: "projects#index"
          end

          get "new", to: "projects#new", as: :new
          get "with_academy_urn", to: "projects#with_academy_urn", as: :with_academy_urn
        end
        namespace :regional_casework_services, path: "regional-casework-services" do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get "unassigned", to: "projects#unassigned"
        end
        namespace :regional, path: "regional" do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get ":region/in-progress", to: "projects#in_progress_by_region", as: :in_progress_by_region
          get ":region/completed", to: "projects#completed_by_region", as: :completed_by_region
        end
        namespace :user do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get "added-by", to: "projects#added_by"
        end
        get "unassigned"

        get "openers/:month/:year", to: "projects_openers#openers", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :openers
      end
      get "information", to: "project_information#show"

      put "complete", to: "projects_complete#complete"

      resources :notes, except: %i[show], concerns: :has_destroy_confirmation
      resources :contacts, path: :external_contacts, except: %i[show], concerns: :has_destroy_confirmation

      namespace :assign, controller: "/assignments" do
        get "team-lead", action: :assign_team_leader
        post "team-lead", action: :update_team_leader
        get "regional-delivery-officer", action: :assign_regional_delivery_officer
        post "regional-delivery-officer", action: :update_regional_delivery_officer
        get "assigned_to", action: :assign_assigned_to
        post "assigned_to", action: :update_assigned_to
      end
    end
  end

  scope :new_tasks do
    get ":project_id/tasks", to: "conversions/tasks#index", as: :conversions_tasks
    get ":project_id/tasks/:task_identifier", to: "tasks#edit", as: :edit_task
    put ":project_id/tasks/:task_identifier", to: "tasks#update", as: :update_task
  end

  resources :local_authorities, path: "local-authorities", concerns: :has_destroy_confirmation

  get "cookies", to: "cookies#edit"
  post "cookies", to: "cookies#update"

  get "healthcheck" => "healthcheck#check"

  # High voltage configuration for static pages. Matches routes from the root of the domain. Uses
  # HighVoltage::Constraints::RootRoute to validate that the view exists.
  get "/*id" => "pages#show", :as => :page, :format => false, :constraints => HighVoltage::Constraints::RootRoute.new

  match "*unmatched", to: "application#not_found_error", via: :all
end
