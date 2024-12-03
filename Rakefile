# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require "standard/rake"

Rails.application.load_tasks

if defined?(RSpec::Rails)
  Rake::Task[:default].clear
  task default: %i[standard erb_lint spec]
end
