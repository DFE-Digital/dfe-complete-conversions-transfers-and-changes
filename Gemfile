source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use MS SQL Server  as the database for Active Record
# https://github.com/rails-sqlserver/activerecord-sqlserver-adapter
gem "activerecord-sqlserver-adapter"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sass-rails"

# Use Omniauth for authentication
gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "omniauth-azure-activedirectory-v2"

# Use pundit for authorisation management
gem "pundit", "~> 2.2"

# Use DfE's design component libraries
gem "govuk-components", "~> 3.1"
gem "govuk_design_system_formbuilder", "~> 3.1"

# Use govuk_markdown to transform Markdown into GOV.UK Frontend-compliant HTML
gem "govuk_markdown"

gem "faraday"

# sentry.io error reporting 
gem "sentry-ruby"
gem "sentry-rails"

gem "sidekiq"

gem "pagy"

gem "mail-notify"

gem "high_voltage"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "rspec-rails"
  gem "brakeman"
  gem "bullet"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
end

group :test do
  gem "capybara"
  gem "climate_control"
  gem "simplecov", "~> 0.21.2"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.1"
  gem "webmock", "~> 3.17"
end

group :linting do
  gem "standard"
  gem "erb_lint", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
