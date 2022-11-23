module EnvironmentBannerHelper
  ENVIRONMENT_COLOURS = {
    local_development: "purple",
    development: "turquoise",
    test: "orange"
  }.freeze.with_indifferent_access

  def environment_banner
    return if ENVIRONMENT_COLOURS.keys.none?(sentry_env)

    govuk_tag(
      text: "#{sentry_env.tr("_", " ").upcase} ENVIRONMENT",
      colour: ENVIRONMENT_COLOURS[sentry_env],
      classes: "environment-banner"
    )
  end

  private def sentry_env
    ENV.fetch("SENTRY_ENV", "local_development")
  end
end
