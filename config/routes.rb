VALID_UUID_REGEX = /[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/i
MONTH_1_12_REGEX = /(?:1[0-2]|[1-9])/
YEAR_2000_2499_REGEX = /(?:(?:20|21|23|24)[0-9]{2})/

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  concern :has_destroy_confirmation do
    get "/delete", action: :confirm_destroy
  end

  concern :taskable do
    get "tasks", to: "tasks#index"
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
    get "internal-contacts", to: "internal_contacts#index"
  end

  concern :memberable do
    get "mp", to: "member_of_parliament#show"
  end

  concern :significant_date_historyable do
    get "change-date", to: "date_histories#new"
    post "change-date", to: "date_histories#create"
  end

  concern :academy_urn_updateable do
    get "academy-urn", to: "conversions/academy_urn#edit"
    post "academy-urn", to: "conversions/academy_urn#check"
    patch "academy-urn", to: "conversions/academy_urn#update_academy_urn"
  end

  # A project
  constraints(id: VALID_UUID_REGEX) do
    resources :projects,
      only: %i[show],
      concerns: %i[
        taskable
        external_contactable
        notable
        assignable
        informationable
        completable
        internal_contactable
        significant_date_historyable
        memberable
        academy_urn_updateable
      ]
  end

  # New projects by type
  scope :projects do
    namespace :conversions do
      get "new", to: "projects#new"
      post "/", to: "projects#create"
      get ":id", to: "projects#edit", as: :edit
      post ":id", to: "projects#update", as: :update
    end
    namespace :transfers do
      get "new", to: "projects#new"
      post "/", to: "projects#create"
      get ":id", to: "projects#edit", as: :edit
      post ":id", to: "projects#update", as: :update
    end
  end

  # All projects
  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
      collection do
        namespace :all do
          namespace :in_progress, path: "in-progress" do
            get "/", to: "projects#index"
          end
          namespace :completed do
            get "/", to: "projects#index"
          end
          namespace :by_month, path: "by-month" do
            get "confirmed/", to: "projects#confirmed_next_month"
            get "confirmed/:month/:year", to: "projects#confirmed", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/:month/:year", to: "projects#revised", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/", to: "projects#revised_next_month"
            namespace :conversions do
              get "from/to", to: "projects#date_range_this_month", as: :date_range_this_month
              post "from/to", to: "projects#date_range_select", as: :date_range_select
              get "from/:from_month/:from_year/to/:to_month/:to_year", to: "projects#date_range", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range
            end
            namespace :transfers do
              get "from/to", to: "projects#date_range_this_month", as: :date_range_this_month
              post "from/to", to: "projects#date_range_select", as: :date_range_select
              get "from/:from_month/:from_year/to/:to_month/:to_year", to: "projects#date_range", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range
            end
          end
          namespace :statistics do
            get "/", to: "statistics#index"
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
            get "/", to: "projects#index"
            namespace :funding_agreement_letters, path: "funding-agreement-letters" do
              namespace :conversions do
                get "/", to: "projects#index"
                get ":month/:year", to: "projects#show", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :show
                get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
              end
            end
            namespace :education_and_skills_funding_agency, path: "esfa" do
              namespace :conversions do
                get "/", to: "projects#index"
                get ":month/:year", to: "projects#show", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :show
                get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
              end
            end
            namespace :grant_management_and_finance_unit, path: "grant-management-and-finance-unit" do
              namespace :conversions do
                get "/", to: "projects#index"
                get ":month/:year", to: "projects#show", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :show
                get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
              end
              namespace :transfers do
                get "/", to: "projects#index"
                get ":month/:year", to: "projects#show", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :show
                get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
              end
            end
            namespace :by_month, path: "by-month" do
              namespace :transfers do
                get "/", to: "projects#index"
                get ":month/:year", to: "projects#show", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :show
                get ":month/:year/csv", to: "projects#csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :csv
              end
            end
          end
        end
      end
    end
  end

  #  Your team projects
  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
      collection do
        namespace :team, path: "team" do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get "unassigned", to: "projects#unassigned"
          get "handed-over", to: "projects#handed_over"
          get "new", to: "projects#new"
          namespace :users do
            get "/", to: "projects#index"
            get "/:user_id", to: "projects#show", as: :by_user
          end
          namespace :by_month, path: "by-month" do
            get "confirmed/", to: "projects#confirmed_next_month"
            get "confirmed/:month/:year", to: "projects#confirmed", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/:month/:year", to: "projects#revised", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}
            get "revised/", to: "projects#revised_next_month"
          end
        end
      end
    end
  end

  # Your projects
  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
      collection do
        namespace :your, path: :yours do
          get "in-progress", to: "projects#in_progress"
          get "completed", to: "projects#completed"
          get "added-by", to: "projects#added_by"
        end
      end
    end
  end

  # Service support projects
  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
      collection do
        namespace :service_support, path: "service-support" do
          get "without-academy-urn", to: "projects#without_academy_urn", as: :without_academy_urn
          get "with-academy-urn", to: "projects#with_academy_urn", as: :with_academy_urn
        end
      end
    end
  end

  # service support
  scope "service-support" do
    resources :local_authorities, path: "local-authorities", concerns: :has_destroy_confirmation
  end

  namespace :service_support, path: "service-support" do
    namespace :upload do
      namespace :gias do
        get "establishments/new", to: "establishments#new"
        post "establishments/upload", to: "establishments#upload"
      end
    end
    resources :users, only: %w[new create edit update]
    get "users", to: redirect("service-support/users/active")
    get "users/active", to: "users#index_active"
    get "users/inactive", to: "users#index_inactive"
    get "users/team", to: "users#set_team"
    post "users/team", to: "users#update_team"
  end

  scope :projects do
    namespace :transfers do
      get "new", to: "projects#new"
      post "/", to: "projects#create"
    end
  end

  # Search
  get "search", to: "search#results"

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
