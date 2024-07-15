require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

require "govuk/components"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DfeCompleteConversionsTransfersAndChanges
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.exceptions_app = routes

    config.support_email = "regionalservices.rg@education.gov.uk"

    # setup Redis cache in all environments
    config.cache_store = :redis_cache_store, {url: ENV["REDIS_URL"]}

    # use the cookies for the session and set the name of the cookie
    config.session_store :cookie_store, key: "SESSION"

    # set the X-Frame-Options header
    config.action_dispatch.default_headers["X-Frame-Options"] = "DENY"
    # set the HSTS header
    config.action_dispatch.default_headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains; preload"
  end
end
