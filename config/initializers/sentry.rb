if Rails.env.production?
  Sentry.init do |config|
    config.environment = ENV.fetch("SENTRY_ENV")
  end
end
