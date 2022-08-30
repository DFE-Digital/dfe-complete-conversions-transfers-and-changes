Sentry.init do |config|
  config.environment = ENV.fetch("SENTRY_ENV")
end
