class StaticPages
  def self.names
    %W[
      academies_api_client_timeout
      academies_api_client_unauthorised
      accessibility
      internal_server_error
      maintenance
      page_not_found
      privacy
    ]
  end
end

VALID_UUID_REGEX = /[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/i
MONTH_1_12_REGEX = /(?:1[0-2]|[1-9])/
YEAR_2000_2499_REGEX = /(?:(?:20|21|23|24)[0-9]{2})/

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Api => "/"

  # Swagger UI
  get "api/docs", to: "swagger#show"

  concern :has_destroy_confirmation do
    get "/delete", action: :confirm_destroy
  end

  concern :taskable do
    get "tasks", to: "tasks#index"
    get "tasks/:task_identifier", to: "tasks#edit", as: :edit_task
    put "tasks/:task_identifier", to: "tasks#update"
  end

  concern :external_contactable do
    resources :contacts, path: "external-contacts", except: %i[show], controller: :external_contacts, concerns: :has_destroy_confirmation, type: "Contact::Project"

    namespace :external_contacts, path: "external-contacts" do
      resource :headteacher, only: %i[create]
      resource :chair_of_governors, only: %i[create]
      resource :incoming_trust_ceo, only: %i[create]
      resource :outgoing_trust_ceo, only: %i[create]
      resource :other_contact, only: %i[create]
    end
  end

  concern :notable do
    resources :notes, except: %i[show], concerns: :has_destroy_confirmation, controller: "notes"
  end

  concern :assignable do
    namespace :internal_contacts, path: "internal-contacts" do
      get "assigned-user/edit", action: :edit_assigned_user
      put "assigned-user/", action: :update_assigned_user
      get "added-by-user/edit", action: :edit_added_by_user
      put "added-by-user/", action: :update_added_by_user
      get "team/edit", action: :edit_team
      put "team", action: :update_team
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

  concern :significant_date_historyable do
    resource :date_history, path: "date-history", only: %i[new create], controller: :date_history
    get "date-history", to: "date_history#index"

    namespace :date_history, path: "date-history" do
      namespace :reasons do
        resource :earlier, only: %i[create], controller: :earlier
        resource :later, only: %i[create], controller: :later
      end
    end
  end

  concern :academy_urn_updateable do
    get "academy-urn", to: "conversions/academy_urn#edit"
    post "academy-urn", to: "conversions/academy_urn#check"
    patch "academy-urn", to: "conversions/academy_urn#update_academy_urn"
  end

  concern :dao_revokable do
    get "dao-revocation", to: "dao_revocations#start", as: :dao_revocation_start
    get "dao-revocation/check", to: "dao_revocations#check", as: :dao_revocation_check
    post "dao-revocation/check", to: "dao_revocations#save"

    get "dao-revocation/:step", to: "dao_revocations#step", as: :dao_revocation_step
    get "dao-revocation/:step/change", to: "dao_revocations#change_step", as: :dao_revocation_change_step
    post "dao-revocation/:step", to: "dao_revocations#update_step", as: :dao_revocation_update_step
    patch "dao-revocation/:step/change", to: "dao_revocations#update_change_step", as: :dao_revocation_update_change_step
  end

  # A project
  constraints(id: VALID_UUID_REGEX) do
    resources :projects,
      only: %i[new create show],
      concerns: %i[
        taskable
        external_contactable
        notable
        assignable
        informationable
        completable
        internal_contactable
        significant_date_historyable
        academy_urn_updateable
        dao_revokable
      ]
    resources :projects, except: :destroy do
      get "confirm_delete", on: :member, action: :confirm_delete, as: :confirm_delete
      patch "/", on: :member, action: :delete, as: :delete
    end
  end

  # A single form a multi academy trust project group
  namespace :form_a_multi_academy_trust, path: "form-a-multi-academy-trust" do
    get "/:trn", to: "project_groups#show"
  end

  # New projects by type
  scope :projects do
    namespace :conversions do
      get "new", to: "projects#new"
      get "new_mat", to: "projects#new_mat"
      post "/", to: "projects#create"
      post "new_mat", to: "projects#create_mat", as: :create_mat
      get ":id/edit", to: "projects#edit", as: :edit
      post ":id/edit", to: "projects#update", as: :update
    end
    namespace :transfers do
      get "new", to: "projects#new"
      get "new_mat", to: "projects#new_mat"
      post "/", to: "projects#create"
      post "new_mat", to: "projects#create_mat", as: :create_mat
      get ":id", to: "projects#edit", as: :edit
      post ":id", to: "projects#update", as: :update
    end
  end

  # All projects
  resources :projects, only: %i[index] do
    collection do
      namespace :all do
        namespace :handover do
          get "/", to: "projects#index"
          get "/:project_id/check", to: "handovers#check", as: :check
          get "/:project_id/new", to: "handovers#new", as: :new
          post "/:project_id/new", to: "handovers#create"
          post "/:project_id/assign", to: "handovers#assign", as: :assign
        end
        namespace :in_progress, path: "in-progress" do
          get "all", to: "projects#all_index"
          get "conversions", to: "projects#conversions_index"
          get "transfers", to: "projects#transfers_index"
          get "form-a-multi-academy-trust", to: "projects#form_a_multi_academy_trust_index"
        end
      end
    end
  end

  constraints(id: VALID_UUID_REGEX) do
    resources :projects, only: %i[index] do
      collection do
        namespace :all do
          namespace :dao_revoked, path: "dao-revoked" do
            get "/", to: "projects#index"
          end
          namespace :completed do
            get "/", to: "projects#index"
          end
          namespace :by_month, path: "by-month" do
            namespace :conversions do
              get "from/to", to: "projects#date_range_this_month", as: :date_range_this_month
              post "from/to", to: "projects#date_range_select", as: :date_range_select
              get "from/:from_month/:from_year/to/:to_month/:to_year", to: "projects#date_range", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range
              get ":month/:year", to: "projects#single_month", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :single_month
              get "/", to: "projects#next_month", as: :next_month
            end
            namespace :transfers do
              get "from/to", to: "projects#date_range_this_month", as: :date_range_this_month
              post "from/to", to: "projects#date_range_select", as: :date_range_select
              get "from/:from_month/:from_year/to/:to_month/:to_year", to: "projects#date_range", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range
              get ":month/:year", to: "projects#single_month", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :single_month
              get "/", to: "projects#next_month", as: :next_month
            end
          end
          namespace :statistics do
            get "/", to: "statistics#index"
          end
          namespace :trusts do
            get "/", to: "projects#index"
            get "/ukprn/:trust_ukprn", to: "projects#show", as: :by_trust_ukprn
            get "/reference/:trust_reference_number", to: "projects#show_by_reference", as: :by_trust_reference
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
            resource :rpa_sug_and_fa_letters, only: %w[new create], path: "rpa-sug-and-fa-letters"
            resource :pre_conversion_grants, only: %w[new create], path: "pre-conversion-grants"
            resource :academies_due_to_transfer, only: %w[new create], path: "academies-due-to-transfer"
            resource :pre_transfer_grants, only: %w[new create], path: "pre-transfer-grants"

            get "/", to: "projects#index"
            namespace :by_significant_date, path: "by-significant-date" do
              namespace :transfers do
                namespace :all_data, path: "all-data" do
                  get "from/:from_month/:from_year/to/:to_month/:to_year/csv", to: "projects#date_range_csv", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range_csv
                  get ":month/:year/csv", to: "projects#single_month_csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :single_month_csv
                end
              end
              namespace :conversions do
                namespace :all_data, path: "all-data" do
                  get "from/:from_month/:from_year/to/:to_month/:to_year/csv", to: "projects#date_range_csv", constraints: {from_month: MONTH_1_12_REGEX, from_year: YEAR_2000_2499_REGEX, to_month: MONTH_1_12_REGEX, to_year: YEAR_2000_2499_REGEX}, as: :date_range_csv
                  get ":month/:year/csv", to: "projects#single_month_csv", constraints: {month: MONTH_1_12_REGEX, year: YEAR_2000_2499_REGEX}, as: :single_month_csv
                end
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

  # Project groups
  resources :groups, only: %i[index show], controller: :project_groups, as: :project_groups

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
  get "search/user/", to: "search#user"

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
  get "test-error" => "test_error#create", :as => :test_error

  get "*id" => "pages#show", :as => :page, :format => false,
    :constraints => lambda { |request|
                      StaticPages.names.include?(request.filtered_parameters[:id])
                    }

  match "*unmatched", to: "application#not_found_error", via: :all
end
