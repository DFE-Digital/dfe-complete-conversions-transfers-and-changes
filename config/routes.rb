Rails.application.routes.draw do
  get 'task/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "/tasks", to: "flow#task_list"
  get "/task/:slug", to: "flow#task"

  resources :project, only: [:new, :show] do
    resources :task, only: [:show, :update]
  end

end
