require "active_support/core_ext/integer/time"
require "application_insights"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # explicitly disable the CSS compressor
  config.assets.css_compressor = nil

  # compress the sass with sassc
  config.sass.style = :compressed

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # SQL server table config
  #
  # In production all out tables exist in a 'schema' called `complete` so we
  # tell Rails to look for it's internal tables there.
  config.active_record.schema_migrations_table_name = "#{ENV["SQL_SERVER_SCHEMA_NAME"]}.schema_migrations"
  config.active_record.internal_metadata_table_name = "#{ENV["SQL_SERVER_SCHEMA_NAME"]}.ar_internal_metadata"

  # configure the host names
  config.hosts << ENV["HOSTNAME"]
  config.hosts << IPAddr.new(ENV["CONTAINER_VNET"])
  config.hosts.concat ENV.fetch("ALLOWED_HOSTS", "").split(",")

  # configure ActionMailer
  # set the host so links in emails work
  # https://guides.rubyonrails.org/action_mailer_basics.html#generating-urls-in-action-mailer-views
  config.action_mailer.default_url_options = {host: ENV["HOSTNAME"]}

  # Use GOV.UK Notify to send email
  # https://github.com/dxw/mail-notify
  config.action_mailer.delivery_method = :notify
  config.action_mailer.notify_settings = {api_key: ENV["GOV_NOTIFY_API_KEY"]}

  # Use Sidekiq
  config.active_job.queue_adapter = :sidekiq

  # Use Application Insights if a key is available
  if (key = ENV.fetch("APPLICATION_INSIGHTS_KEY", nil))
    # send task intrumentation
    config.middleware.use ApplicationInsights::Rack::TrackRequest, key, 500, 60
    # send unhandled exceptions
    # ApplicationInsights::UnhandledException.collect(key)
  end
end
