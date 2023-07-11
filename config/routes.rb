VALID_UUID_REGEX = /[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/i
MONTH_1_12_REGEX = /(?:1[0-2]|[1-9])/
YEAR_2000_2499_REGEX = /(?:(?:20|21|23|24)[0-9]{2})/

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  concern :has_destroy_confirmation do
    get "/delete", action: :confirm_destroy
  end

  concern :conversion_taskable do
    get "tasks", to: "conversions/tasks#index", as: :conversion_tasks
    get "tasks/:task_identifier", to: "tasks#edit", as: :edit_task
    put "tasks/:task_identifier", to: "tasks#update"
  end

  concern :external_contactable do
    resources :contacts, path: "external-contacts", except: %i[show], concerns: :has_destroy_confirmation, controller: :external_contacts, type: "Contact::Project"
  end

  concern :notable do
    resources :notes, except: %i[show], concerns: :has_destroy_confirmation, controller: "notes"
  end

  concern :assignable do
    namespace :assign, controller: "/assignments" do
      get "team-lead", action: :assign_team_leader
      post "team-lead", action: :update_team_leader
      get "regional-delivery-officer", action: :assign_regional_delivery_officer
      post "regional-delivery-officer", action: :update_regional_delivery_officer
      get "assigned-to", action: :assign_assigned_to
      post "assigned-to", action: :update_assigned_to
      get "team", action: :assign_team
      post "team", action: :update_team
    end
  end

  concern :informationable do
    get "information", to: "project_information#show"
  end

  concern :completable do
    put "complete", to: "projects_complete#complete"
  end

  concern :internal_contactable do
    get "internal-contacts", to: "internal_contacts#show"
  end

  concern :memberable do
    get "mp", to: "member_of_parliament#show"
  end

  concern :conversion_date_historyable do
    get "conversion-date", to: "conversions/date_histories#new"
    post "conversion-date", to: "conversions/date_histories#create"
  end

  concern :academy_urn_updateable do
    get "academy-urn", to: "conversions/academy_urn#edit"
    post "academy-urn", to: "conversions/academy_urn#check"
    patch "academy-urn", to: "conversions/academy_urn#update_academy_urn"
  end

  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
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
          namespace :opening do
            get "confirmed/", to: "projects#confirmed_next_month"
            get "confirmed/:month/:year", to: "projects#confirmed", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/:month/:year", to: "projects#revised", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/", to: "projects#revised_next_month"
          end
          namespace :statistics do
            get "/", to: "projects#index"
          end
          namespace :trusts do
            get "/", to: "projects#index"
            get ":trust_ukprn", to: "projects#show", as: :by_trust
          end
          namespace :local_authorities, path: "local-authorities" do
            get "/", to: "projects#index"
            get ":local_authority_id", to: "projects#show", as: :by_local_authority
          end
          namespace :regions do
            get "/", to: "projects#index"
            get ":region_id", to: "projects#show", as: :by_region
          end
          namespace :users do
            get "/", to: "projects#index"
            get ":user_id", to: "projects#show", as: :by_user, constraints: {user_id: VALID_UUID_REGEX}
          end
          namespace :export do
            namespace :funding_agreement_letters, path: "funding-agreement-letters" do
              get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
            end
            namespace :risk_protection_arrangement, path: "risk-protection-arrangement" do
              get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
            end
          end
        end
        namespace :team, path: "team" do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get "unassigned", to: "projects#unassigned"
          get "users", to: "projects#users"
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

        namespace :service_support, path: "service-support" do
          get "without-academy-urn", to: "projects#without_academy_urn", as: :without_academy_urn
          get "with-academy-urn", to: "projects#with_academy_urn", as: :with_academy_urn
        end

        get "unassigned"
      end
    end
  end

  scope "service-support" do
    resources :local_authorities, path: "local-authorities", concerns: :has_destroy_confirmation
  end

  # Projects - all projects are conversions right now
  constraints(id: VALID_UUID_REGEX) do
    resources :projects,
      only: %i[show],
      concerns: %i[
        conversion_taskable
        external_contactable
        notable
        assignable
        informationable
        completable
        internal_contactable
        conversion_date_historyable
        memberable
        academy_urn_updateable
      ]
  end

  scope :projects do
    namespace :conversions do
      get "/", to: "projects#index"
      post "/", to: "projects#create"
      get "new", to: "projects#new"
    end
  end

  resources :users, only: %w[new create edit update]
  get "users", to: redirect("users/active")
  get "users/active", to: "users#index_active"
  get "users/inactive", to: "users#index_inactive"
  get "users/team", to: "users#set_team"
  post "users/team", to: "users#update_team"

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

  get "cookies", to: "cookies#edit"
  post "cookies", to: "cookies#update"

  get "healthcheck" => "healthcheck#check"

  # High voltage configuration for static pages. Matches routes from the root of the domain. Uses
  # HighVoltage::Constraints::RootRoute to validate that the view exists.
  get "/*id" => "pages#show", :as => :page, :format => false, :constraints => HighVoltage::Constraints::RootRoute.new

  match "*unmatched", to: "application#not_found_error", via: :all
end
